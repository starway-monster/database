CREATE TABLE public.blocks_log (
    zone character varying NOT NULL,
    last_processed_block integer DEFAULT 0 NOT NULL,
    last_updated_at timestamp without time zone DEFAULT now() NOT NULL
);
CREATE TABLE public.ibc_channels (
    zone character varying NOT NULL,
    connection_id character varying NOT NULL,
    channel_id character varying NOT NULL,
    is_opened boolean NOT NULL,
    added_at timestamp without time zone DEFAULT now() NOT NULL
);
CREATE TABLE public.ibc_clients (
    zone character varying NOT NULL,
    client_id character varying NOT NULL,
    chain_id character varying NOT NULL,
    added_at timestamp without time zone DEFAULT now() NOT NULL
);
CREATE TABLE public.ibc_connections (
    zone character varying NOT NULL,
    connection_id character varying NOT NULL,
    client_id character varying NOT NULL,
    added_at timestamp without time zone DEFAULT now() NOT NULL
);
CREATE TABLE public.zones (
    name character varying NOT NULL,
    chain_id character varying NOT NULL,
    description character varying,
    is_enabled boolean NOT NULL,
    added_at timestamp without time zone DEFAULT now() NOT NULL,
    is_caught_up boolean NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE ONLY public.blocks_log
    ADD CONSTRAINT blocks_log_hub_pkey PRIMARY KEY (zone);
ALTER TABLE ONLY public.ibc_channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (zone, channel_id);
ALTER TABLE ONLY public.ibc_connections
    ADD CONSTRAINT connections_pkey PRIMARY KEY (zone, connection_id);
ALTER TABLE ONLY public.ibc_clients
    ADD CONSTRAINT ibc_clients_pkey PRIMARY KEY (zone, client_id);
ALTER TABLE ONLY public.zones
    ADD CONSTRAINT zones_pkey PRIMARY KEY (chain_id);
ALTER TABLE ONLY public.blocks_log
    ADD CONSTRAINT blocks_log_zone_fkey FOREIGN KEY (zone) REFERENCES public.zones(chain_id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.ibc_channels
    ADD CONSTRAINT channels_source_connection_id_fkey FOREIGN KEY (zone, connection_id) REFERENCES public.ibc_connections(zone, connection_id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.ibc_connections
    ADD CONSTRAINT connections_source_client_id_fkey FOREIGN KEY (zone, client_id) REFERENCES public.ibc_clients(zone, client_id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.ibc_clients
    ADD CONSTRAINT ibc_clients_chain_id_fkey FOREIGN KEY (chain_id) REFERENCES public.zones(chain_id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.ibc_clients
    ADD CONSTRAINT ibc_clients_zone_fkey FOREIGN KEY (zone) REFERENCES public.zones(chain_id) ON UPDATE RESTRICT ON DELETE RESTRICT;
