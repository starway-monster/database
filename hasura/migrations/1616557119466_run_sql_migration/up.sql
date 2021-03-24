CREATE OR REPLACE FUNCTION public.get_ibc_chain_graph_edges()
 RETURNS SETOF fn_table_ibc_chain_graph_edges
 LANGUAGE sql
 STABLE
AS $function$
with channels_w_duplicates as (
select distinct
    channels.zone zone_a,
    clients.chain_id zone_b
from
    ibc_channels as channels
inner join ibc_connections as connections
    on channels.connection_id = connections.connection_id and channels.zone = connections.zone
inner join ibc_clients as clients
    on channels.zone = clients.zone and connections.client_id = clients.client_id
where is_opened = true
), joined_channels as (
select
    zone_a,
    zone_b
from
    channels_w_duplicates
union all
select
    zone_b as zone_a,
    zone_a as zone_b
from
    channels_w_duplicates
)
select distinct
    zone_a as zone,
    zone_b as counterparty_zone
from
    joined_channels
where
    zone_a > zone_b
$function$;
