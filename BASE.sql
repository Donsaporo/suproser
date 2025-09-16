-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict bOkjDpGfbRrddwoJbSzGXMehkl7yPZo1gWJNt4ibpfHptiB08MUujsK9CpTDem7

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.6 (Debian 17.6-1.pgdg12+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA supabase_migrations;


ALTER SCHEMA supabase_migrations OWNER TO postgres;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: admin_get_client_users(text, uuid, uuid, text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.admin_get_client_users(search_term text DEFAULT NULL::text, client_filter uuid DEFAULT NULL::uuid, branch_filter uuid DEFAULT NULL::uuid, role_filter text DEFAULT NULL::text, page_num integer DEFAULT 1, page_size integer DEFAULT 25) RETURNS TABLE(id uuid, user_id uuid, client_id uuid, branch_id uuid, role_in_client text, created_at timestamp with time zone, client_name text, branch_name text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  offset_val integer := (page_num - 1) * page_size;
BEGIN
  -- Check admin role
  IF NOT EXISTS (
    SELECT 1 FROM public.user_profiles up
    WHERE up.user_id = auth.uid() AND up.role_app = 'admin'
  ) THEN
    RAISE EXCEPTION 'Access denied: admin role required';
  END IF;

  RETURN QUERY
  SELECT 
    cu.id,
    cu.user_id,
    cu.client_id,
    cu.branch_id,
    cu.role_in_client,
    cu.created_at,
    c.name as client_name,
    cb.name as branch_name
  FROM client_users cu
  JOIN clients c ON c.id = cu.client_id
  LEFT JOIN client_branches cb ON cb.id = cu.branch_id
  WHERE 
    (client_filter IS NULL OR cu.client_id = client_filter)
    AND (branch_filter IS NULL OR cu.branch_id = branch_filter)
    AND (role_filter IS NULL OR cu.role_in_client = role_filter)
  ORDER BY cu.created_at DESC
  LIMIT page_size
  OFFSET offset_val;
END;
$$;


ALTER FUNCTION public.admin_get_client_users(search_term text, client_filter uuid, branch_filter uuid, role_filter text, page_num integer, page_size integer) OWNER TO postgres;

--
-- Name: admin_get_clients(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.admin_get_clients(search_query text DEFAULT NULL::text) RETURNS TABLE(id uuid, name text, tax_id text, billing_email text, created_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Check admin access
  IF NOT public.is_current_user_admin() THEN
    RAISE EXCEPTION 'Access denied: Admin role required';
  END IF;

  RETURN QUERY
  SELECT 
    c.id,
    c.name,
    c.tax_id,
    c.billing_email,
    c.created_at
  FROM public.clients c
  WHERE (
    search_query IS NULL 
    OR c.name ILIKE '%' || search_query || '%'
  )
  ORDER BY c.name ASC;
END;
$$;


ALTER FUNCTION public.admin_get_clients(search_query text) OWNER TO postgres;

--
-- Name: admin_get_dashboard_stats(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.admin_get_dashboard_stats() RETURNS TABLE(total_products bigint, total_categories bigint, total_clients bigint, total_orders bigint, orders_borrador bigint, orders_pendiente_aprobacion bigint, orders_aprobado bigint, orders_pagado bigint, orders_en_preparacion bigint, orders_despachado bigint, orders_completado bigint, orders_anulado bigint, recent_status jsonb, recent_payments jsonb)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'auth'
    AS $$
BEGIN
  IF public.get_user_role(auth.uid()) <> 'admin' THEN
    RAISE EXCEPTION 'not_authorized';
  END IF;

  RETURN QUERY
  WITH
    o_counts AS (
      SELECT
        COUNT(*)::bigint AS total_orders,
        COUNT(*) FILTER (WHERE status='borrador')::bigint                AS orders_borrador,
        COUNT(*) FILTER (WHERE status='pendiente_aprobacion')::bigint    AS orders_pendiente_aprobacion,
        COUNT(*) FILTER (WHERE status='aprobado')::bigint                AS orders_aprobado,
        COUNT(*) FILTER (WHERE status='pagado')::bigint                  AS orders_pagado,
        COUNT(*) FILTER (WHERE status='en_preparacion')::bigint          AS orders_en_preparacion,
        COUNT(*) FILTER (WHERE status='despachado')::bigint              AS orders_despachado,
        COUNT(*) FILTER (WHERE status='completado')::bigint              AS orders_completado,
        COUNT(*) FILTER (WHERE status='anulado')::bigint                 AS orders_anulado
      FROM public.orders
    ),
    r_status AS (
      SELECT COALESCE(
        jsonb_agg(jsonb_build_object(
          'id', id,
          'order_id', order_id,
          'from_status', from_status,
          'to_status', to_status,
          'at', at
        ) ORDER BY at DESC),
        '[]'::jsonb
      ) AS js
      FROM (
        SELECT id, order_id, from_status, to_status, at
        FROM public.order_status_history
        ORDER BY at DESC
        LIMIT 10
      ) t
    ),
    r_payments AS (
      SELECT COALESCE(
        jsonb_agg(jsonb_build_object(
          'id', id,
          'order_id', order_id,
          'method', method,
          'status', status,
          'amount', amount,
          'created_at', created_at
        ) ORDER BY created_at DESC),
        '[]'::jsonb
      ) AS js
      FROM (
        SELECT id, order_id, method, status, amount, created_at
        FROM public.payments
        ORDER BY created_at DESC
        LIMIT 10
      ) p
    )
  SELECT
    (SELECT COUNT(*) FROM public.products)::bigint    AS total_products,
    (SELECT COUNT(*) FROM public.categories)::bigint  AS total_categories,
    (SELECT COUNT(*) FROM public.clients)::bigint     AS total_clients,
    oc.total_orders,
    oc.orders_borrador,
    oc.orders_pendiente_aprobacion,
    oc.orders_aprobado,
    oc.orders_pagado,
    oc.orders_en_preparacion,
    oc.orders_despachado,
    oc.orders_completado,
    oc.orders_anulado,
    rs.js AS recent_status,
    rp.js AS recent_payments
  FROM o_counts oc, r_status rs, r_payments rp;
END;
$$;


ALTER FUNCTION public.admin_get_dashboard_stats() OWNER TO postgres;

--
-- Name: admin_get_payments(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.admin_get_payments(page_offset integer DEFAULT 0, page_limit integer DEFAULT 20) RETURNS TABLE(id uuid, order_id uuid, method text, provider_ref text, status text, amount numeric, created_at timestamp with time zone, client_name text, order_status text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Check admin access
  IF NOT public.is_current_user_admin() THEN
    RAISE EXCEPTION 'Access denied: Admin role required';
  END IF;

  RETURN QUERY
  SELECT 
    p.id,
    p.order_id,
    p.method,
    p.provider_ref,
    p.status,
    p.amount,
    p.created_at,
    c.name as client_name,
    o.status as order_status
  FROM public.payments p
  LEFT JOIN public.orders o ON o.id = p.order_id
  LEFT JOIN public.clients c ON c.id = o.client_id
  ORDER BY p.created_at DESC
  OFFSET page_offset
  LIMIT page_limit;
END;
$$;


ALTER FUNCTION public.admin_get_payments(page_offset integer, page_limit integer) OWNER TO postgres;

--
-- Name: admin_get_price_overrides(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.admin_get_price_overrides() RETURNS TABLE(id uuid, client_id uuid, product_id uuid, discount_pct numeric, custom_price numeric, created_at timestamp with time zone, client_name text, product_name text, product_list_price numeric)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Check admin access
  IF NOT public.is_current_user_admin() THEN
    RAISE EXCEPTION 'Access denied: Admin role required';
  END IF;

  RETURN QUERY
  SELECT 
    po.id,
    po.client_id,
    po.product_id,
    po.discount_pct,
    po.custom_price,
    po.created_at,
    c.name as client_name,
    p.name as product_name,
    p.list_price as product_list_price
  FROM public.price_overrides po
  LEFT JOIN public.clients c ON c.id = po.client_id
  LEFT JOIN public.products p ON p.id = po.product_id
  ORDER BY po.created_at DESC;
END;
$$;


ALTER FUNCTION public.admin_get_price_overrides() OWNER TO postgres;

--
-- Name: admin_get_recent_orders(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.admin_get_recent_orders() RETURNS TABLE(id uuid, status text, total numeric, created_at timestamp with time zone, client_id uuid, client_name text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Check admin access
  IF NOT public.is_current_user_admin() THEN
    RAISE EXCEPTION 'Access denied: Admin role required';
  END IF;

  RETURN QUERY
  SELECT 
    o.id,
    o.status,
    o.total,
    o.created_at,
    o.client_id,
    c.name as client_name
  FROM public.orders o
  LEFT JOIN public.clients c ON c.id = o.client_id
  ORDER BY o.created_at DESC
  LIMIT 10;
END;
$$;


ALTER FUNCTION public.admin_get_recent_orders() OWNER TO postgres;

--
-- Name: admin_get_status_changes(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.admin_get_status_changes() RETURNS TABLE(id bigint, order_id uuid, from_status text, to_status text, at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Check admin access
  IF NOT public.is_current_user_admin() THEN
    RAISE EXCEPTION 'Access denied: Admin role required';
  END IF;

  RETURN QUERY
  SELECT 
    osh.id,
    osh.order_id,
    osh.from_status,
    osh.to_status,
    osh.at
  FROM public.order_status_history osh
  ORDER BY osh.at DESC
  LIMIT 10;
END;
$$;


ALTER FUNCTION public.admin_get_status_changes() OWNER TO postgres;

--
-- Name: admin_manage_category(text, jsonb, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.admin_manage_category(action_type text, category_data jsonb DEFAULT '{}'::jsonb, category_id_param uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  result jsonb;
BEGIN
  -- Check if current user is admin
  IF NOT public.is_current_user_admin() THEN
    RAISE EXCEPTION 'Access denied: Admin role required';
  END IF;

  CASE action_type
    WHEN 'create' THEN
      INSERT INTO public.categories (name, slug)
      VALUES (
        category_data->>'name',
        category_data->>'slug'
      )
      RETURNING jsonb_build_object('id', id, 'created', true) INTO result;
      
    WHEN 'update' THEN
      UPDATE public.categories
      SET 
        name = category_data->>'name',
        slug = category_data->>'slug'
      WHERE id = category_id_param
      RETURNING jsonb_build_object('id', id, 'updated', true) INTO result;
      
    WHEN 'delete' THEN
      DELETE FROM public.categories WHERE id = category_id_param
      RETURNING jsonb_build_object('id', id, 'deleted', true) INTO result;
      
    ELSE
      RAISE EXCEPTION 'Invalid action_type: %', action_type;
  END CASE;
  
  RETURN result;
END;
$$;


ALTER FUNCTION public.admin_manage_category(action_type text, category_data jsonb, category_id_param uuid) OWNER TO postgres;

--
-- Name: admin_manage_product(text, jsonb, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.admin_manage_product(action_type text, product_data jsonb DEFAULT '{}'::jsonb, product_id_param uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  result jsonb;
BEGIN
  -- Check if current user is admin
  IF NOT public.is_current_user_admin() THEN
    RAISE EXCEPTION 'Access denied: Admin role required';
  END IF;

  CASE action_type
    WHEN 'create' THEN
      INSERT INTO public.products (
        category_id, name, slug, description, unit, list_price, active
      )
      VALUES (
        (product_data->>'category_id')::uuid,
        product_data->>'name',
        product_data->>'slug',
        product_data->>'description',
        product_data->>'unit',
        (product_data->>'list_price')::numeric,
        COALESCE((product_data->>'active')::boolean, true)
      )
      RETURNING jsonb_build_object('id', id, 'created', true) INTO result;
      
    WHEN 'update' THEN
      UPDATE public.products
      SET 
        category_id = (product_data->>'category_id')::uuid,
        name = product_data->>'name',
        slug = product_data->>'slug',
        description = product_data->>'description',
        unit = product_data->>'unit',
        list_price = (product_data->>'list_price')::numeric,
        active = COALESCE((product_data->>'active')::boolean, true)
      WHERE id = product_id_param
      RETURNING jsonb_build_object('id', id, 'updated', true) INTO result;
      
    WHEN 'delete' THEN
      DELETE FROM public.products WHERE id = product_id_param
      RETURNING jsonb_build_object('id', id, 'deleted', true) INTO result;
      
    ELSE
      RAISE EXCEPTION 'Invalid action_type: %', action_type;
  END CASE;
  
  RETURN result;
END;
$$;


ALTER FUNCTION public.admin_manage_product(action_type text, product_data jsonb, product_id_param uuid) OWNER TO postgres;

--
-- Name: admin_manage_user_profile(text, uuid, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.admin_manage_user_profile(action_type text, target_user_id uuid, profile_data jsonb DEFAULT '{}'::jsonb) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  result jsonb;
BEGIN
  -- Check if current user is admin
  IF NOT public.is_current_user_admin() THEN
    RAISE EXCEPTION 'Access denied: Admin role required';
  END IF;

  CASE action_type
    WHEN 'upsert' THEN
      INSERT INTO public.user_profiles (
        user_id, 
        role_app, 
        display_name,
        phone
      )
      VALUES (
        target_user_id,
        profile_data->>'role_app',
        profile_data->>'display_name',
        profile_data->>'phone'
      )
      ON CONFLICT (user_id) 
      DO UPDATE SET 
        role_app = EXCLUDED.role_app,
        display_name = COALESCE(EXCLUDED.display_name, public.user_profiles.display_name),
        phone = COALESCE(EXCLUDED.phone, public.user_profiles.phone)
      RETURNING jsonb_build_object('user_id', user_id, 'upserted', true) INTO result;
      
    WHEN 'update_role' THEN
      UPDATE public.user_profiles
      SET role_app = profile_data->>'role_app'
      WHERE user_id = target_user_id
      RETURNING jsonb_build_object('user_id', user_id, 'role_updated', true) INTO result;
      
    ELSE
      RAISE EXCEPTION 'Invalid action_type: %', action_type;
  END CASE;
  
  RETURN result;
END;
$$;


ALTER FUNCTION public.admin_manage_user_profile(action_type text, target_user_id uuid, profile_data jsonb) OWNER TO postgres;

--
-- Name: admin_search_users(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.admin_search_users(search_query text) RETURNS TABLE(user_id uuid, email character varying, display_name text, role_app text, created_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'auth'
    AS $$
BEGIN
  -- Solo Admin puede usar esta función
  IF public.get_user_role(auth.uid()) != 'admin' THEN
    RAISE EXCEPTION 'access_denied';
  END IF;

  -- Validar entrada
  IF search_query IS NULL OR trim(search_query) = '' THEN
    RETURN;
  END IF;

  RETURN QUERY
  SELECT 
    au.id,
    au.email,  -- varchar(255) from auth.users
    COALESCE(up.display_name, split_part(au.email, '@', 1)) as display_name,
    up.role_app,
    COALESCE(up.created_at, au.created_at) as created_at
  FROM auth.users au
  LEFT JOIN public.user_profiles up ON up.user_id = au.id
  WHERE 
    -- Búsqueda por email (parcial, case insensitive)
    au.email ILIKE '%' || trim(search_query) || '%'
    
    -- O por display_name si existe
    OR (up.display_name IS NOT NULL AND up.display_name ILIKE '%' || trim(search_query) || '%')
    
    -- O por user_id (exacto o prefijo)
    OR au.id::text LIKE trim(search_query) || '%'
    OR au.id::text = trim(search_query)
  ORDER BY 
    -- Prioridad: coincidencia exacta email > display_name > prefijo
    CASE 
      WHEN lower(au.email) = lower(trim(search_query)) THEN 1
      WHEN au.id::text = trim(search_query) THEN 2  
      WHEN au.email ILIKE trim(search_query) || '%' THEN 3
      WHEN up.display_name ILIKE trim(search_query) || '%' THEN 4
      ELSE 5
    END,
    au.created_at DESC
  LIMIT 50;  -- Límite razonable para evitar sobrecarga
END;
$$;


ALTER FUNCTION public.admin_search_users(search_query text) OWNER TO postgres;

--
-- Name: calculate_order_totals(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_order_totals(order_uuid uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  new_subtotal numeric(12,2);
BEGIN
  SELECT COALESCE(SUM(line_total), 0)
    INTO new_subtotal
    FROM public.order_items
   WHERE order_id = order_uuid;

  UPDATE public.orders
     SET subtotal = new_subtotal,
         total    = new_subtotal,
         updated_at = now()
   WHERE id = order_uuid;
END;
$$;


ALTER FUNCTION public.calculate_order_totals(order_uuid uuid) OWNER TO postgres;

--
-- Name: get_user_role(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_role(user_uuid uuid) RETURNS text
    LANGUAGE sql STABLE
    AS $$
  SELECT role_app FROM public.user_profiles WHERE user_id = user_uuid
$$;


ALTER FUNCTION public.get_user_role(user_uuid uuid) OWNER TO postgres;

--
-- Name: is_admin(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_admin() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_profiles
    WHERE user_id = auth.uid() AND role_app = 'admin'
  );
$$;


ALTER FUNCTION public.is_admin() OWNER TO postgres;

--
-- Name: is_current_user_admin(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_current_user_admin() RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_profiles 
    WHERE user_id = auth.uid() 
    AND role_app = 'admin'
  );
END;
$$;


ALTER FUNCTION public.is_current_user_admin() OWNER TO postgres;

--
-- Name: is_gerente(uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_gerente(p_client uuid, p_branch uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.client_users
    WHERE user_id = auth.uid()
      AND client_id = p_client
      AND branch_id = p_branch
      AND role_in_client = 'gerente_sucursal'
  );
$$;


ALTER FUNCTION public.is_gerente(p_client uuid, p_branch uuid) OWNER TO postgres;

--
-- Name: is_master(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_master(p_client uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.client_users
    WHERE user_id = auth.uid()
      AND client_id = p_client
      AND role_in_client = 'master'
  );
$$;


ALTER FUNCTION public.is_master(p_client uuid) OWNER TO postgres;

--
-- Name: is_master_of_client(uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_master_of_client(p_user uuid, p_client uuid) RETURNS boolean
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.client_users
    WHERE user_id = p_user
      AND client_id = p_client
      AND role_in_client = 'master'
  );
$$;


ALTER FUNCTION public.is_master_of_client(p_user uuid, p_client uuid) OWNER TO postgres;

--
-- Name: FUNCTION is_master_of_client(p_user uuid, p_client uuid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.is_master_of_client(p_user uuid, p_client uuid) IS 'Devuelve true si el usuario es MASTER del cliente. SECURITY DEFINER para evitar recursión en políticas.';


--
-- Name: log_security_event(uuid, text, text, text, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_security_event(actor uuid, action text, entity text, entity_id text, meta jsonb DEFAULT '{}'::jsonb) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  INSERT INTO public.audit_log (actor_user_id, action, entity, entity_id, meta)
  VALUES (actor, action, entity, entity_id, meta);
END;
$$;


ALTER FUNCTION public.log_security_event(actor uuid, action text, entity text, entity_id text, meta jsonb) OWNER TO postgres;

--
-- Name: master_assign_client_user(uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.master_assign_client_user(p_user_id uuid, p_branch_id uuid) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'auth'
    AS $$
DECLARE
  v_client uuid;
  v_id     uuid;
  v_result json;
BEGIN
  -- Verificar MASTER y obtener su client_id
  SELECT cu.client_id
    INTO v_client
  FROM public.client_users cu
  WHERE cu.user_id = auth.uid() AND cu.role_in_client = 'master'
  LIMIT 1;

  IF v_client IS NULL THEN
    RAISE EXCEPTION 'not_authorized';
  END IF;

  -- Validar que la sucursal pertenece a su empresa
  IF NOT EXISTS (
    SELECT 1 FROM public.client_branches b
    WHERE b.id = p_branch_id AND b.client_id = v_client
  ) THEN
    RAISE EXCEPTION 'branch_not_in_client';
  END IF;

  -- Verificar que el usuario existe
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE id = p_user_id) THEN
    RAISE EXCEPTION 'user_not_found';
  END IF;

  -- Asegurar user_profiles (rol NULL) si no existe
  INSERT INTO public.user_profiles (user_id, role_app)
  VALUES (p_user_id, 'cliente_gerente_sucursal')
  ON CONFLICT (user_id) DO UPDATE SET role_app = 'cliente_gerente_sucursal';

  -- Verificar si ya está asignado a otra sucursal en la misma empresa
  IF EXISTS (
    SELECT 1 FROM public.client_users cu
    WHERE cu.user_id = p_user_id
      AND cu.client_id = v_client
      AND cu.role_in_client = 'gerente_sucursal'
      AND cu.branch_id != p_branch_id
  ) THEN
    -- Update existing assignment to new branch
    UPDATE public.client_users
    SET branch_id = p_branch_id
    WHERE user_id = p_user_id 
      AND client_id = v_client 
      AND role_in_client = 'gerente_sucursal'
    RETURNING id INTO v_id;
  ELSE
    -- Insert or update (same branch)
    INSERT INTO public.client_users (id, user_id, client_id, branch_id, role_in_client, created_at)
    VALUES (gen_random_uuid(), p_user_id, v_client, p_branch_id, 'gerente_sucursal', now())
    ON CONFLICT (user_id, client_id) WHERE role_in_client = 'gerente_sucursal'
    DO UPDATE SET branch_id = EXCLUDED.branch_id
    RETURNING id INTO v_id;
  END IF;

  SELECT json_build_object(
    'id', cu.id,
    'user_id', cu.user_id,
    'client_id', cu.client_id,
    'branch_id', cu.branch_id,
    'role_in_client', cu.role_in_client,
    'created_at', cu.created_at
  ) INTO v_result
  FROM public.client_users cu
  WHERE cu.id = v_id;

  RETURN v_result;
END;
$$;


ALTER FUNCTION public.master_assign_client_user(p_user_id uuid, p_branch_id uuid) OWNER TO postgres;

--
-- Name: master_get_user_by_email(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.master_get_user_by_email(p_email text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'auth'
    AS $$
DECLARE
  v_client uuid;
  v_result json;
BEGIN
  SELECT cu.client_id
    INTO v_client
  FROM public.client_users cu
  WHERE cu.user_id = auth.uid() AND cu.role_in_client = 'master'
  LIMIT 1;

  IF v_client IS NULL THEN
    RAISE EXCEPTION 'not_authorized';
  END IF;

  SELECT json_build_object(
    'user_id', u.id,
    'email', u.email,
    'display_name', up.display_name
  ) INTO v_result
  FROM auth.users u
  LEFT JOIN public.user_profiles up ON up.user_id = u.id
  WHERE lower(u.email) = lower(p_email)
  LIMIT 1;

  RETURN v_result;
END;
$$;


ALTER FUNCTION public.master_get_user_by_email(p_email text) OWNER TO postgres;

--
-- Name: master_list_client_users(uuid, uuid, integer, integer, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.master_list_client_users(branch_filter uuid DEFAULT NULL::uuid, client_filter uuid DEFAULT NULL::uuid, page_num integer DEFAULT 1, page_size integer DEFAULT 25, role_filter text DEFAULT NULL::text, search text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'auth'
    AS $$
DECLARE
  v_client uuid;
  v_users json;
  v_total_count int;
BEGIN
  -- Must be MASTER of some company
  SELECT cu.client_id
    INTO v_client
  FROM public.client_users cu
  WHERE cu.user_id = auth.uid() AND cu.role_in_client = 'master'
  LIMIT 1;

  IF v_client IS NULL THEN
    RAISE EXCEPTION 'not_authorized';
  END IF;

  -- Validate pagination params
  IF page_num   IS NULL OR page_num   < 1 THEN page_num   := 1;  END IF;
  IF page_size  IS NULL OR page_size  < 1 THEN page_size  := 25; END IF;
  IF page_size > 200 THEN page_size := 200; END IF;

  -- First get the total count (without pagination)
  SELECT COUNT(*)
    INTO v_total_count
  FROM public.client_users cu
  JOIN public.clients c            ON c.id = cu.client_id
  LEFT JOIN public.client_branches b ON b.id = cu.branch_id
  LEFT JOIN public.user_profiles up  ON up.user_id = cu.user_id
  JOIN auth.users au               ON au.id = cu.user_id
  WHERE cu.client_id = v_client
    AND (branch_filter IS NULL OR cu.branch_id = branch_filter)
    AND (role_filter   IS NULL OR cu.role_in_client = role_filter)
    AND (
      search IS NULL
      OR au.email ILIKE '%'||search||'%'
      OR (up.display_name IS NOT NULL AND up.display_name ILIKE '%'||search||'%')
    );

  -- Then get the paginated results as JSON
  SELECT json_agg(
    json_build_object(
      'id', cu.id,
      'user_id', cu.user_id,
      'email', au.email,
      'display_name', up.display_name,
      'role_in_client', cu.role_in_client,
      'branch_id', cu.branch_id,
      'branch_name', b.name,
      'created_at', cu.created_at
    )
  )
    INTO v_users
  FROM public.client_users cu
  JOIN public.clients c            ON c.id = cu.client_id
  LEFT JOIN public.client_branches b ON b.id = cu.branch_id
  LEFT JOIN public.user_profiles up  ON up.user_id = cu.user_id
  JOIN auth.users au               ON au.id = cu.user_id
  WHERE cu.client_id = v_client
    AND (branch_filter IS NULL OR cu.branch_id = branch_filter)
    AND (role_filter   IS NULL OR cu.role_in_client = role_filter)
    AND (
      search IS NULL
      OR au.email ILIKE '%'||search||'%'
      OR (up.display_name IS NOT NULL AND up.display_name ILIKE '%'||search||'%')
    )
  ORDER BY cu.created_at DESC
  OFFSET (page_num - 1) * page_size
  LIMIT page_size;

  -- Return combined result
  RETURN json_build_object(
    'users', COALESCE(v_users, '[]'::json),
    'total_count', v_total_count
  );
END;
$$;


ALTER FUNCTION public.master_list_client_users(branch_filter uuid, client_filter uuid, page_num integer, page_size integer, role_filter text, search text) OWNER TO postgres;

--
-- Name: order_items_after_recalc_totals(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.order_items_after_recalc_totals() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    PERFORM public.calculate_order_totals(OLD.order_id);
    RETURN OLD;
  ELSE
    PERFORM public.calculate_order_totals(NEW.order_id);
    RETURN NEW;
  END IF;
END;
$$;


ALTER FUNCTION public.order_items_after_recalc_totals() OWNER TO postgres;

--
-- Name: order_items_before_set_line_total(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.order_items_before_set_line_total() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.line_total := ROUND(NEW.qty * NEW.unit_price, 2);
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.order_items_before_set_line_total() OWNER TO postgres;

--
-- Name: track_order_status_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.track_order_status_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF OLD.status IS DISTINCT FROM NEW.status THEN
    INSERT INTO public.order_status_history (order_id, from_status, to_status, by_user_id)
    VALUES (NEW.id, OLD.status, NEW.status, auth.uid());
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.track_order_status_change() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(objects.path_tokens, 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_id text NOT NULL,
    client_secret_hash text NOT NULL,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: audit_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_log (
    id bigint NOT NULL,
    at timestamp with time zone DEFAULT now(),
    actor_user_id uuid,
    action text,
    entity text,
    entity_id text,
    meta jsonb
);


ALTER TABLE public.audit_log OWNER TO postgres;

--
-- Name: audit_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_log_id_seq OWNER TO postgres;

--
-- Name: audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_log_id_seq OWNED BY public.audit_log.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: client_branches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_branches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    client_id uuid NOT NULL,
    name text NOT NULL,
    code text,
    address text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.client_branches OWNER TO postgres;

--
-- Name: client_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    client_id uuid NOT NULL,
    branch_id uuid,
    user_id uuid NOT NULL,
    role_in_client text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT client_users_role_in_client_check CHECK ((role_in_client = ANY (ARRAY['master'::text, 'gerente_sucursal'::text])))
);


ALTER TABLE public.client_users OWNER TO postgres;

--
-- Name: clients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    tax_id text,
    billing_email text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.clients OWNER TO postgres;

--
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    product_id uuid NOT NULL,
    qty numeric(12,3) NOT NULL,
    unit_price numeric(12,2) NOT NULL,
    line_total numeric(12,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- Name: order_status_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_status_history (
    id bigint NOT NULL,
    order_id uuid NOT NULL,
    from_status text,
    to_status text,
    by_user_id uuid,
    note text,
    at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.order_status_history OWNER TO postgres;

--
-- Name: order_status_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_status_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_status_history_id_seq OWNER TO postgres;

--
-- Name: order_status_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_status_history_id_seq OWNED BY public.order_status_history.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    client_id uuid NOT NULL,
    branch_id uuid NOT NULL,
    created_by uuid NOT NULL,
    status text DEFAULT 'borrador'::text,
    subtotal numeric(12,2) DEFAULT 0,
    total numeric(12,2) DEFAULT 0,
    currency text DEFAULT 'USD'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT orders_status_check CHECK ((status = ANY (ARRAY['borrador'::text, 'pendiente_aprobacion'::text, 'aprobado'::text, 'pagado'::text, 'en_preparacion'::text, 'despachado'::text, 'completado'::text, 'anulado'::text])))
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    method text,
    provider_ref text,
    status text DEFAULT 'init'::text,
    amount numeric(12,2),
    raw jsonb,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT payments_method_check CHECK ((method = ANY (ARRAY['yappy'::text, 'bg_cybersource'::text]))),
    CONSTRAINT payments_status_check CHECK ((status = ANY (ARRAY['init'::text, 'pending'::text, 'approved'::text, 'declined'::text, 'error'::text, 'refunded'::text])))
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: price_overrides; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_overrides (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    client_id uuid NOT NULL,
    product_id uuid NOT NULL,
    discount_pct numeric(5,2),
    custom_price numeric(12,2),
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT price_overrides_valid CHECK (((discount_pct IS NOT NULL) OR (custom_price IS NOT NULL)))
);


ALTER TABLE public.price_overrides OWNER TO postgres;

--
-- Name: product_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_images (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    url text NOT NULL,
    alt text,
    sort integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.product_images OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    category_id uuid NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    description text,
    unit text,
    list_price numeric(12,2) NOT NULL,
    active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_profiles (
    user_id uuid NOT NULL,
    display_name text,
    role_app text,
    phone text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_profiles_role_app_check CHECK ((role_app = ANY (ARRAY['admin'::text, 'cliente_master'::text, 'cliente_gerente_sucursal'::text])))
);


ALTER TABLE public.user_profiles OWNER TO postgres;

--
-- Name: v_effective_prices; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_effective_prices AS
 SELECT p.id AS product_id,
    c.id AS client_id,
        CASE
            WHEN (po.custom_price IS NOT NULL) THEN po.custom_price
            WHEN (po.discount_pct IS NOT NULL) THEN round((p.list_price * ((1)::numeric - (po.discount_pct / (100)::numeric))), 2)
            ELSE p.list_price
        END AS effective_price
   FROM ((public.products p
     CROSS JOIN public.clients c)
     LEFT JOIN public.price_overrides po ON (((po.product_id = p.id) AND (po.client_id = c.id))))
  WHERE (p.active = true);


ALTER VIEW public.v_effective_prices OWNER TO postgres;

--
-- Name: webhook_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.webhook_events (
    id bigint NOT NULL,
    source text,
    event_type text,
    payload jsonb,
    received_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.webhook_events OWNER TO postgres;

--
-- Name: webhook_events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.webhook_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.webhook_events_id_seq OWNER TO postgres;

--
-- Name: webhook_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.webhook_events_id_seq OWNED BY public.webhook_events.id;


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: postgres
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text
);


ALTER TABLE supabase_migrations.schema_migrations OWNER TO postgres;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: audit_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log ALTER COLUMN id SET DEFAULT nextval('public.audit_log_id_seq'::regclass);


--
-- Name: order_status_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_history ALTER COLUMN id SET DEFAULT nextval('public.order_status_history_id_seq'::regclass);


--
-- Name: webhook_events id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.webhook_events ALTER COLUMN id SET DEFAULT nextval('public.webhook_events_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	a5b7fba0-3762-4a02-8c30-c23522c9c717	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"admin.demo@suproser.app","user_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","user_phone":""}}	2025-09-02 19:17:54.847064+00	
00000000-0000-0000-0000-000000000000	b3f4376e-cb53-46a7-a3bd-9eb159043ca5	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"master.demo@clientedemo.app","user_id":"70843b92-a777-4eee-8ed2-4c2358680d40","user_phone":""}}	2025-09-02 19:17:55.059991+00	
00000000-0000-0000-0000-000000000000	4bd86516-b660-4204-a288-033f19558494	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"gerente.rioabajo.demo@clientedemo.app","user_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","user_phone":""}}	2025-09-02 19:17:55.319874+00	
00000000-0000-0000-0000-000000000000	f191eaf7-5edb-4fd5-97fa-7774723a67e0	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 19:18:05.023739+00	
00000000-0000-0000-0000-000000000000	cf271fdd-3f52-4d1b-9966-c5cc9a7c2af6	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 19:19:23.64247+00	
00000000-0000-0000-0000-000000000000	db0d0d00-3f59-4dfb-8d2b-b6c150c272a6	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 19:19:33.696387+00	
00000000-0000-0000-0000-000000000000	ab32ae6a-251b-4ba8-ae7c-8a130b0aa6eb	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 19:20:14.193061+00	
00000000-0000-0000-0000-000000000000	b14fd913-d134-46f3-97e5-79c72150ed77	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 19:36:04.63398+00	
00000000-0000-0000-0000-000000000000	1c032e7a-a1e0-4afc-ba16-d180d985f802	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 19:40:18.363506+00	
00000000-0000-0000-0000-000000000000	5a6c2fc1-3a86-4e7b-a551-44d335d269b8	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 19:40:42.128982+00	
00000000-0000-0000-0000-000000000000	c7fc682a-fae3-4fbc-bcc2-cfebda014add	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 19:42:00.270919+00	
00000000-0000-0000-0000-000000000000	a5607301-7dcc-4de5-8220-86b2af722e69	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 19:47:45.538823+00	
00000000-0000-0000-0000-000000000000	aaba7840-c667-4c15-bfbc-1fef0f042a20	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 19:50:20.122811+00	
00000000-0000-0000-0000-000000000000	2e7589ef-a922-4b8c-aa0c-136f939fa35b	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 19:52:09.421998+00	
00000000-0000-0000-0000-000000000000	51c0d81c-2999-4aa1-882c-551f52d1e3ca	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 19:52:23.720211+00	
00000000-0000-0000-0000-000000000000	82c5ca01-4bb3-41be-a081-634a40505b3b	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 19:53:12.476939+00	
00000000-0000-0000-0000-000000000000	cc36b239-e6d3-496b-baf1-ef6a8c784e9f	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 19:54:48.615526+00	
00000000-0000-0000-0000-000000000000	2ef26085-7c9c-4ba3-909d-4c3ebc13bc98	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:13:04.096781+00	
00000000-0000-0000-0000-000000000000	71c96efe-661d-47a7-b073-66441d4f6193	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:13:08.738548+00	
00000000-0000-0000-0000-000000000000	a19f031c-78c0-40c2-831a-8b10b54ff983	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:13:13.900078+00	
00000000-0000-0000-0000-000000000000	82bab930-8da9-4385-b144-cd2e8df4e9b4	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:13:18.906225+00	
00000000-0000-0000-0000-000000000000	83607733-3147-4f32-b6f2-cf802dc51d5d	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:13:23.758962+00	
00000000-0000-0000-0000-000000000000	6ed3bf2e-9e36-4976-b9f5-7840c49f6ba1	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:13:29.599269+00	
00000000-0000-0000-0000-000000000000	76c52ff4-6f38-416c-bcd8-2618d2389314	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:13:35.620234+00	
00000000-0000-0000-0000-000000000000	db7f2d6e-57d0-4a8a-b28c-22acb2c28272	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:13:40.61003+00	
00000000-0000-0000-0000-000000000000	b6116df2-b018-41bd-be39-08f9749bc98f	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:13:46.610111+00	
00000000-0000-0000-0000-000000000000	8b9285b9-4b49-499c-a60d-ee306e07eece	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:13:51.60909+00	
00000000-0000-0000-0000-000000000000	34c7dcf7-c4d6-466a-86cf-533f631b4c19	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:13:57.759131+00	
00000000-0000-0000-0000-000000000000	6713bf19-9340-467c-98fc-8dc00aa6b9d2	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:14:02.6134+00	
00000000-0000-0000-0000-000000000000	376bbccf-9848-4460-ae09-e76e8f092ae7	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:14:08.653687+00	
00000000-0000-0000-0000-000000000000	0c0f5b11-9311-4751-a9fa-454f9a536826	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:14:13.602261+00	
00000000-0000-0000-0000-000000000000	9b67986a-50fa-4446-9c6c-c3e69746ddb3	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:14:19.613235+00	
00000000-0000-0000-0000-000000000000	47c72696-46f7-48a3-a3d9-19221368afff	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:14:37.623659+00	
00000000-0000-0000-0000-000000000000	169ea078-5e9c-4e82-a54a-c3d98345624b	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 20:15:37.788598+00	
00000000-0000-0000-0000-000000000000	c88235ad-46c6-428c-bca3-d25c2941af54	{"action":"token_refreshed","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"token"}	2025-09-02 20:26:51.881518+00	
00000000-0000-0000-0000-000000000000	b7f5261d-6750-474b-b17a-8c047b352402	{"action":"token_revoked","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"token"}	2025-09-02 20:26:51.882522+00	
00000000-0000-0000-0000-000000000000	fa5e61db-93c4-408d-bf81-1d7d1ca7b851	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-02 21:19:37.733936+00	
00000000-0000-0000-0000-000000000000	105ebc9e-d12a-4ab8-9bcf-56e1c6d2ae5e	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 21:19:51.438152+00	
00000000-0000-0000-0000-000000000000	7361b0c2-dddf-4947-a0b7-4ab1ecaed8c9	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 21:19:56.131137+00	
00000000-0000-0000-0000-000000000000	8e8f0088-af5f-4be4-bc76-928a48ee2103	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-02 21:42:56.845661+00	
00000000-0000-0000-0000-000000000000	b03f8545-dad2-4f4c-b234-28b9087987f4	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 21:43:00.768732+00	
00000000-0000-0000-0000-000000000000	8f5ecb1d-8bf0-4549-97e3-b28603a6c75d	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-02 21:45:33.555433+00	
00000000-0000-0000-0000-000000000000	35299bf4-0945-4826-956a-7a8029f3aab5	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 21:46:03.928854+00	
00000000-0000-0000-0000-000000000000	1086da0a-0cfc-418b-affa-226b8b7a6143	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-02 21:59:56.715948+00	
00000000-0000-0000-0000-000000000000	3e9af5ff-ce0d-48ef-a9fa-80605f5c8a14	{"action":"token_refreshed","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"token"}	2025-09-03 00:44:58.603755+00	
00000000-0000-0000-0000-000000000000	31689179-f814-4a9f-807e-f54bb0bd1b2f	{"action":"token_revoked","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"token"}	2025-09-03 00:44:58.604706+00	
00000000-0000-0000-0000-000000000000	2a3e913a-a84f-48e4-8c0f-1490fc6437c8	{"action":"token_refreshed","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"token"}	2025-09-03 00:54:26.210705+00	
00000000-0000-0000-0000-000000000000	e9bff931-73a7-4eb3-a522-1b1c0e500d1b	{"action":"token_revoked","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"token"}	2025-09-03 00:54:26.211877+00	
00000000-0000-0000-0000-000000000000	6af6458b-ae71-4fa9-8b10-47a2faa45c5b	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 00:55:57.554494+00	
00000000-0000-0000-0000-000000000000	98866792-de96-4e72-b107-f53b13fa5258	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 00:56:10.505161+00	
00000000-0000-0000-0000-000000000000	5bd104cb-ffab-4c8c-8549-d025bf4dd420	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 00:56:24.228316+00	
00000000-0000-0000-0000-000000000000	90a88762-b8fc-4adc-8271-56bb5f727127	{"action":"user_signedup","actor_id":"0c6f9890-d5a0-4b3a-ac9e-b0e59d0533ec","actor_username":"info@obzide.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-03 00:56:47.446474+00	
00000000-0000-0000-0000-000000000000	664f6577-95c1-49ba-a69d-c80ef7175b9e	{"action":"login","actor_id":"0c6f9890-d5a0-4b3a-ac9e-b0e59d0533ec","actor_username":"info@obzide.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 00:56:47.450567+00	
00000000-0000-0000-0000-000000000000	fa8f3d99-a9da-4f12-8490-3c0b5b9a34ec	{"action":"logout","actor_id":"0c6f9890-d5a0-4b3a-ac9e-b0e59d0533ec","actor_username":"info@obzide.com","actor_via_sso":false,"log_type":"account"}	2025-09-03 01:20:40.200618+00	
00000000-0000-0000-0000-000000000000	f0eb2449-73df-4931-82d0-d8f72796d068	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 01:20:46.492607+00	
00000000-0000-0000-0000-000000000000	88ce6f91-f6f7-4814-922b-b6c09a00659a	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 01:37:54.708369+00	
00000000-0000-0000-0000-000000000000	16254947-deca-4451-9647-3574d4ff3396	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 01:38:06.20037+00	
00000000-0000-0000-0000-000000000000	964e71a6-e819-4544-acc4-abebab176a87	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 01:40:33.491066+00	
00000000-0000-0000-0000-000000000000	796c84dd-544d-4548-abe5-a1080c2b181f	{"action":"login","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 01:40:41.528435+00	
00000000-0000-0000-0000-000000000000	63d2097e-f0da-4240-bed1-4affd0c4600c	{"action":"logout","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 01:57:30.218364+00	
00000000-0000-0000-0000-000000000000	886fb133-dc16-454b-a1f6-c98b440405a3	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 01:57:36.410966+00	
00000000-0000-0000-0000-000000000000	074bb55c-4824-4b89-adbd-fcdc8fd94300	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 02:02:45.843139+00	
00000000-0000-0000-0000-000000000000	85fe74a2-c8e7-4eac-b353-66ace5419f74	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 02:02:52.180288+00	
00000000-0000-0000-0000-000000000000	89dab048-113a-44bc-afe6-9ca10fe2203f	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 02:14:44.308526+00	
00000000-0000-0000-0000-000000000000	c3a7a977-b6f4-45c6-bf45-425be4e02c9e	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 02:14:50.195682+00	
00000000-0000-0000-0000-000000000000	060df722-f101-43a5-a4a6-d988326c5a5c	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 02:44:12.376265+00	
00000000-0000-0000-0000-000000000000	b0402a94-405d-4189-af9c-c62bd58fd721	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 02:44:17.068384+00	
00000000-0000-0000-0000-000000000000	378e28ee-e6fa-4569-98b2-24f3e63621aa	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 02:55:17.649963+00	
00000000-0000-0000-0000-000000000000	47b9dc2e-c1ba-4467-b77c-97cb91a726f2	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 02:55:22.94627+00	
00000000-0000-0000-0000-000000000000	52460a35-31b7-4622-8985-752576caa779	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 02:59:16.01977+00	
00000000-0000-0000-0000-000000000000	6612b5e8-ee47-40de-ac78-4de94d99e368	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 02:59:34.41474+00	
00000000-0000-0000-0000-000000000000	44283043-7c4e-4f55-beef-d60add4ba693	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 03:00:40.706873+00	
00000000-0000-0000-0000-000000000000	716e65bb-0878-4521-84ac-ef4d443e4789	{"action":"user_signedup","actor_id":"ac7f2761-3158-4e3b-93e9-d5ed735c41f6","actor_username":"info@colo.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-03 03:01:14.156706+00	
00000000-0000-0000-0000-000000000000	9561faa4-257e-4329-bb7b-9cffe299ff63	{"action":"login","actor_id":"ac7f2761-3158-4e3b-93e9-d5ed735c41f6","actor_username":"info@colo.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 03:01:14.164+00	
00000000-0000-0000-0000-000000000000	04d8d6d8-864d-48e4-8780-78d69fb30adb	{"action":"user_signedup","actor_id":"dba7d5f5-35b7-41f2-b153-7335e335d4cb","actor_username":"lol@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-03 03:03:29.251338+00	
00000000-0000-0000-0000-000000000000	3aad1901-1f5f-4360-b556-71af5589cfae	{"action":"login","actor_id":"dba7d5f5-35b7-41f2-b153-7335e335d4cb","actor_username":"lol@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 03:03:29.255818+00	
00000000-0000-0000-0000-000000000000	32f9cb10-8d6e-40fc-b898-7596f857dc2d	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 03:03:51.684249+00	
00000000-0000-0000-0000-000000000000	42a7434f-73cb-4706-811c-c7eea78ce204	{"action":"logout","actor_id":"dba7d5f5-35b7-41f2-b153-7335e335d4cb","actor_username":"lol@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-09-03 03:07:12.502895+00	
00000000-0000-0000-0000-000000000000	c8620269-067b-4f8c-a199-e8939604986a	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 03:14:42.172509+00	
00000000-0000-0000-0000-000000000000	b90379bd-69ca-4374-983d-9c708f5bfc8e	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 03:14:48.879597+00	
00000000-0000-0000-0000-000000000000	06b65b3e-3f63-458f-b819-04dbd3125ec4	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 04:01:26.930037+00	
00000000-0000-0000-0000-000000000000	9f4161f9-c465-4be3-bb0b-876b7890a534	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 04:01:33.560839+00	
00000000-0000-0000-0000-000000000000	2da74578-8d2d-4b79-8214-63daf19eb4ca	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 04:02:23.893222+00	
00000000-0000-0000-0000-000000000000	9c02c973-2a54-4005-b0e0-c1316dc7e38b	{"action":"login","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 04:02:27.796183+00	
00000000-0000-0000-0000-000000000000	cc3b4306-f0fa-4999-923c-2dd079e27eb7	{"action":"logout","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 04:03:26.609783+00	
00000000-0000-0000-0000-000000000000	27d0db5a-a5a9-42c4-a24a-d9e0efe601ad	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 04:03:31.070657+00	
00000000-0000-0000-0000-000000000000	107799b7-66e9-419f-8daf-0964dbad3d51	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 04:29:47.67025+00	
00000000-0000-0000-0000-000000000000	60c239ad-1626-4bfd-b87d-b017e6c493a5	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 04:29:51.946017+00	
00000000-0000-0000-0000-000000000000	c0fa962d-a1e2-458b-ba29-e6455ff9712d	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 04:32:45.154018+00	
00000000-0000-0000-0000-000000000000	93b90567-5094-468a-a5ee-82b17c9c832f	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 04:32:51.083572+00	
00000000-0000-0000-0000-000000000000	d010e7a3-01ad-4338-b192-1a9814d35470	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 04:46:17.786034+00	
00000000-0000-0000-0000-000000000000	4be3348b-1ded-43f3-9503-b10ed5c2c400	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 04:46:23.663807+00	
00000000-0000-0000-0000-000000000000	465d6451-e7f7-4d8e-b399-a7489d58d523	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 04:46:51.139424+00	
00000000-0000-0000-0000-000000000000	acc397a0-b0eb-4e22-a090-e6988c1bf4a5	{"action":"login","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 04:47:13.380312+00	
00000000-0000-0000-0000-000000000000	c5dcbbe5-fe66-4a75-9d01-f6cb7c6e8f3f	{"action":"logout","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 04:47:24.128654+00	
00000000-0000-0000-0000-000000000000	7f286ecd-3892-42f9-b311-bf95d8793410	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 04:48:31.256969+00	
00000000-0000-0000-0000-000000000000	230e6870-ee9d-456e-845d-dbfede57a203	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 05:06:43.569144+00	
00000000-0000-0000-0000-000000000000	094267f4-e4bf-4610-a2c8-a99c2d357b2a	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 05:06:48.12973+00	
00000000-0000-0000-0000-000000000000	a01fbd2c-523c-4158-a039-ce01cd485fa8	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 05:42:40.368321+00	
00000000-0000-0000-0000-000000000000	73c69605-652b-4ef7-9312-57290c03e7a2	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 05:42:45.998263+00	
00000000-0000-0000-0000-000000000000	7fe6ea96-177d-4321-8830-f89170f81b51	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 05:46:40.509935+00	
00000000-0000-0000-0000-000000000000	5cfdcf56-1e5e-48e3-8e49-b38be4a2cd37	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 05:49:13.761708+00	
00000000-0000-0000-0000-000000000000	d15f854c-0ac7-4fd9-b7cf-186d3cd07b67	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 05:57:33.032192+00	
00000000-0000-0000-0000-000000000000	9fb8a44d-e9a7-4710-90ca-e52cf001cf35	{"action":"user_repeated_signup","actor_id":"dba7d5f5-35b7-41f2-b153-7335e335d4cb","actor_username":"lol@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-09-03 05:57:46.262749+00	
00000000-0000-0000-0000-000000000000	6e4668ec-e31e-4e66-bc65-922cf717bd92	{"action":"user_signedup","actor_id":"4274e005-de93-409c-a96e-16f53adbabd4","actor_username":"loquitoa@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-09-03 05:57:57.724677+00	
00000000-0000-0000-0000-000000000000	066c2a27-99cb-4635-abad-a2868a327f8e	{"action":"login","actor_id":"4274e005-de93-409c-a96e-16f53adbabd4","actor_username":"loquitoa@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 05:57:57.728903+00	
00000000-0000-0000-0000-000000000000	681b9f1b-40de-49cb-9134-e89c09529258	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 05:58:14.192917+00	
00000000-0000-0000-0000-000000000000	133d836d-aede-4ad5-9468-c5ef1d722358	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 06:13:22.404937+00	
00000000-0000-0000-0000-000000000000	8e2dcac4-c830-4ce2-b482-dab2aeca8a52	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 06:13:26.738431+00	
00000000-0000-0000-0000-000000000000	99f7eec5-e940-42bf-80c1-441a136fd994	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 06:14:02.606255+00	
00000000-0000-0000-0000-000000000000	f2725e7b-bfa1-496a-8f63-0f07b6d07f01	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 06:25:27.71491+00	
00000000-0000-0000-0000-000000000000	da7b87e0-d828-4f5b-a995-0b76e321ec65	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 06:33:27.26329+00	
00000000-0000-0000-0000-000000000000	95e86dda-b7d3-4ab4-b027-a65738f36aa5	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 06:33:31.618483+00	
00000000-0000-0000-0000-000000000000	e1bed44b-07cd-46bb-aca8-d015b7e44b50	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 06:35:36.798076+00	
00000000-0000-0000-0000-000000000000	fe4aeda1-890d-46fc-afe8-6c42d931206d	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 06:35:43.35506+00	
00000000-0000-0000-0000-000000000000	3c311d9f-6530-4f0d-85c1-74edd37c7277	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 06:36:50.204556+00	
00000000-0000-0000-0000-000000000000	256608f6-684b-4ef1-9247-662abf29ff67	{"action":"login","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 06:36:55.832454+00	
00000000-0000-0000-0000-000000000000	b17b44c2-a140-4d5a-9e89-01c7ca89683e	{"action":"logout","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 06:40:00.802498+00	
00000000-0000-0000-0000-000000000000	ba7a927e-59d2-4ead-a655-399fb4bfad6b	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 06:40:05.376254+00	
00000000-0000-0000-0000-000000000000	5a34f1bc-5add-4377-849b-f9d2352c0d7f	{"action":"token_refreshed","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"token"}	2025-09-03 16:25:43.812659+00	
00000000-0000-0000-0000-000000000000	b9f7950a-9f92-43d9-8aae-cf9a78a6d2c4	{"action":"token_revoked","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"token"}	2025-09-03 16:25:43.814414+00	
00000000-0000-0000-0000-000000000000	fd63b27b-a053-4a3a-8d5c-ab880988af9f	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 16:53:06.163581+00	
00000000-0000-0000-0000-000000000000	c8f9d367-f614-47fb-9465-e1f64c876b51	{"action":"login","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 16:53:12.595853+00	
00000000-0000-0000-0000-000000000000	06211388-4049-450b-970e-03eb9025edef	{"action":"logout","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 17:09:09.391496+00	
00000000-0000-0000-0000-000000000000	923c64d7-f353-4dd3-8c6b-d8bc4a825252	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 17:09:33.994184+00	
00000000-0000-0000-0000-000000000000	9129b810-2429-4df8-86c9-fb9ad46bded2	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 17:29:23.288073+00	
00000000-0000-0000-0000-000000000000	4332310e-d257-49d6-9d08-903afce71bd6	{"action":"login","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 17:29:27.269218+00	
00000000-0000-0000-0000-000000000000	ec5681c5-d72c-42cb-b3ba-3777eefeaf7c	{"action":"logout","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 17:30:37.341359+00	
00000000-0000-0000-0000-000000000000	9bd21bd5-deec-486f-9eea-eb6908f95d42	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 17:48:58.047542+00	
00000000-0000-0000-0000-000000000000	aa780224-faf7-458a-98f2-2cc91918f76b	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 17:57:03.04765+00	
00000000-0000-0000-0000-000000000000	73303558-a514-441a-b7b1-ce85b2d08023	{"action":"login","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 17:57:08.667295+00	
00000000-0000-0000-0000-000000000000	a5ee9fbc-56c1-40fa-8c02-201b00cacfdb	{"action":"logout","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 18:10:47.458346+00	
00000000-0000-0000-0000-000000000000	a6686af9-6049-4a11-8197-81b3afcde433	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 18:14:27.729462+00	
00000000-0000-0000-0000-000000000000	296239a1-3a63-4e55-a0a9-48a0180b6c1b	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 18:43:03.160065+00	
00000000-0000-0000-0000-000000000000	dca4c207-b94d-4885-92e4-0d7ab787ee71	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 18:46:46.834438+00	
00000000-0000-0000-0000-000000000000	0fccf416-0ed0-49d2-8fa0-180774ec6a8f	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 18:46:53.196221+00	
00000000-0000-0000-0000-000000000000	c228a150-4b34-464d-94d9-22beffaaab25	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 18:47:00.195612+00	
00000000-0000-0000-0000-000000000000	f0c464f7-4c3a-4783-9ac0-82b27e1deebf	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 18:48:08.5339+00	
00000000-0000-0000-0000-000000000000	1b6c7e71-bffe-4ed6-a33e-2d9735a97f78	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 18:48:16.47393+00	
00000000-0000-0000-0000-000000000000	a53400e8-107c-4ac7-bb0b-35b98393620c	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 18:48:43.440501+00	
00000000-0000-0000-0000-000000000000	8cbf0c69-6490-4fca-9cb7-f57acf0861f8	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 18:48:54.96955+00	
00000000-0000-0000-0000-000000000000	985d292d-b705-4c66-a69a-032505833190	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 18:50:51.070816+00	
00000000-0000-0000-0000-000000000000	c497a231-f8cd-4414-8d5b-210c84ac216b	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 18:53:12.650033+00	
00000000-0000-0000-0000-000000000000	802094ed-66e2-43d1-b218-50f039903ff6	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 18:53:18.087626+00	
00000000-0000-0000-0000-000000000000	1a32dbeb-e29a-493a-b3f4-61f1882b0f57	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 19:15:09.538901+00	
00000000-0000-0000-0000-000000000000	f5c5d79d-cd99-4655-bf89-6346520cbbf8	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 19:15:31.096089+00	
00000000-0000-0000-0000-000000000000	5bc964af-2f03-4da5-be6c-3ddbc2b6d5c9	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 20:01:03.683929+00	
00000000-0000-0000-0000-000000000000	7e664fb2-7b67-451d-a8a4-f072f38ca1b0	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 20:13:20.419457+00	
00000000-0000-0000-0000-000000000000	c2a1a8ce-401e-4e54-aa83-8fe043096d49	{"action":"login","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 20:13:25.350874+00	
00000000-0000-0000-0000-000000000000	4401f571-22b6-4ab6-864e-d9e00d93fdcb	{"action":"logout","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 20:17:16.630365+00	
00000000-0000-0000-0000-000000000000	0085aa03-1ff7-4a0a-a276-689817c89bfd	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 20:17:21.401528+00	
00000000-0000-0000-0000-000000000000	1bc33533-ebcc-428d-a5bd-f18588dea6c2	{"action":"login","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 21:21:49.699125+00	
00000000-0000-0000-0000-000000000000	be434db0-3212-478d-bba4-84d8ac2eaa84	{"action":"logout","actor_id":"b55e882e-c6e8-4a54-8af4-62d991128d98","actor_username":"gerente.rioabajo.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 21:24:43.308407+00	
00000000-0000-0000-0000-000000000000	a66ee62a-23f9-4334-8892-4cf38b6262c4	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 21:25:15.527967+00	
00000000-0000-0000-0000-000000000000	0d06dfa5-a4bf-41b9-a494-8f970588deec	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 21:29:04.200717+00	
00000000-0000-0000-0000-000000000000	e6a1cc62-7a73-4cb3-9a45-f01ed4307fc7	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-03 21:29:25.595564+00	
00000000-0000-0000-0000-000000000000	7d790220-bd9b-45ca-b0f1-b25c386760dc	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-03 21:36:29.899826+00	
00000000-0000-0000-0000-000000000000	e25c40a6-8757-4bc0-9a19-43c0875b35f1	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-08 19:50:02.767402+00	
00000000-0000-0000-0000-000000000000	b768f29b-0965-4291-a803-e552007c2dec	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-08 19:53:54.557647+00	
00000000-0000-0000-0000-000000000000	0f18a5ba-a6e5-4faf-b917-27a549ba7510	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-08 20:14:15.034777+00	
00000000-0000-0000-0000-000000000000	dc6b30e5-244b-499c-9947-5dee060d64bf	{"action":"login","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-08 20:35:16.040745+00	
00000000-0000-0000-0000-000000000000	72cd79d3-44a8-4223-bdd1-680240298889	{"action":"logout","actor_id":"d4251f9f-aa29-49c8-b845-9d78dc4f46b8","actor_username":"admin.demo@suproser.app","actor_via_sso":false,"log_type":"account"}	2025-09-08 20:35:22.279184+00	
00000000-0000-0000-0000-000000000000	2aa33784-6901-4617-a5f5-491111d0b3c9	{"action":"login","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-09-08 20:35:26.991468+00	
00000000-0000-0000-0000-000000000000	736877fa-b196-42f8-8c12-22731a4ca5c0	{"action":"token_refreshed","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"token"}	2025-09-16 03:28:29.786751+00	
00000000-0000-0000-0000-000000000000	ff56918f-6d56-415b-abe4-294f0cb292f7	{"action":"token_revoked","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"token"}	2025-09-16 03:28:29.788808+00	
00000000-0000-0000-0000-000000000000	e2df6c89-f92a-44b6-9c49-b74710d08f16	{"action":"logout","actor_id":"70843b92-a777-4eee-8ed2-4c2358680d40","actor_username":"master.demo@clientedemo.app","actor_via_sso":false,"log_type":"account"}	2025-09-16 03:30:58.905949+00	
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
d4251f9f-aa29-49c8-b845-9d78dc4f46b8	d4251f9f-aa29-49c8-b845-9d78dc4f46b8	{"sub": "d4251f9f-aa29-49c8-b845-9d78dc4f46b8", "email": "admin.demo@suproser.app", "email_verified": false, "phone_verified": false}	email	2025-09-02 19:17:54.845451+00	2025-09-02 19:17:54.845519+00	2025-09-02 19:17:54.845519+00	cf426ac1-c9df-476c-af04-6fe64e17c31c
70843b92-a777-4eee-8ed2-4c2358680d40	70843b92-a777-4eee-8ed2-4c2358680d40	{"sub": "70843b92-a777-4eee-8ed2-4c2358680d40", "email": "master.demo@clientedemo.app", "email_verified": false, "phone_verified": false}	email	2025-09-02 19:17:55.058916+00	2025-09-02 19:17:55.058992+00	2025-09-02 19:17:55.058992+00	8d54ffdf-4f24-4bd4-b026-c98a524806c7
b55e882e-c6e8-4a54-8af4-62d991128d98	b55e882e-c6e8-4a54-8af4-62d991128d98	{"sub": "b55e882e-c6e8-4a54-8af4-62d991128d98", "email": "gerente.rioabajo.demo@clientedemo.app", "email_verified": false, "phone_verified": false}	email	2025-09-02 19:17:55.31893+00	2025-09-02 19:17:55.318979+00	2025-09-02 19:17:55.318979+00	3f97f507-7f94-4602-9b67-c3286e28eb0f
0c6f9890-d5a0-4b3a-ac9e-b0e59d0533ec	0c6f9890-d5a0-4b3a-ac9e-b0e59d0533ec	{"sub": "0c6f9890-d5a0-4b3a-ac9e-b0e59d0533ec", "email": "info@obzide.com", "email_verified": false, "phone_verified": false}	email	2025-09-03 00:56:47.443359+00	2025-09-03 00:56:47.443413+00	2025-09-03 00:56:47.443413+00	94877705-8feb-4979-86f8-4985c8442b8e
ac7f2761-3158-4e3b-93e9-d5ed735c41f6	ac7f2761-3158-4e3b-93e9-d5ed735c41f6	{"sub": "ac7f2761-3158-4e3b-93e9-d5ed735c41f6", "email": "info@colo.com", "email_verified": false, "phone_verified": false}	email	2025-09-03 03:01:14.150481+00	2025-09-03 03:01:14.15053+00	2025-09-03 03:01:14.15053+00	f1977e46-a1bb-4834-98a1-ab45adaf39f3
dba7d5f5-35b7-41f2-b153-7335e335d4cb	dba7d5f5-35b7-41f2-b153-7335e335d4cb	{"sub": "dba7d5f5-35b7-41f2-b153-7335e335d4cb", "email": "lol@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-03 03:03:29.248489+00	2025-09-03 03:03:29.248539+00	2025-09-03 03:03:29.248539+00	aa0e4c73-31af-4a04-9eb0-d90c8595a9db
4274e005-de93-409c-a96e-16f53adbabd4	4274e005-de93-409c-a96e-16f53adbabd4	{"sub": "4274e005-de93-409c-a96e-16f53adbabd4", "email": "loquitoa@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-09-03 05:57:57.721721+00	2025-09-03 05:57:57.721771+00	2025-09-03 05:57:57.721771+00	956d4180-a113-4b29-97e9-c15bfb188032
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
f125783a-a446-42b4-90f7-6147b8061588	2025-09-03 05:57:57.732197+00	2025-09-03 05:57:57.732197+00	password	c4c9203b-2d02-4317-91d4-7d1c6249f28e
51154165-50a7-49aa-bdc2-284a1755e515	2025-09-03 03:01:14.172343+00	2025-09-03 03:01:14.172343+00	password	2fca1391-f519-442e-80f9-576f999a8fe9
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	51	4rqtnihdsibu	ac7f2761-3158-4e3b-93e9-d5ed735c41f6	f	2025-09-03 03:01:14.167665+00	2025-09-03 03:01:14.167665+00	\N	51154165-50a7-49aa-bdc2-284a1755e515
00000000-0000-0000-0000-000000000000	66	y2bme34ohzc2	4274e005-de93-409c-a96e-16f53adbabd4	f	2025-09-03 05:57:57.730631+00	2025-09-03 05:57:57.730631+00	\N	f125783a-a446-42b4-90f7-6147b8061588
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag) FROM stdin;
f125783a-a446-42b4-90f7-6147b8061588	4274e005-de93-409c-a96e-16f53adbabd4	2025-09-03 05:57:57.729703+00	2025-09-03 05:57:57.729703+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	190.218.180.25	\N
51154165-50a7-49aa-bdc2-284a1755e515	ac7f2761-3158-4e3b-93e9-d5ed735c41f6	2025-09-03 03:01:14.166003+00	2025-09-03 03:01:14.166003+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36	190.218.180.25	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	dba7d5f5-35b7-41f2-b153-7335e335d4cb	authenticated	authenticated	lol@gmail.com	$2a$10$aJZg9bK46RlUacSnaJxQpuvQNBLQVd8W46OEn6bs5LB0eHfReKOVS	2025-09-03 03:03:29.252187+00	\N		\N		\N			\N	2025-09-03 03:03:29.256427+00	{"provider": "email", "providers": ["email"]}	{"sub": "dba7d5f5-35b7-41f2-b153-7335e335d4cb", "email": "lol@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-03 03:03:29.240813+00	2025-09-03 03:03:29.259633+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	b55e882e-c6e8-4a54-8af4-62d991128d98	authenticated	authenticated	gerente.rioabajo.demo@clientedemo.app	$2a$10$c.5adpcfBI.0VFpeAFCek.7Gh3wSqpaXTuuBmpXZORbXzg/tkPR96	2025-09-02 19:17:55.321022+00	\N		\N		\N			\N	2025-09-03 21:21:49.700297+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-09-02 19:17:55.317784+00	2025-09-03 21:21:49.70306+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	4274e005-de93-409c-a96e-16f53adbabd4	authenticated	authenticated	loquitoa@gmail.com	$2a$10$87CJlg2lqw1ZT9q8mfMhWekr62oM2HrYSDPICw68ibliuig2AUI1C	2025-09-03 05:57:57.725235+00	\N		\N		\N			\N	2025-09-03 05:57:57.729616+00	{"provider": "email", "providers": ["email"]}	{"sub": "4274e005-de93-409c-a96e-16f53adbabd4", "email": "loquitoa@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-09-03 05:57:57.718437+00	2025-09-03 05:57:57.731721+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	ac7f2761-3158-4e3b-93e9-d5ed735c41f6	authenticated	authenticated	info@colo.com	$2a$10$a5ucJxf160pS/xsdcpVNu.eqCGdbQd0qqxBxhw3k08uDkMN4bszv.	2025-09-03 03:01:14.157276+00	\N		\N		\N			\N	2025-09-03 03:01:14.165908+00	{"provider": "email", "providers": ["email"]}	{"sub": "ac7f2761-3158-4e3b-93e9-d5ed735c41f6", "email": "info@colo.com", "email_verified": true, "phone_verified": false}	\N	2025-09-03 03:01:14.138316+00	2025-09-03 03:01:14.170663+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	0c6f9890-d5a0-4b3a-ac9e-b0e59d0533ec	authenticated	authenticated	info@obzide.com	$2a$10$MiTKOHpecTbTi3n5/IOyG.fBFJcMVwOMsnnG.akCwvbmmx.h7YDSW	2025-09-03 00:56:47.447027+00	\N		\N		\N			\N	2025-09-03 00:56:47.451157+00	{"provider": "email", "providers": ["email"]}	{"sub": "0c6f9890-d5a0-4b3a-ac9e-b0e59d0533ec", "email": "info@obzide.com", "email_verified": true, "phone_verified": false}	\N	2025-09-03 00:56:47.438264+00	2025-09-03 00:56:47.452979+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	d4251f9f-aa29-49c8-b845-9d78dc4f46b8	authenticated	authenticated	admin.demo@suproser.app	$2a$10$Pw0wqX8tEHF6Tiwi7h4WJOYFRzQR9Vdcp.a7EOurEz5bVHbo6zcsO	2025-09-02 19:17:54.85166+00	\N		\N		\N			\N	2025-09-08 20:35:16.041954+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-09-02 19:17:54.835631+00	2025-09-08 20:35:16.045036+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	70843b92-a777-4eee-8ed2-4c2358680d40	authenticated	authenticated	master.demo@clientedemo.app	$2a$10$VL90WcxWBoSUkbIh6mwCA.2ThOBzgnri9f.eXhkYRMCrAgyECz8.W	2025-09-02 19:17:55.061305+00	\N		\N		\N			\N	2025-09-08 20:35:26.992979+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-09-02 19:17:55.05768+00	2025-09-16 03:28:29.795275+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_log (id, at, actor_user_id, action, entity, entity_id, meta) FROM stdin;
1	2025-09-02 18:20:14.35926+00	\N	test_action	test_entity	test_id	{"ok": true}
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, name, slug, created_at) FROM stdin;
7f1e1a10-4e78-4a9b-9a84-b01d7f0b3a10	Hogar	hogar	2025-09-02 18:20:14.35926+00
d2a9c2f1-3c7e-4b93-8e2d-9f4c1a5b6c71	Hospitales y Clínicas	hospitales-clinicas	2025-09-02 18:20:14.35926+00
b6f3d5a1-9c4e-4c33-96e1-2a7b8c6d5e91	Cocinas y Restaurantes	cocinas-restaurantes	2025-09-02 18:20:14.35926+00
6f7f2006-cb94-4b0c-aa55-30a74a287d04	Baños	banos	2025-09-08 20:14:49.182174+00
a7d376c4-7cf2-4cca-9827-ce056c672056	Botes y Casas de Playa	botes-y-casas-de-playa	2025-09-08 20:15:05.651507+00
e127c7de-81c7-43d3-bdd5-71eb7933833e	Lavanderia	lavanderia	2025-09-08 20:15:23.676172+00
953d7501-58d6-4672-8636-a97716046e8a	Oficinas	oficinas	2025-09-08 20:15:27.019667+00
6b257501-ca2c-4e02-bf5f-c65664c80cf6	Pisos	pisos	2025-09-08 20:15:30.191851+00
0f561a09-093c-4254-9023-da65a33c088c	Talleres	talleres	2025-09-08 20:15:40.879712+00
407fc567-e68f-4937-ae08-72e9ace294ae	Veterinarios	veterinarios	2025-09-08 20:15:46.228222+00
144b6bde-5c63-46a0-a79b-9adb24646bcd	Vidrios	vidrios	2025-09-08 20:16:03.524676+00
\.


--
-- Data for Name: client_branches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_branches (id, client_id, name, code, address, created_at) FROM stdin;
9c8b7a6d-5e4f-4c3b-9a8f-7e6d5c4b3a21	a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56	Río Abajo	RA001	Río Abajo, Ciudad de Panamá	2025-09-02 18:20:14.35926+00
758a0eb2-98a5-4ab5-9b25-a675f949ba1d	a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56	Río Abajo	RIO001	Río Abajo, Ciudad de Panamá	2025-09-02 18:57:26.42908+00
adcaae9e-d048-4ba6-84dc-866452d9cecc	a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56	San Miguelito	MIG001	CLITIN	2025-09-03 17:22:56.417614+00
\.


--
-- Data for Name: client_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_users (id, client_id, branch_id, user_id, role_in_client, created_at) FROM stdin;
776cad35-8a46-47bb-854b-b0fba9973dd2	a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56	9c8b7a6d-5e4f-4c3b-9a8f-7e6d5c4b3a21	b55e882e-c6e8-4a54-8af4-62d991128d98	gerente_sucursal	2025-09-03 01:35:44.205573+00
2e6f7044-c513-4ba3-abe5-405b11065779	a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56	\N	70843b92-a777-4eee-8ed2-4c2358680d40	master	2025-09-03 01:36:02.651154+00
229a67b9-b558-4f15-9a82-139b32ade92d	a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56	\N	dba7d5f5-35b7-41f2-b153-7335e335d4cb	master	2025-09-03 06:25:52.922605+00
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clients (id, name, tax_id, billing_email, created_at) FROM stdin;
a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56	Cliente Demo S.A.	123456789-1-DV	admin@clientedemo.com	2025-09-02 18:20:14.35926+00
581ea2b8-6935-41d8-bf55-8606448bebed	EXAMPLE	234242	pp@gmail.com	2025-09-02 21:46:57.224065+00
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, order_id, product_id, qty, unit_price, line_total, created_at) FROM stdin;
7f3cc8a2-ad0e-436d-8465-28efff97e507	58a268c4-ffe5-46f2-bbe6-7801b8f21540	2b3c4d5e-6f70-4b81-8c90-2d3e4f5a6b70	1.000	28.75	28.75	2025-09-03 01:44:55.619163+00
6368f61f-a071-4282-a929-79db2f07712b	58a268c4-ffe5-46f2-bbe6-7801b8f21540	3c4d5e6f-7081-4c92-9da0-3e4f5a6b7c80	1.000	7.50	7.50	2025-09-03 01:44:55.775718+00
a8cbd911-777b-41ec-8473-fed7a8fb7b40	1a655b88-8df0-4bab-82d0-83f16eb425f9	0f4d6b2e-8c79-4b1e-8a9d-6f3a2b1c5d10	1.000	11.25	11.25	2025-09-03 18:06:10.415179+00
a683c0bb-3144-4ef9-af1e-6d0d9c219992	f92c070e-06ed-4cd6-8580-e9b55704f1a9	0f4d6b2e-8c79-4b1e-8a9d-6f3a2b1c5d10	2.000	11.25	22.50	2025-09-03 17:56:47.440332+00
2894f74e-ca23-4638-be2d-98f3c390e98d	b532d1a6-f317-42d8-ad95-e84a0dcd0f5d	0f4d6b2e-8c79-4b1e-8a9d-6f3a2b1c5d10	7.000	11.25	78.75	2025-09-03 21:23:59.591391+00
c40db44f-ef02-4903-85fd-ff940d95a66b	b532d1a6-f317-42d8-ad95-e84a0dcd0f5d	1a2b3c4d-5e6f-4a70-9b80-1c2d3e4f5a60	1.000	35.20	35.20	2025-09-03 21:23:59.736576+00
4a03ee20-7747-4cd0-b499-82da41d687b6	b532d1a6-f317-42d8-ad95-e84a0dcd0f5d	2b3c4d5e-6f70-4b81-8c90-2d3e4f5a6b70	3.000	28.75	86.25	2025-09-03 21:23:59.893382+00
0088dd03-70d7-4604-a007-963c6ed9b587	1fa21e4b-0c5b-445f-9f82-56f50689ccaa	0f4d6b2e-8c79-4b1e-8a9d-6f3a2b1c5d10	1.000	11.25	11.25	2025-09-08 20:35:37.149822+00
\.


--
-- Data for Name: order_status_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_status_history (id, order_id, from_status, to_status, by_user_id, note, at) FROM stdin;
1	58a268c4-ffe5-46f2-bbe6-7801b8f21540	borrador	pendiente_aprobacion	b55e882e-c6e8-4a54-8af4-62d991128d98	\N	2025-09-03 01:57:24.772811+00
2	58a268c4-ffe5-46f2-bbe6-7801b8f21540	pendiente_aprobacion	aprobado	70843b92-a777-4eee-8ed2-4c2358680d40	\N	2025-09-03 02:01:16.576026+00
3	1a655b88-8df0-4bab-82d0-83f16eb425f9	borrador	pendiente_aprobacion	b55e882e-c6e8-4a54-8af4-62d991128d98	\N	2025-09-03 18:09:05.133077+00
4	b532d1a6-f317-42d8-ad95-e84a0dcd0f5d	borrador	pendiente_aprobacion	b55e882e-c6e8-4a54-8af4-62d991128d98	\N	2025-09-03 21:24:25.832657+00
5	b532d1a6-f317-42d8-ad95-e84a0dcd0f5d	pendiente_aprobacion	aprobado	70843b92-a777-4eee-8ed2-4c2358680d40	\N	2025-09-03 21:28:33.614375+00
6	1a655b88-8df0-4bab-82d0-83f16eb425f9	pendiente_aprobacion	aprobado	70843b92-a777-4eee-8ed2-4c2358680d40	\N	2025-09-08 20:35:51.867257+00
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, client_id, branch_id, created_by, status, subtotal, total, currency, created_at, updated_at) FROM stdin;
58a268c4-ffe5-46f2-bbe6-7801b8f21540	a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56	9c8b7a6d-5e4f-4c3b-9a8f-7e6d5c4b3a21	b55e882e-c6e8-4a54-8af4-62d991128d98	aprobado	36.25	36.25	USD	2025-09-03 01:44:55.438596+00	2025-09-03 02:01:16.341+00
f92c070e-06ed-4cd6-8580-e9b55704f1a9	a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56	9c8b7a6d-5e4f-4c3b-9a8f-7e6d5c4b3a21	70843b92-a777-4eee-8ed2-4c2358680d40	borrador	22.50	22.50	USD	2025-09-03 17:56:47.257325+00	2025-09-03 18:10:26.141768+00
b532d1a6-f317-42d8-ad95-e84a0dcd0f5d	a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56	9c8b7a6d-5e4f-4c3b-9a8f-7e6d5c4b3a21	b55e882e-c6e8-4a54-8af4-62d991128d98	aprobado	200.20	200.20	USD	2025-09-03 21:23:59.307471+00	2025-09-03 21:28:33.436+00
1fa21e4b-0c5b-445f-9f82-56f50689ccaa	a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56	9c8b7a6d-5e4f-4c3b-9a8f-7e6d5c4b3a21	70843b92-a777-4eee-8ed2-4c2358680d40	borrador	11.25	11.25	USD	2025-09-08 20:35:36.963858+00	2025-09-08 20:35:37.149822+00
1a655b88-8df0-4bab-82d0-83f16eb425f9	a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56	9c8b7a6d-5e4f-4c3b-9a8f-7e6d5c4b3a21	b55e882e-c6e8-4a54-8af4-62d991128d98	aprobado	11.25	11.25	USD	2025-09-03 18:06:10.274453+00	2025-09-08 20:35:51.617+00
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, order_id, method, provider_ref, status, amount, raw, created_at) FROM stdin;
\.


--
-- Data for Name: price_overrides; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_overrides (id, client_id, product_id, discount_pct, custom_price, created_at) FROM stdin;
c6fa0135-ef06-4e4f-b752-1b7072c2e496	a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56	0f4d6b2e-8c79-4b1e-8a9d-6f3a2b1c5d10	10.00	\N	2025-09-02 18:20:14.35926+00
96422be5-3b88-491d-ab5b-a33f2c25e3b4	a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56	3c4d5e6f-7081-4c92-9da0-3e4f5a6b7c80	\N	7.50	2025-09-02 18:20:14.35926+00
ffdf4251-537d-41b2-afb8-59bd6b04de42	581ea2b8-6935-41d8-bf55-8606448bebed	4d5e6f70-8192-4da3-8eb0-4f5a6b7c8d90	10.00	\N	2025-09-02 21:47:21.89503+00
\.


--
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_images (id, product_id, url, alt, sort, created_at) FROM stdin;
e19dd697-96d8-46fc-827d-3e484164cd32	0f4d6b2e-8c79-4b1e-8a9d-6f3a2b1c5d10	https://images.pexels.com/photos/4239146/pexels-photo-4239146.jpeg?auto=compress&cs=tinysrgb&w=500	Desinfectante Premium 1	0	2025-09-02 18:20:14.35926+00
9dab2923-61a9-4a07-bf56-2f6cf46184bc	0f4d6b2e-8c79-4b1e-8a9d-6f3a2b1c5d10	https://images.pexels.com/photos/4239149/pexels-photo-4239149.jpeg?auto=compress&cs=tinysrgb&w=500	Desinfectante Premium 2	1	2025-09-02 18:20:14.35926+00
2c643405-92d2-4fc2-b132-6fd082fc71cb	1a2b3c4d-5e6f-4a70-9b80-1c2d3e4f5a60	https://images.pexels.com/photos/3786157/pexels-photo-3786157.jpeg?auto=compress&cs=tinysrgb&w=500	Desinfectante Hospitalario 1	0	2025-09-02 18:20:14.35926+00
c178d75e-212f-45f3-a05d-3c6282a4a1a3	1a2b3c4d-5e6f-4a70-9b80-1c2d3e4f5a60	https://images.pexels.com/photos/4099355/pexels-photo-4099355.jpeg?auto=compress&cs=tinysrgb&w=500	Desinfectante Hospitalario 2	1	2025-09-02 18:20:14.35926+00
decbafdc-667c-4065-95f9-55984ae7e9f0	2b3c4d5e-6f70-4b81-8c90-2d3e4f5a6b70	https://images.pexels.com/photos/4239013/pexels-photo-4239013.jpeg?auto=compress&cs=tinysrgb&w=500	Desengrasante Cocinas 1	0	2025-09-02 18:20:14.35926+00
619512c7-4630-4bd5-a9c4-edee88b7e999	2b3c4d5e-6f70-4b81-8c90-2d3e4f5a6b70	https://images.pexels.com/photos/4062270/pexels-photo-4062270.jpeg?auto=compress&cs=tinysrgb&w=500	Desengrasante Cocinas 2	1	2025-09-02 18:20:14.35926+00
177cfe75-98cb-4a0f-a256-336ed3dd2d8d	3c4d5e6f-7081-4c92-9da0-3e4f5a6b7c80	https://images.pexels.com/photos/6195276/pexels-photo-6195276.jpeg?auto=compress&cs=tinysrgb&w=500	Vidrios Pro 1	0	2025-09-02 18:20:14.35926+00
96cdf498-4bf6-46b1-8b2d-5074c1c83685	3c4d5e6f-7081-4c92-9da0-3e4f5a6b7c80	https://images.pexels.com/photos/4239091/pexels-photo-4239091.jpeg?auto=compress&cs=tinysrgb&w=500	Vidrios Pro 2	1	2025-09-02 18:20:14.35926+00
00bad208-8109-4d12-8a4e-5bacc83d5001	4d5e6f70-8192-4da3-8eb0-4f5a6b7c8d90	https://images.pexels.com/photos/4167735/pexels-photo-4167735.jpeg?auto=compress&cs=tinysrgb&w=500	Antiséptico 1	0	2025-09-02 18:20:14.35926+00
9754e8b3-bc07-4583-9a9f-28c43607ff63	4d5e6f70-8192-4da3-8eb0-4f5a6b7c8d90	https://images.pexels.com/photos/4386467/pexels-photo-4386467.jpeg?auto=compress&cs=tinysrgb&w=500	Antiséptico 2	1	2025-09-02 18:20:14.35926+00
c4b4413b-61b4-4043-b617-6381f674a94f	5e6f7081-92a3-4eb4-9fc0-5a6b7c8d9ea0	https://images.pexels.com/photos/4239122/pexels-photo-4239122.jpeg?auto=compress&cs=tinysrgb&w=500	Acero Inox 1	0	2025-09-02 18:20:14.35926+00
7799c91e-b1c0-41bf-9493-9f97340b49fe	5e6f7081-92a3-4eb4-9fc0-5a6b7c8d9ea0	https://images.pexels.com/photos/4239075/pexels-photo-4239075.jpeg?auto=compress&cs=tinysrgb&w=500	Acero Inox 2	1	2025-09-02 18:20:14.35926+00
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, category_id, name, slug, description, unit, list_price, active, created_at) FROM stdin;
0f4d6b2e-8c79-4b1e-8a9d-6f3a2b1c5d10	7f1e1a10-4e78-4a9b-9a84-b01d7f0b3a10	Desinfectante Multi-Uso Premium	desinfectante-multiuso-premium	Desinfectante de alta calidad para múltiples superficies. Elimina 99.9% de gérmenes y bacterias.	Botella 1L	12.50	t	2025-09-02 18:20:14.35926+00
1a2b3c4d-5e6f-4a70-9b80-1c2d3e4f5a60	d2a9c2f1-3c7e-4b93-8e2d-9f4c1a5b6c71	Desinfectante Hospitalario	desinfectante-hospitalario	Desinfectante de grado médico para hospitales y clínicas.	Galón 4L	35.20	t	2025-09-02 18:20:14.35926+00
2b3c4d5e-6f70-4b81-8c90-2d3e4f5a6b70	b6f3d5a1-9c4e-4c33-96e1-2a7b8c6d5e91	Desengrasante para Cocinas	desengrasante-cocinas	Potente desengrasante para cocinas profesionales.	Envase 5L	28.75	t	2025-09-02 18:20:14.35926+00
3c4d5e6f-7081-4c92-9da0-3e4f5a6b7c80	7f1e1a10-4e78-4a9b-9a84-b01d7f0b3a10	Limpiador de Vidrios Profesional	limpiador-vidrios-profesional	Limpiador para vidrios que no deja residuos ni rayas.	Spray 750ml	8.90	t	2025-09-02 18:20:14.35926+00
4d5e6f70-8192-4da3-8eb0-4f5a6b7c8d90	d2a9c2f1-3c7e-4b93-8e2d-9f4c1a5b6c71	Antiséptico Quirúrgico	antiseptico-quirurgico	Antiséptico de uso hospitalario.	Botella 500ml	45.80	t	2025-09-02 18:20:14.35926+00
5e6f7081-92a3-4eb4-9fc0-5a6b7c8d9ea0	b6f3d5a1-9c4e-4c33-96e1-2a7b8c6d5e91	Limpiador de Acero Inoxidable	limpiador-acero-inoxidable	Especial para acero inoxidable en cocinas comerciales.	Spray 1L	18.95	t	2025-09-02 18:20:14.35926+00
\.


--
-- Data for Name: user_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profiles (user_id, display_name, role_app, phone, created_at) FROM stdin;
d4251f9f-aa29-49c8-b845-9d78dc4f46b8	Admin Demo	admin	\N	2025-09-02 19:17:54.918244+00
b55e882e-c6e8-4a54-8af4-62d991128d98	Gerente Río Abajo Demo	cliente_gerente_sucursal	\N	2025-09-02 19:17:55.373325+00
70843b92-a777-4eee-8ed2-4c2358680d40	Master Demo	cliente_master	\N	2025-09-02 19:17:55.123231+00
dba7d5f5-35b7-41f2-b153-7335e335d4cb	Ramona	\N	\N	2025-09-03 03:03:29.490371+00
4274e005-de93-409c-a96e-16f53adbabd4	lopito	cliente_gerente_sucursal	\N	2025-09-03 05:57:57.887347+00
\.


--
-- Data for Name: webhook_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.webhook_events (id, source, event_type, payload, received_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-09-02 18:19:19
20211116045059	2025-09-02 18:19:22
20211116050929	2025-09-02 18:19:24
20211116051442	2025-09-02 18:19:26
20211116212300	2025-09-02 18:19:29
20211116213355	2025-09-02 18:19:31
20211116213934	2025-09-02 18:19:33
20211116214523	2025-09-02 18:19:36
20211122062447	2025-09-02 18:19:38
20211124070109	2025-09-02 18:19:40
20211202204204	2025-09-02 18:19:42
20211202204605	2025-09-02 18:19:45
20211210212804	2025-09-02 18:19:52
20211228014915	2025-09-02 18:19:54
20220107221237	2025-09-02 18:19:56
20220228202821	2025-09-02 18:19:58
20220312004840	2025-09-02 18:20:00
20220603231003	2025-09-02 18:20:04
20220603232444	2025-09-02 18:20:06
20220615214548	2025-09-02 18:20:09
20220712093339	2025-09-02 18:20:11
20220908172859	2025-09-02 18:20:13
20220916233421	2025-09-02 18:20:15
20230119133233	2025-09-02 18:20:17
20230128025114	2025-09-02 18:20:20
20230128025212	2025-09-02 18:20:22
20230227211149	2025-09-02 18:20:24
20230228184745	2025-09-02 18:20:27
20230308225145	2025-09-02 18:20:29
20230328144023	2025-09-02 18:20:31
20231018144023	2025-09-02 18:20:34
20231204144023	2025-09-02 18:20:37
20231204144024	2025-09-02 18:20:39
20231204144025	2025-09-02 18:20:41
20240108234812	2025-09-02 18:20:43
20240109165339	2025-09-02 18:20:46
20240227174441	2025-09-02 18:20:50
20240311171622	2025-09-02 18:20:53
20240321100241	2025-09-02 18:20:57
20240401105812	2025-09-02 18:21:03
20240418121054	2025-09-02 18:21:06
20240523004032	2025-09-02 18:21:14
20240618124746	2025-09-02 18:21:16
20240801235015	2025-09-02 18:21:18
20240805133720	2025-09-02 18:21:20
20240827160934	2025-09-02 18:21:23
20240919163303	2025-09-02 18:21:26
20240919163305	2025-09-02 18:21:28
20241019105805	2025-09-02 18:21:30
20241030150047	2025-09-02 18:21:38
20241108114728	2025-09-02 18:21:41
20241121104152	2025-09-02 18:21:43
20241130184212	2025-09-02 18:21:46
20241220035512	2025-09-02 18:21:48
20241220123912	2025-09-02 18:21:50
20241224161212	2025-09-02 18:21:52
20250107150512	2025-09-02 18:21:54
20250110162412	2025-09-02 18:21:56
20250123174212	2025-09-02 18:21:59
20250128220012	2025-09-02 18:22:01
20250506224012	2025-09-02 18:22:02
20250523164012	2025-09-02 18:22:05
20250714121412	2025-09-02 18:22:07
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-09-02 18:19:11.499855
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-09-02 18:19:11.503381
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-09-02 18:19:11.506175
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-09-02 18:19:11.517635
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-09-02 18:19:11.53288
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-09-02 18:19:11.537259
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-09-02 18:19:11.542244
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-09-02 18:19:11.546876
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-09-02 18:19:11.551109
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-09-02 18:19:11.556633
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-09-02 18:19:11.561688
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-09-02 18:19:11.568016
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-09-02 18:19:11.575044
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-09-02 18:19:11.578974
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-09-02 18:19:11.584093
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-09-02 18:19:11.610985
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-09-02 18:19:11.617424
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-09-02 18:19:11.621794
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-09-02 18:19:11.627872
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-09-02 18:19:11.63402
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-09-02 18:19:11.639207
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-09-02 18:19:11.649278
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-09-02 18:19:11.671355
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-09-02 18:19:11.680539
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-09-02 18:19:11.683557
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-09-02 18:19:11.686511
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: postgres
--

COPY supabase_migrations.schema_migrations (version, statements, name) FROM stdin;
	{"-- ================================================================\\\\n-- SUPROSER — Esquema completo e idempotente para Supabase (Postgres)\\\\n-- ================================================================\\\\n\\\\n-- Extensiones necesarias\\\\nCREATE EXTENSION IF NOT EXISTS \\"pgcrypto\\""," -- para gen_random_uuid()\\\\n\\\\n-- ================================================================\\\\n-- 1) TABLAS\\\\n-- ================================================================\\\\n\\\\n-- Perfiles de usuario (roles de la app)\\\\nCREATE TABLE IF NOT EXISTS public.user_profiles (\\\\n  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,\\\\n  display_name text,\\\\n  role_app text CHECK (role_app IN ('admin','cliente_master','cliente_gerente_sucursal')),\\\\n  phone text,\\\\n  created_at timestamptz DEFAULT now()\\\\n)","\\\\n\\\\n-- Clientes (empresas)\\\\nCREATE TABLE IF NOT EXISTS public.clients (\\\\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\\\\n  name text NOT NULL,\\\\n  tax_id text,\\\\n  billing_email text,\\\\n  created_at timestamptz DEFAULT now()\\\\n)","\\\\n\\\\n-- Sucursales del cliente\\\\nCREATE TABLE IF NOT EXISTS public.client_branches (\\\\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\\\\n  client_id uuid NOT NULL REFERENCES public.clients(id) ON DELETE CASCADE,\\\\n  name text NOT NULL,\\\\n  code text,\\\\n  address text,\\\\n  created_at timestamptz DEFAULT now()\\\\n)","\\\\n\\\\n-- Relación usuarios ↔ cliente ↔ sucursal\\\\nCREATE TABLE IF NOT EXISTS public.client_users (\\\\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\\\\n  client_id uuid NOT NULL REFERENCES public.clients(id) ON DELETE CASCADE,\\\\n  branch_id uuid REFERENCES public.client_branches(id) ON DELETE CASCADE,\\\\n  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\\\\n  role_in_client text CHECK (role_in_client IN ('master','gerente_sucursal')),\\\\n  created_at timestamptz DEFAULT now()\\\\n)","\\\\n\\\\n-- Categorías\\\\nCREATE TABLE IF NOT EXISTS public.categories (\\\\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\\\\n  name text UNIQUE NOT NULL,\\\\n  slug text UNIQUE NOT NULL,\\\\n  created_at timestamptz DEFAULT now()\\\\n)","\\\\n\\\\n-- Productos\\\\nCREATE TABLE IF NOT EXISTS public.products (\\\\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\\\\n  category_id uuid NOT NULL REFERENCES public.categories(id) ON DELETE RESTRICT,\\\\n  name text NOT NULL,\\\\n  slug text UNIQUE NOT NULL,\\\\n  description text,\\\\n  unit text,\\\\n  list_price numeric(12,2) NOT NULL,\\\\n  active boolean DEFAULT true,\\\\n  created_at timestamptz DEFAULT now()\\\\n)","\\\\n\\\\n-- Imágenes de producto (solo URL)\\\\nCREATE TABLE IF NOT EXISTS public.product_images (\\\\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\\\\n  product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,\\\\n  url text NOT NULL,\\\\n  alt text,\\\\n  sort integer DEFAULT 0,\\\\n  created_at timestamptz DEFAULT now()\\\\n)","\\\\n\\\\n-- Overrides de precio por cliente\\\\nCREATE TABLE IF NOT EXISTS public.price_overrides (\\\\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\\\\n  client_id uuid NOT NULL REFERENCES public.clients(id) ON DELETE CASCADE,\\\\n  product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,\\\\n  discount_pct numeric(5,2),\\\\n  custom_price numeric(12,2),\\\\n  created_at timestamptz DEFAULT now(),\\\\n  CONSTRAINT price_overrides_valid CHECK (discount_pct IS NOT NULL OR custom_price IS NOT NULL)\\\\n)","\\\\n\\\\n-- Pedidos\\\\nCREATE TABLE IF NOT EXISTS public.orders (\\\\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\\\\n  client_id uuid NOT NULL REFERENCES public.clients(id) ON DELETE RESTRICT,\\\\n  branch_id uuid NOT NULL REFERENCES public.client_branches(id) ON DELETE RESTRICT,\\\\n  created_by uuid NOT NULL REFERENCES auth.users(id) ON DELETE RESTRICT,\\\\n  status text CHECK (status IN ('borrador','pendiente_aprobacion','aprobado','pagado','en_preparacion','despachado','completado','anulado')) DEFAULT 'borrador',\\\\n  subtotal numeric(12,2) DEFAULT 0,\\\\n  total numeric(12,2) DEFAULT 0,\\\\n  currency text DEFAULT 'USD',\\\\n  created_at timestamptz DEFAULT now(),\\\\n  updated_at timestamptz DEFAULT now()\\\\n)","\\\\n\\\\n-- Ítems de pedido\\\\nCREATE TABLE IF NOT EXISTS public.order_items (\\\\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\\\\n  order_id uuid NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,\\\\n  product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE RESTRICT,\\\\n  qty numeric(12,3) NOT NULL,\\\\n  unit_price numeric(12,2) NOT NULL,\\\\n  line_total numeric(12,2) NOT NULL,\\\\n  created_at timestamptz DEFAULT now()\\\\n)","\\\\n\\\\n-- Historial de estados de pedido\\\\nCREATE TABLE IF NOT EXISTS public.order_status_history (\\\\n  id bigserial PRIMARY KEY,\\\\n  order_id uuid NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,\\\\n  from_status text,\\\\n  to_status text,\\\\n  by_user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,\\\\n  note text,\\\\n  at timestamptz DEFAULT now()\\\\n)","\\\\n\\\\n-- Pagos\\\\nCREATE TABLE IF NOT EXISTS public.payments (\\\\n  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),\\\\n  order_id uuid UNIQUE NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,\\\\n  method text CHECK (method IN ('yappy','bg_cybersource')),\\\\n  provider_ref text,\\\\n  status text CHECK (status IN ('init','pending','approved','declined','error','refunded')) DEFAULT 'init',\\\\n  amount numeric(12,2),\\\\n  raw jsonb,\\\\n  created_at timestamptz DEFAULT now()\\\\n)","\\\\n\\\\n-- Eventos de webhooks (auditoría técnica)\\\\nCREATE TABLE IF NOT EXISTS public.webhook_events (\\\\n  id bigserial PRIMARY KEY,\\\\n  source text,\\\\n  event_type text,\\\\n  payload jsonb,\\\\n  received_at timestamptz DEFAULT now()\\\\n)","\\\\n\\\\n-- Bitácora de seguridad/acciones\\\\nCREATE TABLE IF NOT EXISTS public.audit_log (\\\\n  id bigserial PRIMARY KEY,\\\\n  at timestamptz DEFAULT now(),\\\\n  actor_user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,\\\\n  action text,\\\\n  entity text,\\\\n  entity_id text,\\\\n  meta jsonb\\\\n)","\\\\n\\\\n-- ================================================================\\\\n-- 2) ÍNDICES Y RESTRICCIONES (unicidades)\\\\n-- ================================================================\\\\n\\\\n-- Un master por (user,client)"," branch no aplica\\\\nCREATE UNIQUE INDEX IF NOT EXISTS idx_client_users_master_unique\\\\n  ON public.client_users(user_id, client_id)\\\\n  WHERE role_in_client = 'master'","\\\\n\\\\n-- Un gerente por (user,client,branch) con branch obligatorio\\\\nCREATE UNIQUE INDEX IF NOT EXISTS idx_client_users_gerente_unique\\\\n  ON public.client_users(user_id, client_id, branch_id)\\\\n  WHERE role_in_client = 'gerente_sucursal' AND branch_id IS NOT NULL","\\\\n\\\\n-- Un override por (cliente, producto)\\\\nCREATE UNIQUE INDEX IF NOT EXISTS idx_price_overrides_unique\\\\n  ON public.price_overrides(client_id, product_id)","\\\\n\\\\n-- Performance\\\\nCREATE INDEX IF NOT EXISTS idx_products_category ON public.products(category_id)","\\\\nCREATE INDEX IF NOT EXISTS idx_products_active ON public.products(active) WHERE active = true","\\\\nCREATE INDEX IF NOT EXISTS idx_order_items_order ON public.order_items(order_id)","\\\\nCREATE INDEX IF NOT EXISTS idx_product_images_product ON public.product_images(product_id)","\\\\nCREATE INDEX IF NOT EXISTS idx_orders_client ON public.orders(client_id)","\\\\nCREATE INDEX IF NOT EXISTS idx_orders_branch ON public.orders(branch_id)","\\\\nCREATE INDEX IF NOT EXISTS idx_orders_status ON public.orders(status)","\\\\n\\\\n-- ================================================================\\\\n-- 3) FUNCIONES\\\\n-- ================================================================\\\\n\\\\n-- Retornar rol de app del usuario\\\\nCREATE OR REPLACE FUNCTION public.get_user_role(user_uuid uuid)\\\\nRETURNS text\\\\nLANGUAGE sql\\\\nSTABLE\\\\nAS $$\\\\n  SELECT role_app FROM public.user_profiles WHERE user_id = user_uuid\\\\n$$","\\\\n\\\\n-- Registrar evento de seguridad\\\\nCREATE OR REPLACE FUNCTION public.log_security_event(\\\\n  actor uuid,\\\\n  action text,\\\\n  entity text,\\\\n  entity_id text,\\\\n  meta jsonb DEFAULT '{}'::jsonb\\\\n)\\\\nRETURNS void\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nAS $$\\\\nBEGIN\\\\n  INSERT INTO public.audit_log (actor_user_id, action, entity, entity_id, meta)\\\\n  VALUES (actor, action, entity, entity_id, meta)","\\\\nEND","\\\\n$$","\\\\n\\\\n-- Calcular totales de pedido\\\\nCREATE OR REPLACE FUNCTION public.calculate_order_totals(order_uuid uuid)\\\\nRETURNS void\\\\nLANGUAGE plpgsql\\\\nAS $$\\\\nDECLARE\\\\n  new_subtotal numeric(12,2)","\\\\nBEGIN\\\\n  SELECT COALESCE(SUM(line_total), 0)\\\\n    INTO new_subtotal\\\\n    FROM public.order_items\\\\n   WHERE order_id = order_uuid","\\\\n\\\\n  UPDATE public.orders\\\\n     SET subtotal = new_subtotal,\\\\n         total    = new_subtotal,\\\\n         updated_at = now()\\\\n   WHERE id = order_uuid","\\\\nEND","\\\\n$$","\\\\n\\\\n-- BEFORE trigger: setear line_total\\\\nCREATE OR REPLACE FUNCTION public.order_items_before_set_line_total()\\\\nRETURNS trigger\\\\nLANGUAGE plpgsql\\\\nAS $$\\\\nBEGIN\\\\n  NEW.line_total := ROUND(NEW.qty * NEW.unit_price, 2)","\\\\n  RETURN NEW","\\\\nEND","\\\\n$$","\\\\n\\\\n-- AFTER trigger: recalcular totales (INSERT/UPDATE/DELETE)\\\\nCREATE OR REPLACE FUNCTION public.order_items_after_recalc_totals()\\\\nRETURNS trigger\\\\nLANGUAGE plpgsql\\\\nAS $$\\\\nBEGIN\\\\n  IF TG_OP = 'DELETE' THEN\\\\n    PERFORM public.calculate_order_totals(OLD.order_id)","\\\\n    RETURN OLD","\\\\n  ELSE\\\\n    PERFORM public.calculate_order_totals(NEW.order_id)","\\\\n    RETURN NEW","\\\\n  END IF","\\\\nEND","\\\\n$$","\\\\n\\\\n-- Registrar cambio de estado en historial\\\\nCREATE OR REPLACE FUNCTION public.track_order_status_change()\\\\nRETURNS trigger\\\\nLANGUAGE plpgsql\\\\nAS $$\\\\nBEGIN\\\\n  IF OLD.status IS DISTINCT FROM NEW.status THEN\\\\n    INSERT INTO public.order_status_history (order_id, from_status, to_status, by_user_id)\\\\n    VALUES (NEW.id, OLD.status, NEW.status, auth.uid())","\\\\n  END IF","\\\\n  RETURN NEW","\\\\nEND","\\\\n$$","\\\\n\\\\n-- ================================================================\\\\n-- 4) VISTA DE PRECIOS EFECTIVOS\\\\n-- ================================================================\\\\n\\\\nCREATE OR REPLACE VIEW public.v_effective_prices AS\\\\nSELECT \\\\n  p.id  AS product_id,\\\\n  c.id  AS client_id,\\\\n  CASE \\\\n    WHEN po.custom_price IS NOT NULL THEN po.custom_price\\\\n    WHEN po.discount_pct IS NOT NULL THEN ROUND(p.list_price * (1 - po.discount_pct / 100), 2)\\\\n    ELSE p.list_price\\\\n  END AS effective_price\\\\nFROM public.products p\\\\nCROSS JOIN public.clients c\\\\nLEFT JOIN public.price_overrides po\\\\n       ON po.product_id = p.id AND po.client_id = c.id\\\\nWHERE p.active = true","\\\\n\\\\n-- ================================================================\\\\n-- 5) TRIGGERS\\\\n-- ================================================================\\\\n\\\\n-- order_items: BEFORE set line_total\\\\nDROP TRIGGER IF EXISTS trg_oitems_before_set_total ON public.order_items","\\\\nCREATE TRIGGER trg_oitems_before_set_total\\\\n  BEFORE INSERT OR UPDATE ON public.order_items\\\\n  FOR EACH ROW EXECUTE FUNCTION public.order_items_before_set_line_total()","\\\\n\\\\n-- order_items: AFTER recalc totals\\\\nDROP TRIGGER IF EXISTS trg_oitems_after_recalc ON public.order_items","\\\\nCREATE TRIGGER trg_oitems_after_recalc\\\\n  AFTER INSERT OR UPDATE OR DELETE ON public.order_items\\\\n  FOR EACH ROW EXECUTE FUNCTION public.order_items_after_recalc_totals()","\\\\n\\\\n-- orders: track status changes\\\\nDROP TRIGGER IF EXISTS trg_orders_status_history ON public.orders","\\\\nCREATE TRIGGER trg_orders_status_history\\\\n  AFTER UPDATE ON public.orders\\\\n  FOR EACH ROW EXECUTE FUNCTION public.track_order_status_change()","\\\\n\\\\n-- ================================================================\\\\n-- 6) RLS: habilitar y políticas\\\\n-- ================================================================\\\\n\\\\nALTER TABLE public.user_profiles        ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.clients              ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.client_branches      ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.client_users         ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.categories           ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.products             ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.product_images       ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.price_overrides      ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.orders               ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.order_items          ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.order_status_history ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.payments             ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.webhook_events       ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.audit_log            ENABLE ROW LEVEL SECURITY","\\\\n\\\\n-- user_profiles\\\\nDROP POLICY IF EXISTS profiles_read_own   ON public.user_profiles","\\\\nCREATE POLICY profiles_read_own\\\\n  ON public.user_profiles FOR SELECT\\\\n  TO authenticated\\\\n  USING (user_id = auth.uid())","\\\\n\\\\nDROP POLICY IF EXISTS profiles_update_own ON public.user_profiles","\\\\nCREATE POLICY profiles_update_own\\\\n  ON public.user_profiles FOR UPDATE\\\\n  TO authenticated\\\\n  USING (user_id = auth.uid())","\\\\n\\\\nDROP POLICY IF EXISTS profiles_admin_all  ON public.user_profiles","\\\\nCREATE POLICY profiles_admin_all\\\\n  ON public.user_profiles FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- categories (lectura pública)\\\\nDROP POLICY IF EXISTS categories_public_read ON public.categories","\\\\nCREATE POLICY categories_public_read\\\\n  ON public.categories FOR SELECT\\\\n  TO anon, authenticated\\\\n  USING (true)","\\\\n\\\\nDROP POLICY IF EXISTS categories_admin_all ON public.categories","\\\\nCREATE POLICY categories_admin_all\\\\n  ON public.categories FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- products (lectura pública de activos)\\\\nDROP POLICY IF EXISTS products_public_read ON public.products","\\\\nCREATE POLICY products_public_read\\\\n  ON public.products FOR SELECT\\\\n  TO anon, authenticated\\\\n  USING (active = true)","\\\\n\\\\nDROP POLICY IF EXISTS products_admin_all ON public.products","\\\\nCREATE POLICY products_admin_all\\\\n  ON public.products FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- product_images (lectura pública si producto activo)\\\\nDROP POLICY IF EXISTS pimgs_public_read ON public.product_images","\\\\nCREATE POLICY pimgs_public_read\\\\n  ON public.product_images FOR SELECT\\\\n  TO anon, authenticated\\\\n  USING (EXISTS (SELECT 1 FROM public.products p WHERE p.id = product_id AND p.active = true))","\\\\n\\\\nDROP POLICY IF EXISTS pimgs_admin_all ON public.product_images","\\\\nCREATE POLICY pimgs_admin_all\\\\n  ON public.product_images FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- clients\\\\nDROP POLICY IF EXISTS clients_read_scoped ON public.clients","\\\\nCREATE POLICY clients_read_scoped\\\\n  ON public.clients FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (SELECT 1 FROM public.client_users cu WHERE cu.user_id = auth.uid() AND cu.client_id = public.clients.id)\\\\n  )","\\\\n\\\\nDROP POLICY IF EXISTS clients_admin_all ON public.clients","\\\\nCREATE POLICY clients_admin_all\\\\n  ON public.clients FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- client_branches\\\\nDROP POLICY IF EXISTS branches_read_scoped ON public.client_branches","\\\\nCREATE POLICY branches_read_scoped\\\\n  ON public.client_branches FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (SELECT 1 FROM public.client_users cu WHERE cu.user_id = auth.uid() AND cu.client_id = public.client_branches.client_id)\\\\n  )","\\\\n\\\\nDROP POLICY IF EXISTS branches_manage_admin_master ON public.client_branches","\\\\nCREATE POLICY branches_manage_admin_master\\\\n  ON public.client_branches FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu\\\\n       WHERE cu.user_id = auth.uid()\\\\n         AND cu.client_id = public.client_branches.client_id\\\\n         AND cu.role_in_client = 'master'\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu\\\\n       WHERE cu.user_id = auth.uid()\\\\n         AND cu.client_id = public.client_branches.client_id\\\\n         AND cu.role_in_client = 'master'\\\\n    )\\\\n  )","\\\\n\\\\n-- client_users\\\\nDROP POLICY IF EXISTS cusers_read ON public.client_users","\\\\nCREATE POLICY cusers_read\\\\n  ON public.client_users FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR user_id = auth.uid()\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu2\\\\n       WHERE cu2.user_id = auth.uid()\\\\n         AND cu2.client_id = public.client_users.client_id\\\\n         AND cu2.role_in_client = 'master'\\\\n    )\\\\n  )","\\\\n\\\\nDROP POLICY IF EXISTS cusers_manage_admin_master ON public.client_users","\\\\nCREATE POLICY cusers_manage_admin_master\\\\n  ON public.client_users FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu2\\\\n       WHERE cu2.user_id = auth.uid()\\\\n         AND cu2.client_id = public.client_users.client_id\\\\n         AND cu2.role_in_client = 'master'\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu2\\\\n       WHERE cu2.user_id = auth.uid()\\\\n         AND cu2.client_id = public.client_users.client_id\\\\n         AND cu2.role_in_client = 'master'\\\\n    )\\\\n  )","\\\\n\\\\n-- price_overrides\\\\nDROP POLICY IF EXISTS poverrides_read_scoped ON public.price_overrides","\\\\nCREATE POLICY poverrides_read_scoped\\\\n  ON public.price_overrides FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (SELECT 1 FROM public.client_users cu WHERE cu.user_id = auth.uid() AND cu.client_id = public.price_overrides.client_id)\\\\n  )","\\\\n\\\\nDROP POLICY IF EXISTS poverrides_admin_all ON public.price_overrides","\\\\nCREATE POLICY poverrides_admin_all\\\\n  ON public.price_overrides FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- orders\\\\nDROP POLICY IF EXISTS orders_read_scoped ON public.orders","\\\\nCREATE POLICY orders_read_scoped\\\\n  ON public.orders FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu\\\\n       WHERE cu.user_id = auth.uid()\\\\n         AND cu.client_id = public.orders.client_id\\\\n         AND (\\\\n           cu.role_in_client = 'master'\\\\n           OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = public.orders.branch_id)\\\\n         )\\\\n    )\\\\n  )","\\\\n\\\\nDROP POLICY IF EXISTS orders_insert_scoped ON public.orders","\\\\nCREATE POLICY orders_insert_scoped\\\\n  ON public.orders FOR INSERT\\\\n  TO authenticated\\\\n  WITH CHECK (\\\\n    EXISTS (\\\\n      SELECT 1 FROM public.client_users cu\\\\n       WHERE cu.user_id = auth.uid()\\\\n         AND cu.client_id = public.orders.client_id\\\\n         AND (\\\\n           cu.role_in_client = 'master'\\\\n           OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = public.orders.branch_id)\\\\n         )\\\\n    )\\\\n  )","\\\\n\\\\nDROP POLICY IF EXISTS orders_update_scoped ON public.orders","\\\\nCREATE POLICY orders_update_scoped\\\\n  ON public.orders FOR UPDATE\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu\\\\n       WHERE cu.user_id = auth.uid()\\\\n         AND cu.client_id = public.orders.client_id\\\\n         AND (\\\\n           cu.role_in_client = 'master'\\\\n           OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = public.orders.branch_id)\\\\n         )\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu\\\\n       WHERE cu.user_id = auth.uid()\\\\n         AND cu.client_id = public.orders.client_id\\\\n         AND (\\\\n           cu.role_in_client = 'master'\\\\n           OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = public.orders.branch_id)\\\\n         )\\\\n    )\\\\n  )","\\\\n\\\\n-- order_items\\\\nDROP POLICY IF EXISTS oitems_read_scoped ON public.order_items","\\\\nCREATE POLICY oitems_read_scoped\\\\n  ON public.order_items FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.orders o\\\\n      JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n      WHERE o.id = public.order_items.order_id\\\\n        AND cu.user_id = auth.uid()\\\\n        AND (\\\\n          cu.role_in_client = 'master'\\\\n          OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = o.branch_id)\\\\n        )\\\\n    )\\\\n  )","\\\\n\\\\nDROP POLICY IF EXISTS oitems_manage_scoped ON public.order_items","\\\\nCREATE POLICY oitems_manage_scoped\\\\n  ON public.order_items FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.orders o\\\\n      JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n      WHERE o.id = public.order_items.order_id\\\\n        AND cu.user_id = auth.uid()\\\\n        AND (\\\\n          cu.role_in_client = 'master'\\\\n          OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = o.branch_id)\\\\n        )\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.orders o\\\\n      JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n      WHERE o.id = public.order_items.order_id\\\\n        AND cu.user_id = auth.uid()\\\\n        AND (\\\\n          cu.role_in_client = 'master'\\\\n          OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = o.branch_id)\\\\n        )\\\\n    )\\\\n  )","\\\\n\\\\n-- order_status_history\\\\nDROP POLICY IF EXISTS ostatus_read_scoped ON public.order_status_history","\\\\nCREATE POLICY ostatus_read_scoped\\\\n  ON public.order_status_history FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.orders o\\\\n      JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n      WHERE o.id = public.order_status_history.order_id\\\\n        AND cu.user_id = auth.uid()\\\\n    )\\\\n  )","\\\\n\\\\nDROP POLICY IF EXISTS ostatus_insert_by_trigger ON public.order_status_history","\\\\nCREATE POLICY ostatus_insert_by_trigger\\\\n  ON public.order_status_history FOR INSERT\\\\n  TO authenticated\\\\n  WITH CHECK (true)","\\\\n\\\\n-- payments\\\\nDROP POLICY IF EXISTS payments_read_scoped ON public.payments","\\\\nCREATE POLICY payments_read_scoped\\\\n  ON public.payments FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.orders o\\\\n      JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n      WHERE o.id = public.payments.order_id\\\\n        AND cu.user_id = auth.uid()\\\\n    )\\\\n  )","\\\\n\\\\nDROP POLICY IF EXISTS payments_admin_all ON public.payments","\\\\nCREATE POLICY payments_admin_all\\\\n  ON public.payments FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- webhook_events (solo admin)\\\\nDROP POLICY IF EXISTS webhooks_admin_all ON public.webhook_events","\\\\nCREATE POLICY webhooks_admin_all\\\\n  ON public.webhook_events FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- audit_log (solo admin para lectura"," insert libre por función)\\\\nDROP POLICY IF EXISTS audit_admin_read ON public.audit_log","\\\\nCREATE POLICY audit_admin_read\\\\n  ON public.audit_log FOR SELECT\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\nDROP POLICY IF EXISTS audit_insert ON public.audit_log","\\\\nCREATE POLICY audit_insert\\\\n  ON public.audit_log FOR INSERT\\\\n  TO authenticated\\\\n  WITH CHECK (true)","\\\\n\\\\n-- ================================================================\\\\n-- 7) SEEDS (idempotentes"," sin tocar auth.users)\\\\n-- ================================================================\\\\n\\\\n-- IDs fijos válidos (v4) para datos demo\\\\n-- Categorías\\\\n--  Hogar\\\\n--  Hospitales y Clínicas\\\\n--  Cocinas y Restaurantes\\\\n-- Cliente demo y Sucursal\\\\n--  Cliente Demo S.A.  /  Río Abajo\\\\n-- Productos (6)\\\\n--  p1..p6\\\\n-- (Todos son UUID v4 válidos)\\\\n\\\\n-- Categorías\\\\nINSERT INTO public.categories (id, name, slug) VALUES\\\\n  ('7f1e1a10-4e78-4a9b-9a84-b01d7f0b3a10','Hogar','hogar'),\\\\n  ('d2a9c2f1-3c7e-4b93-8e2d-9f4c1a5b6c71','Hospitales y Clínicas','hospitales-clinicas'),\\\\n  ('b6f3d5a1-9c4e-4c33-96e1-2a7b8c6d5e91','Cocinas y Restaurantes','cocinas-restaurantes')\\\\nON CONFLICT (slug) DO NOTHING","\\\\n\\\\n-- Cliente demo\\\\nINSERT INTO public.clients (id, name, tax_id, billing_email) VALUES\\\\n  ('a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56','Cliente Demo S.A.','123456789-1-DV','admin@clientedemo.com')\\\\nON CONFLICT (id) DO NOTHING","\\\\n\\\\n-- Sucursal demo\\\\nINSERT INTO public.client_branches (id, client_id, name, code, address) VALUES\\\\n  ('9c8b7a6d-5e4f-4c3b-9a8f-7e6d5c4b3a21','a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56','Río Abajo','RA001','Río Abajo, Ciudad de Panamá')\\\\nON CONFLICT (id) DO NOTHING","\\\\n\\\\n-- Productos (6)\\\\nINSERT INTO public.products (id, category_id, name, slug, description, unit, list_price, active) VALUES\\\\n  ('0f4d6b2e-8c79-4b1e-8a9d-6f3a2b1c5d10','7f1e1a10-4e78-4a9b-9a84-b01d7f0b3a10','Desinfectante Multi-Uso Premium','desinfectante-multiuso-premium','Desinfectante de alta calidad para múltiples superficies. Elimina 99.9% de gérmenes y bacterias.','Botella 1L',12.50,true),\\\\n  ('1a2b3c4d-5e6f-4a70-9b80-1c2d3e4f5a60','d2a9c2f1-3c7e-4b93-8e2d-9f4c1a5b6c71','Desinfectante Hospitalario','desinfectante-hospitalario','Desinfectante de grado médico para hospitales y clínicas.','Galón 4L',35.20,true),\\\\n  ('2b3c4d5e-6f70-4b81-8c90-2d3e4f5a6b70','b6f3d5a1-9c4e-4c33-96e1-2a7b8c6d5e91','Desengrasante para Cocinas','desengrasante-cocinas','Potente desengrasante para cocinas profesionales.','Envase 5L',28.75,true),\\\\n  ('3c4d5e6f-7081-4c92-9da0-3e4f5a6b7c80','7f1e1a10-4e78-4a9b-9a84-b01d7f0b3a10','Limpiador de Vidrios Profesional','limpiador-vidrios-profesional','Limpiador para vidrios que no deja residuos ni rayas.','Spray 750ml',8.90,true),\\\\n  ('4d5e6f70-8192-4da3-8eb0-4f5a6b7c8d90','d2a9c2f1-3c7e-4b93-8e2d-9f4c1a5b6c71','Antiséptico Quirúrgico','antiseptico-quirurgico','Antiséptico de uso hospitalario.','Botella 500ml',45.80,true),\\\\n  ('5e6f7081-92a3-4eb4-9fc0-5a6b7c8d9ea0','b6f3d5a1-9c4e-4c33-96e1-2a7b8c6d5e91','Limpiador de Acero Inoxidable','limpiador-acero-inoxidable','Especial para acero inoxidable en cocinas comerciales.','Spray 1L',18.95,true)\\\\nON CONFLICT (slug) DO NOTHING","\\\\n\\\\n-- Imágenes (2 por producto)\\\\nINSERT INTO public.product_images (product_id, url, alt, sort) VALUES\\\\n  ('0f4d6b2e-8c79-4b1e-8a9d-6f3a2b1c5d10','https://images.pexels.com/photos/4239146/pexels-photo-4239146.jpeg?auto=compress&cs=tinysrgb&w=500','Desinfectante Premium 1',0),\\\\n  ('0f4d6b2e-8c79-4b1e-8a9d-6f3a2b1c5d10','https://images.pexels.com/photos/4239149/pexels-photo-4239149.jpeg?auto=compress&cs=tinysrgb&w=500','Desinfectante Premium 2',1),\\\\n  ('1a2b3c4d-5e6f-4a70-9b80-1c2d3e4f5a60','https://images.pexels.com/photos/3786157/pexels-photo-3786157.jpeg?auto=compress&cs=tinysrgb&w=500','Desinfectante Hospitalario 1',0),\\\\n  ('1a2b3c4d-5e6f-4a70-9b80-1c2d3e4f5a60','https://images.pexels.com/photos/4099355/pexels-photo-4099355.jpeg?auto=compress&cs=tinysrgb&w=500','Desinfectante Hospitalario 2',1),\\\\n  ('2b3c4d5e-6f70-4b81-8c90-2d3e4f5a6b70','https://images.pexels.com/photos/4239013/pexels-photo-4239013.jpeg?auto=compress&cs=tinysrgb&w=500','Desengrasante Cocinas 1',0),\\\\n  ('2b3c4d5e-6f70-4b81-8c90-2d3e4f5a6b70','https://images.pexels.com/photos/4062270/pexels-photo-4062270.jpeg?auto=compress&cs=tinysrgb&w=500','Desengrasante Cocinas 2',1),\\\\n  ('3c4d5e6f-7081-4c92-9da0-3e4f5a6b7c80','https://images.pexels.com/photos/6195276/pexels-photo-6195276.jpeg?auto=compress&cs=tinysrgb&w=500','Vidrios Pro 1',0),\\\\n  ('3c4d5e6f-7081-4c92-9da0-3e4f5a6b7c80','https://images.pexels.com/photos/4239091/pexels-photo-4239091.jpeg?auto=compress&cs=tinysrgb&w=500','Vidrios Pro 2',1),\\\\n  ('4d5e6f70-8192-4da3-8eb0-4f5a6b7c8d90','https://images.pexels.com/photos/4167735/pexels-photo-4167735.jpeg?auto=compress&cs=tinysrgb&w=500','Antiséptico 1',0),\\\\n  ('4d5e6f70-8192-4da3-8eb0-4f5a6b7c8d90','https://images.pexels.com/photos/4386467/pexels-photo-4386467.jpeg?auto=compress&cs=tinysrgb&w=500','Antiséptico 2',1),\\\\n  ('5e6f7081-92a3-4eb4-9fc0-5a6b7c8d9ea0','https://images.pexels.com/photos/4239122/pexels-photo-4239122.jpeg?auto=compress&cs=tinysrgb&w=500','Acero Inox 1',0),\\\\n  ('5e6f7081-92a3-4eb4-9fc0-5a6b7c8d9ea0','https://images.pexels.com/photos/4239075/pexels-photo-4239075.jpeg?auto=compress&cs=tinysrgb&w=500','Acero Inox 2',1)\\\\nON CONFLICT DO NOTHING","\\\\n\\\\n-- Overrides (1 por % y 1 por precio fijo)\\\\nINSERT INTO public.price_overrides (client_id, product_id, discount_pct) VALUES\\\\n  ('a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56','0f4d6b2e-8c79-4b1e-8a9d-6f3a2b1c5d10',10.00)\\\\nON CONFLICT (client_id, product_id) DO NOTHING","\\\\n\\\\nINSERT INTO public.price_overrides (client_id, product_id, custom_price) VALUES\\\\n  ('a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56','3c4d5e6f-7081-4c92-9da0-3e4f5a6b7c80',7.50)\\\\nON CONFLICT (client_id, product_id) DO NOTHING","\\\\n\\\\n-- ================================================================\\\\n-- 8) VALIDACIONES RÁPIDAS (no tocan auth.users)\\\\n-- ================================================================\\\\n\\\\n-- Test precios efectivos\\\\nDO $$\\\\nDECLARE\\\\n  discount_price numeric(12,2)","\\\\n  custom_price   numeric(12,2)","\\\\nBEGIN\\\\n  SELECT effective_price\\\\n    INTO discount_price\\\\n    FROM public.v_effective_prices\\\\n   WHERE product_id = '0f4d6b2e-8c79-4b1e-8a9d-6f3a2b1c5d10'\\\\n     AND client_id  = 'a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56'","\\\\n\\\\n  SELECT effective_price\\\\n    INTO custom_price\\\\n    FROM public.v_effective_prices\\\\n   WHERE product_id = '3c4d5e6f-7081-4c92-9da0-3e4f5a6b7c80'\\\\n     AND client_id  = 'a8b0c1d2-e3f4-4a56-8b79-0c1d2e3f4a56'","\\\\n\\\\n  IF discount_price IS DISTINCT FROM 11.25 THEN\\\\n    RAISE EXCEPTION 'Cálculo de descuento incorrecto. Esperado 11.25, obtenido %', discount_price","\\\\n  END IF","\\\\n\\\\n  IF custom_price IS DISTINCT FROM 7.50 THEN\\\\n    RAISE EXCEPTION 'Precio fijo incorrecto. Esperado 7.50, obtenido %', custom_price","\\\\n  END IF","\\\\n\\\\n  RAISE NOTICE '✅ v_effective_prices OK (%%: %, fijo: %)', discount_price, custom_price","\\\\nEND $$","\\\\n\\\\n-- Test bitácora (actor NULL evita FK a auth.users)\\\\nDO $$\\\\nDECLARE\\\\n  cnt int","\\\\nBEGIN\\\\n  PERFORM public.log_security_event(NULL,'test_action','test_entity','test_id','{\\"ok\\":true}')","\\\\n  SELECT COUNT(*) INTO cnt FROM public.audit_log WHERE action='test_action' AND entity='test_entity'","\\\\n  IF cnt = 0 THEN\\\\n    RAISE EXCEPTION 'log_security_event no insertó registro'","\\\\n  END IF","\\\\n  RAISE NOTICE '✅ log_security_event OK'","\\\\nEND $$","\\\\n"}	
20250902192120	{"-- =========================================================\\\\n-- PATCH RLS: elimina recursión en client_users y\\\\n-- separa políticas de clients para evitar 42P17\\\\n-- Seguro e idempotente\\\\n-- =========================================================\\\\nBEGIN","\\\\n\\\\n-- 1) client_users: eliminar políticas anteriores problemáticas\\\\nDROP POLICY IF EXISTS \\"cusers_read\\" ON public.client_users","\\\\nDROP POLICY IF EXISTS \\"cusers_manage_admin_master\\" ON public.client_users","\\\\n\\\\n-- 1.a) Lectura: solo admin o el propio usuario (sin auto-referencias)\\\\nCREATE POLICY \\"cusers_read_self_or_admin\\"\\\\n  ON public.client_users\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR user_id = auth.uid()\\\\n  )","\\\\n\\\\n-- 1.b) Gestión: de momento SOLO admin (evita auto-referencias en WITH CHECK)\\\\nCREATE POLICY \\"cusers_admin_manage_only\\"\\\\n  ON public.client_users\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- 2) clients: separar admin de miembros (evita evaluar EXISTS para admin)\\\\nDROP POLICY IF EXISTS \\"clients_admin_all\\" ON public.clients","\\\\nCREATE POLICY \\"clients_admin_all\\"\\\\n  ON public.clients\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\nDROP POLICY IF EXISTS \\"clients_read_scoped\\" ON public.clients","\\\\nCREATE POLICY \\"clients_read_if_has_membership\\"\\\\n  ON public.clients\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1\\\\n      FROM public.client_users cu\\\\n      WHERE cu.user_id = auth.uid()\\\\n        AND cu.client_id = clients.id\\\\n    )\\\\n  )","\\\\n\\\\nCOMMIT","\\\\n"}	heavy_canyon
20250903024135	{"\\\\n\\\\n-- ================================================================\\\\n-- SUPROSER — Patch mínimo para MASTER (Usuarios) + Registro sin rol\\\\n--   - NO crea tablas nuevas\\\\n--   - Añade RPCs SECURITY DEFINER y 1 policy para registro\\\\n--   - Idempotente\\\\n-- ================================================================\\\\n\\\\nCREATE EXTENSION IF NOT EXISTS \\"pgcrypto\\"","\\\\n\\\\n-- Se asume que ya existe public.get_user_role(uuid) según tu esquema.\\\\n\\\\n-- 1) Policy para permitir que un usuario recién autenticado inserte su propio perfil con rol_app NULL\\\\nDROP POLICY IF EXISTS profiles_insert_self_norole ON public.user_profiles","\\\\nCREATE POLICY profiles_insert_self_norole\\\\n  ON public.user_profiles\\\\n  FOR INSERT\\\\n  TO authenticated\\\\n  WITH CHECK (user_id = auth.uid() AND role_app IS NULL)","\\\\n\\\\n-- (Opcional útil) permitir a MASTER leer display_name de usuarios de su misma empresa.\\\\n-- No concede escritura"," sólo SELECT para mejorar el listado en el panel MASTER.\\\\nDROP POLICY IF EXISTS profiles_read_same_client_master ON public.user_profiles","\\\\nCREATE POLICY profiles_read_same_client_master\\\\n  ON public.user_profiles\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1\\\\n      FROM public.client_users cu_master\\\\n      JOIN public.client_users cu_target\\\\n        ON cu_target.user_id = public.user_profiles.user_id\\\\n      WHERE cu_master.user_id = auth.uid()\\\\n        AND cu_master.role_in_client = 'master'\\\\n        AND cu_target.client_id = cu_master.client_id\\\\n    )\\\\n  )","\\\\n\\\\n-- 2) RPC MASTER — Listar sólo usuarios de SU empresa (mismos parámetros que usa Admin)\\\\nCREATE OR REPLACE FUNCTION public.master_list_client_users(\\\\n  branch_filter uuid DEFAULT NULL,\\\\n  client_filter uuid DEFAULT NULL,  -- ignorado si no coincide"," el server fuerza el suyo\\\\n  page_num      int  DEFAULT 1,\\\\n  page_size     int  DEFAULT 25,\\\\n  role_filter   text DEFAULT NULL,  -- usar 'gerente_sucursal' para tu caso\\\\n  search        text DEFAULT NULL\\\\n)\\\\nRETURNS json\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nSET search_path = public, auth\\\\nAS $$\\\\nDECLARE\\\\n  v_client uuid","\\\\n  v_total  int","\\\\n  v_result json","\\\\nBEGIN\\\\n  -- Debe ser MASTER de alguna empresa\\\\n  SELECT cu.client_id\\\\n    INTO v_client\\\\n  FROM public.client_users cu\\\\n  WHERE cu.user_id = auth.uid() AND cu.role_in_client = 'master'\\\\n  LIMIT 1","\\\\n\\\\n  IF v_client IS NULL THEN\\\\n    RAISE EXCEPTION 'not_authorized'","\\\\n  END IF","\\\\n\\\\n  IF page_num   IS NULL OR page_num   < 1 THEN page_num   := 1","  END IF","\\\\n  IF page_size  IS NULL OR page_size  < 1 THEN page_size  := 25"," END IF","\\\\n  IF page_size > 200 THEN page_size := 200"," END IF","\\\\n\\\\n  -- Get total count first\\\\n  SELECT COUNT(*)\\\\n    INTO v_total\\\\n  FROM public.client_users cu\\\\n  JOIN public.clients c            ON c.id = cu.client_id\\\\n  LEFT JOIN public.client_branches b ON b.id = cu.branch_id\\\\n  LEFT JOIN public.user_profiles up  ON up.user_id = cu.user_id\\\\n  JOIN auth.users au               ON au.id = cu.user_id\\\\n  WHERE cu.client_id = v_client\\\\n    AND (branch_filter IS NULL OR cu.branch_id = branch_filter)\\\\n    AND (role_filter   IS NULL OR cu.role_in_client = role_filter)\\\\n    AND (\\\\n      search IS NULL\\\\n      OR au.email ILIKE '%'||search||'%'\\\\n      OR (up.display_name IS NOT NULL AND up.display_name ILIKE '%'||search||'%')\\\\n    )","\\\\n\\\\n  -- Get paginated results\\\\n  SELECT json_build_object(\\\\n    'users', json_agg(\\\\n      json_build_object(\\\\n        'id', cu.id,\\\\n        'user_id', cu.user_id,\\\\n        'email', au.email,\\\\n        'display_name', up.display_name,\\\\n        'role_in_client', cu.role_in_client,\\\\n        'client_id', c.id,\\\\n        'client_name', c.name,\\\\n        'branch_id', cu.branch_id,\\\\n        'branch_name', b.name,\\\\n        'created_at', cu.created_at\\\\n      )\\\\n    ),\\\\n    'total_count', v_total\\\\n  ) INTO v_result\\\\n  FROM public.client_users cu\\\\n  JOIN public.clients c            ON c.id = cu.client_id\\\\n  LEFT JOIN public.client_branches b ON b.id = cu.branch_id\\\\n  LEFT JOIN public.user_profiles up  ON up.user_id = cu.user_id\\\\n  JOIN auth.users au               ON au.id = cu.user_id\\\\n  WHERE cu.client_id = v_client\\\\n    AND (branch_filter IS NULL OR cu.branch_id = branch_filter)\\\\n    AND (role_filter   IS NULL OR cu.role_in_client = role_filter)\\\\n    AND (\\\\n      search IS NULL\\\\n      OR au.email ILIKE '%'||search||'%'\\\\n      OR (up.display_name IS NOT NULL AND up.display_name ILIKE '%'||search||'%')\\\\n    )\\\\n  ORDER BY cu.created_at DESC\\\\n  OFFSET (page_num - 1) * page_size\\\\n  LIMIT page_size","\\\\n\\\\n  RETURN v_result","\\\\nEND","\\\\n$$","\\\\n\\\\nGRANT EXECUTE ON FUNCTION public.master_list_client_users(uuid,uuid,int,int,text,text) TO authenticated","\\\\n\\\\n-- 3) RPC MASTER — Buscar usuario por email (para asignarlo)"," parámetro distinto: p_email\\\\nCREATE OR REPLACE FUNCTION public.master_get_user_by_email(p_email text)\\\\nRETURNS json\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nSET search_path = public, auth\\\\nAS $$\\\\nDECLARE\\\\n  v_client uuid","\\\\n  v_result json","\\\\nBEGIN\\\\n  SELECT cu.client_id\\\\n    INTO v_client\\\\n  FROM public.client_users cu\\\\n  WHERE cu.user_id = auth.uid() AND cu.role_in_client = 'master'\\\\n  LIMIT 1","\\\\n\\\\n  IF v_client IS NULL THEN\\\\n    RAISE EXCEPTION 'not_authorized'","\\\\n  END IF","\\\\n\\\\n  SELECT json_build_object(\\\\n    'user_id', u.id,\\\\n    'email', u.email,\\\\n    'display_name', up.display_name\\\\n  ) INTO v_result\\\\n  FROM auth.users u\\\\n  LEFT JOIN public.user_profiles up ON up.user_id = u.id\\\\n  WHERE lower(u.email) = lower(p_email)\\\\n  LIMIT 1","\\\\n\\\\n  RETURN v_result","\\\\nEND","\\\\n$$","\\\\n\\\\nGRANT EXECUTE ON FUNCTION public.master_get_user_by_email(text) TO authenticated","\\\\n\\\\n-- 4) RPC MASTER — Asignar GERENTE a una sucursal de su empresa\\\\nCREATE OR REPLACE FUNCTION public.master_assign_client_user(\\\\n  p_user_id   uuid,\\\\n  p_branch_id uuid\\\\n)\\\\nRETURNS json\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nSET search_path = public, auth\\\\nAS $$\\\\nDECLARE\\\\n  v_client uuid","\\\\n  v_id     uuid","\\\\n  v_result json","\\\\nBEGIN\\\\n  -- Verificar MASTER y obtener su client_id\\\\n  SELECT cu.client_id\\\\n    INTO v_client\\\\n  FROM public.client_users cu\\\\n  WHERE cu.user_id = auth.uid() AND cu.role_in_client = 'master'\\\\n  LIMIT 1","\\\\n\\\\n  IF v_client IS NULL THEN\\\\n    RAISE EXCEPTION 'not_authorized'","\\\\n  END IF","\\\\n\\\\n  -- Validar que la sucursal pertenece a su empresa\\\\n  IF NOT EXISTS (\\\\n    SELECT 1 FROM public.client_branches b\\\\n    WHERE b.id = p_branch_id AND b.client_id = v_client\\\\n  ) THEN\\\\n    RAISE EXCEPTION 'branch_not_in_client'","\\\\n  END IF","\\\\n\\\\n  -- Verificar que el usuario existe\\\\n  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE id = p_user_id) THEN\\\\n    RAISE EXCEPTION 'user_not_found'","\\\\n  END IF","\\\\n\\\\n  -- Asegurar user_profiles (rol NULL) si no existe\\\\n  INSERT INTO public.user_profiles (user_id, role_app)\\\\n  VALUES (p_user_id, 'cliente_gerente_sucursal')\\\\n  ON CONFLICT (user_id) DO UPDATE SET role_app = 'cliente_gerente_sucursal'","\\\\n\\\\n  -- Verificar si ya está asignado a otra sucursal en la misma empresa\\\\n  IF EXISTS (\\\\n    SELECT 1 FROM public.client_users cu\\\\n    WHERE cu.user_id = p_user_id\\\\n      AND cu.client_id = v_client\\\\n      AND cu.role_in_client = 'gerente_sucursal'\\\\n      AND cu.branch_id != p_branch_id\\\\n  ) THEN\\\\n    -- Update existing assignment to new branch\\\\n    UPDATE public.client_users\\\\n    SET branch_id = p_branch_id\\\\n    WHERE user_id = p_user_id \\\\n      AND client_id = v_client \\\\n      AND role_in_client = 'gerente_sucursal'\\\\n    RETURNING id INTO v_id","\\\\n  ELSE\\\\n    -- Insert or update (same branch)\\\\n    INSERT INTO public.client_users (id, user_id, client_id, branch_id, role_in_client, created_at)\\\\n    VALUES (gen_random_uuid(), p_user_id, v_client, p_branch_id, 'gerente_sucursal', now())\\\\n    ON CONFLICT (user_id, client_id) WHERE role_in_client = 'gerente_sucursal'\\\\n    DO UPDATE SET branch_id = EXCLUDED.branch_id\\\\n    RETURNING id INTO v_id","\\\\n  END IF","\\\\n\\\\n  SELECT json_build_object(\\\\n    'id', cu.id,\\\\n    'user_id', cu.user_id,\\\\n    'client_id', cu.client_id,\\\\n    'branch_id', cu.branch_id,\\\\n    'role_in_client', cu.role_in_client,\\\\n    'created_at', cu.created_at\\\\n  ) INTO v_result\\\\n  FROM public.client_users cu\\\\n  WHERE cu.id = v_id","\\\\n\\\\n  RETURN v_result","\\\\nEND","\\\\n$$","\\\\n\\\\nGRANT EXECUTE ON FUNCTION public.master_assign_client_user(uuid,uuid) TO authenticated","\\\\n\\\\n-- 5) Refrescar schema cache de PostgREST\\\\nDO $$\\\\nBEGIN\\\\n  PERFORM pg_notify('pgrst', 'reload schema')","\\\\nEXCEPTION WHEN OTHERS THEN\\\\n  NULL","\\\\nEND $$",""}	cold_voice
20250903024855	{"-- ================================================================\\\\n-- FIX RLS RECURSIVA EN user_profiles (evitar 54001)\\\\n-- Idempotente. No cambia tablas ni columnas.\\\\n-- ================================================================\\\\n\\\\n-- 1) Mantener políticas seguras que NO llaman get_user_role()\\\\nDROP POLICY IF EXISTS profiles_read_own   ON public.user_profiles","\\\\nCREATE POLICY profiles_read_own\\\\n  ON public.user_profiles\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (user_id = auth.uid())","\\\\n\\\\nDROP POLICY IF EXISTS profiles_update_own ON public.user_profiles","\\\\nCREATE POLICY profiles_update_own\\\\n  ON public.user_profiles\\\\n  FOR UPDATE\\\\n  TO authenticated\\\\n  USING (user_id = auth.uid())","\\\\n\\\\n-- 2) Permitir crear el propio perfil con rol_app NULL tras registro\\\\nDROP POLICY IF EXISTS profiles_insert_self_norole ON public.user_profiles","\\\\nCREATE POLICY profiles_insert_self_norole\\\\n  ON public.user_profiles\\\\n  FOR INSERT\\\\n  TO authenticated\\\\n  WITH CHECK (user_id = auth.uid() AND role_app IS NULL)","\\\\n\\\\n-- 3) **Eliminar** cualquier policy que invoque get_user_role() desde user_profiles\\\\n--    (causa recursión porque get_user_role lee user_profiles)\\\\nDROP POLICY IF EXISTS profiles_admin_all              ON public.user_profiles","\\\\nDROP POLICY IF EXISTS profiles_read_same_client_master ON public.user_profiles","\\\\n\\\\n-- 4) Recargar schema cache de PostgREST\\\\nDO $$\\\\nBEGIN\\\\n  PERFORM pg_notify('pgrst', 'reload schema')","\\\\nEXCEPTION WHEN OTHERS THEN\\\\n  NULL","\\\\nEND $$",""}	weathered_gate
20250903025223	{"\\\\n\\\\n-- Fix the master_list_client_users RPC to return proper structure\\\\nCREATE OR REPLACE FUNCTION public.master_list_client_users(\\\\n  branch_filter uuid DEFAULT NULL,\\\\n  client_filter uuid DEFAULT NULL,  \\\\n  page_num      int  DEFAULT 1,\\\\n  page_size     int  DEFAULT 25,\\\\n  role_filter   text DEFAULT NULL,  \\\\n  search        text DEFAULT NULL\\\\n)\\\\nRETURNS json\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nSET search_path = public, auth\\\\nAS $$\\\\nDECLARE\\\\n  v_client uuid","\\\\n  v_users json","\\\\n  v_total_count int","\\\\nBEGIN\\\\n  -- Must be MASTER of some company\\\\n  SELECT cu.client_id\\\\n    INTO v_client\\\\n  FROM public.client_users cu\\\\n  WHERE cu.user_id = auth.uid() AND cu.role_in_client = 'master'\\\\n  LIMIT 1","\\\\n\\\\n  IF v_client IS NULL THEN\\\\n    RAISE EXCEPTION 'not_authorized'","\\\\n  END IF","\\\\n\\\\n  -- Validate pagination params\\\\n  IF page_num   IS NULL OR page_num   < 1 THEN page_num   := 1","  END IF","\\\\n  IF page_size  IS NULL OR page_size  < 1 THEN page_size  := 25"," END IF","\\\\n  IF page_size > 200 THEN page_size := 200"," END IF","\\\\n\\\\n  -- First get the total count (without pagination)\\\\n  SELECT COUNT(*)\\\\n    INTO v_total_count\\\\n  FROM public.client_users cu\\\\n  JOIN public.clients c            ON c.id = cu.client_id\\\\n  LEFT JOIN public.client_branches b ON b.id = cu.branch_id\\\\n  LEFT JOIN public.user_profiles up  ON up.user_id = cu.user_id\\\\n  JOIN auth.users au               ON au.id = cu.user_id\\\\n  WHERE cu.client_id = v_client\\\\n    AND (branch_filter IS NULL OR cu.branch_id = branch_filter)\\\\n    AND (role_filter   IS NULL OR cu.role_in_client = role_filter)\\\\n    AND (\\\\n      search IS NULL\\\\n      OR au.email ILIKE '%'||search||'%'\\\\n      OR (up.display_name IS NOT NULL AND up.display_name ILIKE '%'||search||'%')\\\\n    )","\\\\n\\\\n  -- Then get the paginated results as JSON\\\\n  SELECT json_agg(\\\\n    json_build_object(\\\\n      'id', cu.id,\\\\n      'user_id', cu.user_id,\\\\n      'email', au.email,\\\\n      'display_name', up.display_name,\\\\n      'role_in_client', cu.role_in_client,\\\\n      'branch_id', cu.branch_id,\\\\n      'branch_name', b.name,\\\\n      'created_at', cu.created_at\\\\n    )\\\\n  )\\\\n    INTO v_users\\\\n  FROM public.client_users cu\\\\n  JOIN public.clients c            ON c.id = cu.client_id\\\\n  LEFT JOIN public.client_branches b ON b.id = cu.branch_id\\\\n  LEFT JOIN public.user_profiles up  ON up.user_id = cu.user_id\\\\n  JOIN auth.users au               ON au.id = cu.user_id\\\\n  WHERE cu.client_id = v_client\\\\n    AND (branch_filter IS NULL OR cu.branch_id = branch_filter)\\\\n    AND (role_filter   IS NULL OR cu.role_in_client = role_filter)\\\\n    AND (\\\\n      search IS NULL\\\\n      OR au.email ILIKE '%'||search||'%'\\\\n      OR (up.display_name IS NOT NULL AND up.display_name ILIKE '%'||search||'%')\\\\n    )\\\\n  ORDER BY cu.created_at DESC\\\\n  OFFSET (page_num - 1) * page_size\\\\n  LIMIT page_size","\\\\n\\\\n  -- Return combined result\\\\n  RETURN json_build_object(\\\\n    'users', COALESCE(v_users, '[]'::json),\\\\n    'total_count', v_total_count\\\\n  )","\\\\nEND","\\\\n$$","\\\\n\\\\n-- Refresh PostgREST schema cache\\\\nDO $$\\\\nBEGIN\\\\n  PERFORM pg_notify('pgrst', 'reload schema')","\\\\nEXCEPTION WHEN OTHERS THEN\\\\n  NULL","\\\\nEND $$",""}	falling_heart
20250903030617	{"\\\\n\\\\n-- RPC for Admin to search users safely\\\\nCREATE OR REPLACE FUNCTION public.admin_search_users(\\\\n  search_query text\\\\n)\\\\nRETURNS TABLE (\\\\n  user_id uuid,\\\\n  email text,\\\\n  display_name text,\\\\n  role_app text,\\\\n  created_at timestamptz\\\\n)\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nSET search_path = public, auth\\\\nAS $$\\\\nBEGIN\\\\n  -- Only admin can search users\\\\n  IF public.get_user_role(auth.uid()) != 'admin' THEN\\\\n    RAISE EXCEPTION 'not_authorized'","\\\\n  END IF","\\\\n\\\\n  -- Clean and validate search query\\\\n  IF search_query IS NULL OR trim(search_query) = '' OR length(trim(search_query)) < 2 THEN\\\\n    RETURN","\\\\n  END IF","\\\\n\\\\n  RETURN QUERY\\\\n  SELECT\\\\n    u.id,\\\\n    u.email,\\\\n    COALESCE(p.display_name, split_part(u.email, '@', 1)) as display_name,\\\\n    p.role_app,\\\\n    u.created_at\\\\n  FROM auth.users u\\\\n  LEFT JOIN public.user_profiles p ON p.user_id = u.id\\\\n  WHERE \\\\n    -- Search by email (case insensitive)\\\\n    lower(u.email) LIKE lower('%' || trim(search_query) || '%')\\\\n    OR \\\\n    -- Search by display_name if exists\\\\n    (p.display_name IS NOT NULL AND lower(p.display_name) LIKE lower('%' || trim(search_query) || '%'))\\\\n    OR\\\\n    -- Search by user_id (exact match or partial)\\\\n    (\\\\n      trim(search_query) ~ '^[0-9a-f-]+$' AND (\\\\n        u.id::text = trim(search_query)\\\\n        OR u.id::text LIKE trim(search_query) || '%'\\\\n      )\\\\n    )\\\\n  ORDER BY \\\\n    CASE \\\\n      WHEN lower(u.email) = lower(trim(search_query)) THEN 1\\\\n      WHEN u.id::text = trim(search_query) THEN 2\\\\n      WHEN lower(u.email) LIKE lower(trim(search_query) || '%') THEN 3\\\\n      ELSE 4\\\\n    END,\\\\n    p.display_name NULLS LAST,\\\\n    u.email\\\\n  LIMIT 50","\\\\nEND","\\\\n$$","\\\\n\\\\nGRANT EXECUTE ON FUNCTION public.admin_search_users(text) TO authenticated",""}	winter_prism
20250903030913	{"-- ================================================================\\\\n-- FIX admin_search_users TYPE MISMATCH\\\\n-- Corrige: varchar(255) vs text mismatch\\\\n-- Idempotente. Solo corrige tipos de la función.\\\\n-- ================================================================\\\\n\\\\n-- Recrear la función con tipos exactos que coincidan con la DB\\\\nDROP FUNCTION IF EXISTS public.admin_search_users(text)","\\\\n\\\\nCREATE OR REPLACE FUNCTION public.admin_search_users(search_query text)\\\\nRETURNS TABLE (\\\\n  user_id      uuid,\\\\n  email        varchar,  -- FIXED: auth.users.email es varchar(255), no text\\\\n  display_name text,     -- user_profiles.display_name es text\\\\n  role_app     text,     -- user_profiles.role_app es text\\\\n  created_at   timestamptz\\\\n)\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nSET search_path = public, auth\\\\nAS $$\\\\nBEGIN\\\\n  -- Solo Admin puede usar esta función\\\\n  IF public.get_user_role(auth.uid()) != 'admin' THEN\\\\n    RAISE EXCEPTION 'access_denied'","\\\\n  END IF","\\\\n\\\\n  -- Validar entrada\\\\n  IF search_query IS NULL OR trim(search_query) = '' THEN\\\\n    RETURN","\\\\n  END IF","\\\\n\\\\n  RETURN QUERY\\\\n  SELECT \\\\n    au.id,\\\\n    au.email,  -- varchar(255) from auth.users\\\\n    COALESCE(up.display_name, split_part(au.email, '@', 1)) as display_name,\\\\n    up.role_app,\\\\n    COALESCE(up.created_at, au.created_at) as created_at\\\\n  FROM auth.users au\\\\n  LEFT JOIN public.user_profiles up ON up.user_id = au.id\\\\n  WHERE \\\\n    -- Búsqueda por email (parcial, case insensitive)\\\\n    au.email ILIKE '%' || trim(search_query) || '%'\\\\n    \\\\n    -- O por display_name si existe\\\\n    OR (up.display_name IS NOT NULL AND up.display_name ILIKE '%' || trim(search_query) || '%')\\\\n    \\\\n    -- O por user_id (exacto o prefijo)\\\\n    OR au.id::text LIKE trim(search_query) || '%'\\\\n    OR au.id::text = trim(search_query)\\\\n  ORDER BY \\\\n    -- Prioridad: coincidencia exacta email > display_name > prefijo\\\\n    CASE \\\\n      WHEN lower(au.email) = lower(trim(search_query)) THEN 1\\\\n      WHEN au.id::text = trim(search_query) THEN 2  \\\\n      WHEN au.email ILIKE trim(search_query) || '%' THEN 3\\\\n      WHEN up.display_name ILIKE trim(search_query) || '%' THEN 4\\\\n      ELSE 5\\\\n    END,\\\\n    au.created_at DESC\\\\n  LIMIT 50","  -- Límite razonable para evitar sobrecarga\\\\nEND","\\\\n$$","\\\\n\\\\nGRANT EXECUTE ON FUNCTION public.admin_search_users(text) TO authenticated","\\\\n\\\\n-- Recargar schema cache\\\\nDO $$\\\\nBEGIN\\\\n  PERFORM pg_notify('pgrst', 'reload schema')","\\\\nEXCEPTION WHEN OTHERS THEN\\\\n  NULL","\\\\nEND $$",""}	purple_butterfly
20250903031127	{"\\\\n\\\\n-- Add admin policy for user_profiles management\\\\nDROP POLICY IF EXISTS profiles_admin_manage ON public.user_profiles","\\\\nCREATE POLICY profiles_admin_manage\\\\n  ON public.user_profiles\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    -- Check if current user is admin using direct role_app check\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles up \\\\n      WHERE up.user_id = auth.uid() \\\\n      AND up.role_app = 'admin'\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    -- Same check for INSERT/UPDATE\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles up \\\\n      WHERE up.user_id = auth.uid() \\\\n      AND up.role_app = 'admin'\\\\n    )\\\\n  )",""}	patient_field
20250903032344	{"\\\\n\\\\n-- ================================================================\\\\n-- SUPROSER — RESET COMPLETO DE POLÍTICAS (con fix anti-recursión)\\\\n-- Ejecutar tal cual. No borra datos. Idempotente.\\\\n-- ================================================================\\\\n\\\\nBEGIN","\\\\n\\\\n-- Asegurar extensión usada en seeds/funciones\\\\nCREATE EXTENSION IF NOT EXISTS \\"pgcrypto\\"","\\\\n\\\\n-- ----------------------------------------------------------------\\\\n-- Función helper (igual a tu versión \\"buena\\")\\\\n-- ----------------------------------------------------------------\\\\nCREATE OR REPLACE FUNCTION public.get_user_role(user_uuid uuid)\\\\nRETURNS text\\\\nLANGUAGE sql\\\\nSTABLE\\\\nAS $$\\\\n  SELECT role_app FROM public.user_profiles WHERE user_id = user_uuid\\\\n$$","\\\\n\\\\n-- ----------------------------------------------------------------\\\\n-- Habilitar RLS en todas las tablas que usamos\\\\n-- ----------------------------------------------------------------\\\\nALTER TABLE public.user_profiles        ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.clients              ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.client_branches      ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.client_users         ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.categories           ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.products             ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.product_images       ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.price_overrides      ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.orders               ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.order_items          ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.order_status_history ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.payments             ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.webhook_events       ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.audit_log            ENABLE ROW LEVEL SECURITY","\\\\n\\\\n-- ================================================================\\\\n-- POLÍTICAS (RESET)\\\\n-- ================================================================\\\\n\\\\n-- -----------------------\\\\n-- user_profiles  (FIX)\\\\n-- -----------------------\\\\nDROP POLICY IF EXISTS profiles_read_own                 ON public.user_profiles","\\\\nDROP POLICY IF EXISTS profiles_update_own               ON public.user_profiles","\\\\nDROP POLICY IF EXISTS profiles_insert_self_norole       ON public.user_profiles","\\\\nDROP POLICY IF EXISTS profiles_admin_all                ON public.user_profiles","           -- <- QUITADA (evita recursión)\\\\nDROP POLICY IF EXISTS profiles_read_same_client_master  ON public.user_profiles","\\\\n\\\\n-- Solo leer el propio perfil\\\\nCREATE POLICY profiles_read_own\\\\n  ON public.user_profiles\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (user_id = auth.uid())","\\\\n\\\\n-- Solo actualizar el propio perfil\\\\nCREATE POLICY profiles_update_own\\\\n  ON public.user_profiles\\\\n  FOR UPDATE\\\\n  TO authenticated\\\\n  USING (user_id = auth.uid())","\\\\n\\\\n-- Opcional: permitir que el usuario cree su fila sin rol al registrarse\\\\nCREATE POLICY profiles_insert_self_norole\\\\n  ON public.user_profiles\\\\n  FOR INSERT\\\\n  TO authenticated\\\\n  WITH CHECK (user_id = auth.uid() AND role_app IS NULL)","\\\\n\\\\n-- (Nota: No recreamos una \\"admin_all\\" aquí. Si la UI necesita ver\\\\n-- nombres de otros usuarios, que lo haga vía RPC/VIEW SECURITY DEFINER,\\\\n-- así evitamos recursión. El resto del sistema sigue igual.)\\\\n\\\\n-- -----------------------\\\\n-- categories\\\\n-- -----------------------\\\\nDROP POLICY IF EXISTS categories_public_read ON public.categories","\\\\nDROP POLICY IF EXISTS categories_admin_all   ON public.categories","\\\\n\\\\nCREATE POLICY categories_public_read\\\\n  ON public.categories\\\\n  FOR SELECT\\\\n  TO anon, authenticated\\\\n  USING (true)","\\\\n\\\\nCREATE POLICY categories_admin_all\\\\n  ON public.categories\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- -----------------------\\\\n-- products\\\\n-- -----------------------\\\\nDROP POLICY IF EXISTS products_public_read ON public.products","\\\\nDROP POLICY IF EXISTS products_admin_all   ON public.products","\\\\n\\\\nCREATE POLICY products_public_read\\\\n  ON public.products\\\\n  FOR SELECT\\\\n  TO anon, authenticated\\\\n  USING (active = true)","\\\\n\\\\nCREATE POLICY products_admin_all\\\\n  ON public.products\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- -----------------------\\\\n-- product_images\\\\n-- -----------------------\\\\nDROP POLICY IF EXISTS pimgs_public_read ON public.product_images","\\\\nDROP POLICY IF EXISTS pimgs_admin_all   ON public.product_images","\\\\n\\\\nCREATE POLICY pimgs_public_read\\\\n  ON public.product_images\\\\n  FOR SELECT\\\\n  TO anon, authenticated\\\\n  USING (EXISTS (\\\\n           SELECT 1 FROM public.products p\\\\n           WHERE p.id = product_id AND p.active = true\\\\n         ))","\\\\n\\\\nCREATE POLICY pimgs_admin_all\\\\n  ON public.product_images\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- -----------------------\\\\n-- clients\\\\n-- -----------------------\\\\nDROP POLICY IF EXISTS clients_read_scoped ON public.clients","\\\\nDROP POLICY IF EXISTS clients_admin_all   ON public.clients","\\\\n\\\\nCREATE POLICY clients_read_scoped\\\\n  ON public.clients\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu\\\\n      WHERE cu.user_id = auth.uid()\\\\n        AND cu.client_id = public.clients.id\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY clients_admin_all\\\\n  ON public.clients\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- -----------------------\\\\n-- client_branches\\\\n-- -----------------------\\\\nDROP POLICY IF EXISTS branches_read_scoped          ON public.client_branches","\\\\nDROP POLICY IF EXISTS branches_manage_admin_master  ON public.client_branches","\\\\n\\\\nCREATE POLICY branches_read_scoped\\\\n  ON public.client_branches\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu\\\\n      WHERE cu.user_id = auth.uid()\\\\n        AND cu.client_id = public.client_branches.client_id\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY branches_manage_admin_master\\\\n  ON public.client_branches\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu\\\\n      WHERE cu.user_id = auth.uid()\\\\n        AND cu.client_id = public.client_branches.client_id\\\\n        AND cu.role_in_client = 'master'\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu\\\\n      WHERE cu.user_id = auth.uid()\\\\n        AND cu.client_id = public.client_branches.client_id\\\\n        AND cu.role_in_client = 'master'\\\\n    )\\\\n  )","\\\\n\\\\n-- -----------------------\\\\n-- client_users\\\\n-- -----------------------\\\\nDROP POLICY IF EXISTS cusers_read                  ON public.client_users","\\\\nDROP POLICY IF EXISTS cusers_manage_admin_master   ON public.client_users","\\\\n\\\\nCREATE POLICY cusers_read\\\\n  ON public.client_users\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR user_id = auth.uid()\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu2\\\\n      WHERE cu2.user_id = auth.uid()\\\\n        AND cu2.client_id = public.client_users.client_id\\\\n        AND cu2.role_in_client = 'master'\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY cusers_manage_admin_master\\\\n  ON public.client_users\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu2\\\\n      WHERE cu2.user_id = auth.uid()\\\\n        AND cu2.client_id = public.client_users.client_id\\\\n        AND cu2.role_in_client = 'master'\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu2\\\\n      WHERE cu2.user_id = auth.uid()\\\\n        AND cu2.client_id = public.client_users.client_id\\\\n        AND cu2.role_in_client = 'master'\\\\n    )\\\\n  )","\\\\n\\\\n-- -----------------------\\\\n-- price_overrides\\\\n-- -----------------------\\\\nDROP POLICY IF EXISTS poverrides_read_scoped ON public.price_overrides","\\\\nDROP POLICY IF EXISTS poverrides_admin_all   ON public.price_overrides","\\\\n\\\\nCREATE POLICY poverrides_read_scoped\\\\n  ON public.price_overrides\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu\\\\n      WHERE cu.user_id = auth.uid()\\\\n        AND cu.client_id = public.price_overrides.client_id\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY poverrides_admin_all\\\\n  ON public.price_overrides\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- -----------------------\\\\n-- orders\\\\n-- -----------------------\\\\nDROP POLICY IF EXISTS orders_read_scoped   ON public.orders","\\\\nDROP POLICY IF EXISTS orders_insert_scoped ON public.orders","\\\\nDROP POLICY IF EXISTS orders_update_scoped ON public.orders","\\\\n\\\\nCREATE POLICY orders_read_scoped\\\\n  ON public.orders\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu\\\\n      WHERE cu.user_id = auth.uid()\\\\n        AND cu.client_id = public.orders.client_id\\\\n        AND (\\\\n          cu.role_in_client = 'master'\\\\n          OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = public.orders.branch_id)\\\\n        )\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY orders_insert_scoped\\\\n  ON public.orders\\\\n  FOR INSERT\\\\n  TO authenticated\\\\n  WITH CHECK (\\\\n    EXISTS (\\\\n      SELECT 1 FROM public.client_users cu\\\\n      WHERE cu.user_id = auth.uid()\\\\n        AND cu.client_id = public.orders.client_id\\\\n        AND (\\\\n          cu.role_in_client = 'master'\\\\n          OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = public.orders.branch_id)\\\\n        )\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY orders_update_scoped\\\\n  ON public.orders\\\\n  FOR UPDATE\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu\\\\n      WHERE cu.user_id = auth.uid()\\\\n        AND cu.client_id = public.orders.client_id\\\\n        AND (\\\\n          cu.role_in_client = 'master'\\\\n          OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = public.orders.branch_id)\\\\n        )\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu\\\\n      WHERE cu.user_id = auth.uid()\\\\n        AND cu.client_id = public.orders.client_id\\\\n        AND (\\\\n          cu.role_in_client = 'master'\\\\n          OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = public.orders.branch_id)\\\\n        )\\\\n    )\\\\n  )","\\\\n\\\\n-- -----------------------\\\\n-- order_items\\\\n-- -----------------------\\\\nDROP POLICY IF EXISTS oitems_read_scoped   ON public.order_items","\\\\nDROP POLICY IF EXISTS oitems_manage_scoped ON public.order_items","\\\\n\\\\nCREATE POLICY oitems_read_scoped\\\\n  ON public.order_items\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1\\\\n      FROM public.orders o\\\\n      JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n      WHERE o.id = public.order_items.order_id\\\\n        AND cu.user_id = auth.uid()\\\\n        AND (\\\\n          cu.role_in_client = 'master'\\\\n          OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = o.branch_id)\\\\n        )\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY oitems_manage_scoped\\\\n  ON public.order_items\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1\\\\n      FROM public.orders o\\\\n      JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n      WHERE o.id = public.order_items.order_id\\\\n        AND cu.user_id = auth.uid()\\\\n        AND (\\\\n          cu.role_in_client = 'master'\\\\n          OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = o.branch_id)\\\\n        )\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1\\\\n      FROM public.orders o\\\\n      JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n      WHERE o.id = public.order_items.order_id\\\\n        AND cu.user_id = auth.uid()\\\\n        AND (\\\\n          cu.role_in_client = 'master'\\\\n          OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = o.branch_id)\\\\n        )\\\\n    )\\\\n  )","\\\\n\\\\n-- -----------------------\\\\n-- order_status_history\\\\n-- -----------------------\\\\nDROP POLICY IF EXISTS ostatus_read_scoped     ON public.order_status_history","\\\\nDROP POLICY IF EXISTS ostatus_insert_by_trigger ON public.order_status_history","\\\\n\\\\nCREATE POLICY ostatus_read_scoped\\\\n  ON public.order_status_history\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1\\\\n      FROM public.orders o\\\\n      JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n      WHERE o.id = public.order_status_history.order_id\\\\n        AND cu.user_id = auth.uid()\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY ostatus_insert_by_trigger\\\\n  ON public.order_status_history\\\\n  FOR INSERT\\\\n  TO authenticated\\\\n  WITH CHECK (true)","\\\\n\\\\n-- -----------------------\\\\n-- payments\\\\n-- -----------------------\\\\nDROP POLICY IF EXISTS payments_read_scoped ON public.payments","\\\\nDROP POLICY IF EXISTS payments_admin_all   ON public.payments","\\\\n\\\\nCREATE POLICY payments_read_scoped\\\\n  ON public.payments\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR EXISTS (\\\\n      SELECT 1\\\\n      FROM public.orders o\\\\n      JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n      WHERE o.id = public.payments.order_id\\\\n        AND cu.user_id = auth.uid()\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY payments_admin_all\\\\n  ON public.payments\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- -----------------------\\\\n-- webhook_events\\\\n-- -----------------------\\\\nDROP POLICY IF EXISTS webhooks_admin_all ON public.webhook_events","\\\\n\\\\nCREATE POLICY webhooks_admin_all\\\\n  ON public.webhook_events\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')\\\\n  WITH CHECK (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\n-- -----------------------\\\\n-- audit_log\\\\n-- -----------------------\\\\nDROP POLICY IF EXISTS audit_admin_read ON public.audit_log","\\\\nDROP POLICY IF EXISTS audit_insert     ON public.audit_log","\\\\n\\\\nCREATE POLICY audit_admin_read\\\\n  ON public.audit_log\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (public.get_user_role(auth.uid()) = 'admin')","\\\\n\\\\nCREATE POLICY audit_insert\\\\n  ON public.audit_log\\\\n  FOR INSERT\\\\n  TO authenticated\\\\n  WITH CHECK (true)","\\\\n\\\\n-- ---------------------------------------------------------------\\\\n-- Recargar el schema cache de PostgREST (si aplica)\\\\n-- ---------------------------------------------------------------\\\\nDO $$\\\\nBEGIN\\\\n  PERFORM pg_notify('pgrst', 'reload schema')","\\\\nEXCEPTION WHEN OTHERS THEN\\\\n  NULL","\\\\nEND $$","\\\\n\\\\nCOMMIT",""}	amber_palace
20250903032559	{"\\\\n\\\\nBEGIN","\\\\n\\\\n-- ================================================================\\\\n-- DISABLE ALL RLS TEMPORARILY TO BREAK RECURSION\\\\n-- ================================================================\\\\nALTER TABLE public.user_profiles        DISABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.clients              DISABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.client_branches      DISABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.client_users         DISABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.categories           DISABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.products             DISABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.product_images       DISABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.price_overrides      DISABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.orders               DISABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.order_items          DISABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.order_status_history DISABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.payments             DISABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.webhook_events       DISABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.audit_log            DISABLE ROW LEVEL SECURITY","\\\\n\\\\n-- ================================================================\\\\n-- DROP ALL EXISTING POLICIES (CLEAN SLATE)\\\\n-- ================================================================\\\\n\\\\n-- user_profiles policies\\\\nDROP POLICY IF EXISTS profiles_read_own                 ON public.user_profiles","\\\\nDROP POLICY IF EXISTS profiles_update_own               ON public.user_profiles","\\\\nDROP POLICY IF EXISTS profiles_insert_self_norole       ON public.user_profiles","\\\\nDROP POLICY IF EXISTS profiles_admin_all                ON public.user_profiles","\\\\nDROP POLICY IF EXISTS profiles_admin_manage             ON public.user_profiles","\\\\n\\\\n-- All other table policies\\\\nDROP POLICY IF EXISTS categories_public_read ON public.categories","\\\\nDROP POLICY IF EXISTS categories_admin_all   ON public.categories","\\\\nDROP POLICY IF EXISTS products_public_read   ON public.products","\\\\nDROP POLICY IF EXISTS products_admin_all     ON public.products","\\\\nDROP POLICY IF EXISTS pimgs_public_read      ON public.product_images","\\\\nDROP POLICY IF EXISTS pimgs_admin_all        ON public.product_images","\\\\nDROP POLICY IF EXISTS clients_read_scoped    ON public.clients","\\\\nDROP POLICY IF EXISTS clients_admin_all      ON public.clients","\\\\nDROP POLICY IF EXISTS branches_read_scoped   ON public.client_branches","\\\\nDROP POLICY IF EXISTS branches_manage_admin_master ON public.client_branches","\\\\nDROP POLICY IF EXISTS cusers_read            ON public.client_users","\\\\nDROP POLICY IF EXISTS cusers_manage_admin_master ON public.client_users","\\\\nDROP POLICY IF EXISTS poverrides_read_scoped ON public.price_overrides","\\\\nDROP POLICY IF EXISTS poverrides_admin_all   ON public.price_overrides","\\\\nDROP POLICY IF EXISTS orders_read_scoped     ON public.orders","\\\\nDROP POLICY IF EXISTS orders_insert_scoped   ON public.orders","\\\\nDROP POLICY IF EXISTS orders_update_scoped   ON public.orders","\\\\nDROP POLICY IF EXISTS oitems_read_scoped     ON public.order_items","\\\\nDROP POLICY IF EXISTS oitems_manage_scoped   ON public.order_items","\\\\nDROP POLICY IF EXISTS ostatus_read_scoped    ON public.order_status_history","\\\\nDROP POLICY IF EXISTS ostatus_insert_by_trigger ON public.order_status_history","\\\\nDROP POLICY IF EXISTS payments_read_scoped   ON public.payments","\\\\nDROP POLICY IF EXISTS payments_admin_all     ON public.payments","\\\\nDROP POLICY IF EXISTS webhooks_admin_all     ON public.webhook_events","\\\\nDROP POLICY IF EXISTS audit_admin_read       ON public.audit_log","\\\\nDROP POLICY IF EXISTS audit_insert           ON public.audit_log","\\\\n\\\\n-- ================================================================\\\\n-- CREATE SIMPLE NON-RECURSIVE POLICIES\\\\n-- ================================================================\\\\n\\\\n-- RE-ENABLE RLS\\\\nALTER TABLE public.user_profiles        ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.clients              ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.client_branches      ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.client_users         ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.categories           ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.products             ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.product_images       ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.price_overrides      ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.orders               ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.order_items          ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.order_status_history ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.payments             ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.webhook_events       ENABLE ROW LEVEL SECURITY","\\\\nALTER TABLE public.audit_log            ENABLE ROW LEVEL SECURITY","\\\\n\\\\n-- ================================================================\\\\n-- user_profiles - SELF ACCESS ONLY (NO ADMIN POLICIES)\\\\n-- ================================================================\\\\n\\\\nCREATE POLICY profiles_read_own\\\\n  ON public.user_profiles\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (user_id = auth.uid())","\\\\n\\\\nCREATE POLICY profiles_update_own\\\\n  ON public.user_profiles\\\\n  FOR UPDATE\\\\n  TO authenticated\\\\n  USING (user_id = auth.uid())","\\\\n\\\\nCREATE POLICY profiles_insert_self_norole\\\\n  ON public.user_profiles\\\\n  FOR INSERT\\\\n  TO authenticated\\\\n  WITH CHECK (user_id = auth.uid() AND role_app IS NULL)","\\\\n\\\\n-- ================================================================\\\\n-- PUBLIC TABLES (categories, products, product_images)\\\\n-- ================================================================\\\\n\\\\nCREATE POLICY categories_public_read\\\\n  ON public.categories\\\\n  FOR SELECT\\\\n  TO anon, authenticated\\\\n  USING (true)","\\\\n\\\\nCREATE POLICY products_public_read\\\\n  ON public.products\\\\n  FOR SELECT\\\\n  TO anon, authenticated\\\\n  USING (active = true)","\\\\n\\\\nCREATE POLICY pimgs_public_read\\\\n  ON public.product_images\\\\n  FOR SELECT\\\\n  TO anon, authenticated\\\\n  USING (EXISTS (\\\\n           SELECT 1 FROM public.products p\\\\n           WHERE p.id = product_id AND p.active = true\\\\n         ))","\\\\n\\\\n-- ================================================================\\\\n-- CLIENT-SCOPED TABLES (NO get_user_role() CALLS)\\\\n-- ================================================================\\\\n\\\\n-- clients: Only via client_users membership\\\\nCREATE POLICY clients_read_via_membership\\\\n  ON public.clients\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (EXISTS (\\\\n    SELECT 1 FROM public.client_users cu\\\\n    WHERE cu.user_id = auth.uid() AND cu.client_id = public.clients.id\\\\n  ))","\\\\n\\\\n-- client_branches: Only via client_users membership\\\\nCREATE POLICY branches_read_via_membership\\\\n  ON public.client_branches\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (EXISTS (\\\\n    SELECT 1 FROM public.client_users cu\\\\n    WHERE cu.user_id = auth.uid() AND cu.client_id = public.client_branches.client_id\\\\n  ))","\\\\n\\\\nCREATE POLICY branches_manage_via_master\\\\n  ON public.client_branches\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (EXISTS (\\\\n    SELECT 1 FROM public.client_users cu\\\\n    WHERE cu.user_id = auth.uid() \\\\n      AND cu.client_id = public.client_branches.client_id\\\\n      AND cu.role_in_client = 'master'\\\\n  ))\\\\n  WITH CHECK (EXISTS (\\\\n    SELECT 1 FROM public.client_users cu\\\\n    WHERE cu.user_id = auth.uid() \\\\n      AND cu.client_id = public.client_branches.client_id\\\\n      AND cu.role_in_client = 'master'\\\\n  ))","\\\\n\\\\n-- client_users: Read own + via master\\\\nCREATE POLICY cusers_read_self_and_master\\\\n  ON public.client_users\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    user_id = auth.uid()\\\\n    OR EXISTS (\\\\n      SELECT 1 FROM public.client_users cu2\\\\n      WHERE cu2.user_id = auth.uid()\\\\n        AND cu2.client_id = public.client_users.client_id\\\\n        AND cu2.role_in_client = 'master'\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY cusers_manage_via_master\\\\n  ON public.client_users\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (EXISTS (\\\\n    SELECT 1 FROM public.client_users cu2\\\\n    WHERE cu2.user_id = auth.uid()\\\\n      AND cu2.client_id = public.client_users.client_id\\\\n      AND cu2.role_in_client = 'master'\\\\n  ))\\\\n  WITH CHECK (EXISTS (\\\\n    SELECT 1 FROM public.client_users cu2\\\\n    WHERE cu2.user_id = auth.uid()\\\\n      AND cu2.client_id = public.client_users.client_id\\\\n      AND cu2.role_in_client = 'master'\\\\n  ))","\\\\n\\\\n-- price_overrides: Read via client membership\\\\nCREATE POLICY poverrides_read_via_membership\\\\n  ON public.price_overrides\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (EXISTS (\\\\n    SELECT 1 FROM public.client_users cu\\\\n    WHERE cu.user_id = auth.uid() AND cu.client_id = public.price_overrides.client_id\\\\n  ))","\\\\n\\\\n-- orders: Read/manage via client membership and branch scope\\\\nCREATE POLICY orders_read_via_membership\\\\n  ON public.orders\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (EXISTS (\\\\n    SELECT 1 FROM public.client_users cu\\\\n    WHERE cu.user_id = auth.uid()\\\\n      AND cu.client_id = public.orders.client_id\\\\n      AND (\\\\n        cu.role_in_client = 'master'\\\\n        OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = public.orders.branch_id)\\\\n      )\\\\n  ))","\\\\n\\\\nCREATE POLICY orders_insert_via_membership\\\\n  ON public.orders\\\\n  FOR INSERT\\\\n  TO authenticated\\\\n  WITH CHECK (EXISTS (\\\\n    SELECT 1 FROM public.client_users cu\\\\n    WHERE cu.user_id = auth.uid()\\\\n      AND cu.client_id = public.orders.client_id\\\\n      AND (\\\\n        cu.role_in_client = 'master'\\\\n        OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = public.orders.branch_id)\\\\n      )\\\\n  ))","\\\\n\\\\nCREATE POLICY orders_update_via_membership\\\\n  ON public.orders\\\\n  FOR UPDATE\\\\n  TO authenticated\\\\n  USING (EXISTS (\\\\n    SELECT 1 FROM public.client_users cu\\\\n    WHERE cu.user_id = auth.uid()\\\\n      AND cu.client_id = public.orders.client_id\\\\n      AND (\\\\n        cu.role_in_client = 'master'\\\\n        OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = public.orders.branch_id)\\\\n      )\\\\n  ))\\\\n  WITH CHECK (EXISTS (\\\\n    SELECT 1 FROM public.client_users cu\\\\n    WHERE cu.user_id = auth.uid()\\\\n      AND cu.client_id = public.orders.client_id\\\\n      AND (\\\\n        cu.role_in_client = 'master'\\\\n        OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = public.orders.branch_id)\\\\n      )\\\\n  ))","\\\\n\\\\n-- order_items: Via orders relationship\\\\nCREATE POLICY oitems_read_via_orders\\\\n  ON public.order_items\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (EXISTS (\\\\n    SELECT 1\\\\n    FROM public.orders o\\\\n    JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n    WHERE o.id = public.order_items.order_id\\\\n      AND cu.user_id = auth.uid()\\\\n      AND (\\\\n        cu.role_in_client = 'master'\\\\n        OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = o.branch_id)\\\\n      )\\\\n  ))","\\\\n\\\\nCREATE POLICY oitems_manage_via_orders\\\\n  ON public.order_items\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (EXISTS (\\\\n    SELECT 1\\\\n    FROM public.orders o\\\\n    JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n    WHERE o.id = public.order_items.order_id\\\\n      AND cu.user_id = auth.uid()\\\\n      AND (\\\\n        cu.role_in_client = 'master'\\\\n        OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = o.branch_id)\\\\n      )\\\\n  ))\\\\n  WITH CHECK (EXISTS (\\\\n    SELECT 1\\\\n    FROM public.orders o\\\\n    JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n    WHERE o.id = public.order_items.order_id\\\\n      AND cu.user_id = auth.uid()\\\\n      AND (\\\\n        cu.role_in_client = 'master'\\\\n        OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = o.branch_id)\\\\n      )\\\\n  ))","\\\\n\\\\n-- order_status_history: Via orders relationship  \\\\nCREATE POLICY ostatus_read_via_orders\\\\n  ON public.order_status_history\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (EXISTS (\\\\n    SELECT 1\\\\n    FROM public.orders o\\\\n    JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n    WHERE o.id = public.order_status_history.order_id\\\\n      AND cu.user_id = auth.uid()\\\\n  ))","\\\\n\\\\nCREATE POLICY ostatus_insert_by_trigger\\\\n  ON public.order_status_history\\\\n  FOR INSERT\\\\n  TO authenticated\\\\n  WITH CHECK (true)","\\\\n\\\\n-- payments: Via orders relationship\\\\nCREATE POLICY payments_read_via_orders\\\\n  ON public.payments\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (EXISTS (\\\\n    SELECT 1\\\\n    FROM public.orders o\\\\n    JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n    WHERE o.id = public.payments.order_id\\\\n      AND cu.user_id = auth.uid()\\\\n  ))","\\\\n\\\\n-- audit_log: Anyone can insert (for audit trail)\\\\nCREATE POLICY audit_insert_all\\\\n  ON public.audit_log\\\\n  FOR INSERT\\\\n  TO authenticated\\\\n  WITH CHECK (true)","\\\\n\\\\n-- ================================================================\\\\n-- ADMIN SECURITY DEFINER FUNCTIONS (NO RLS DEPENDENCY)\\\\n-- ================================================================\\\\n\\\\n-- Admin function to check if current user is admin (bypasses RLS)\\\\nCREATE OR REPLACE FUNCTION public.is_current_user_admin()\\\\nRETURNS boolean\\\\nLANGUAGE sql\\\\nSECURITY DEFINER\\\\nSTABLE\\\\nAS $$\\\\n  SELECT EXISTS (\\\\n    SELECT 1 FROM public.user_profiles \\\\n    WHERE user_id = auth.uid() AND role_app = 'admin'\\\\n  )","\\\\n$$","\\\\n\\\\n-- Admin function to manage categories\\\\nCREATE OR REPLACE FUNCTION public.admin_manage_category(\\\\n  action_type text,\\\\n  category_data jsonb DEFAULT '{}'::jsonb,\\\\n  category_id_param uuid DEFAULT NULL\\\\n)\\\\nRETURNS jsonb\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nAS $$\\\\nDECLARE\\\\n  result jsonb","\\\\nBEGIN\\\\n  -- Check if current user is admin\\\\n  IF NOT public.is_current_user_admin() THEN\\\\n    RAISE EXCEPTION 'Access denied: Admin role required'","\\\\n  END IF","\\\\n\\\\n  CASE action_type\\\\n    WHEN 'create' THEN\\\\n      INSERT INTO public.categories (name, slug)\\\\n      VALUES (\\\\n        category_data->>'name',\\\\n        category_data->>'slug'\\\\n      )\\\\n      RETURNING jsonb_build_object('id', id, 'created', true) INTO result","\\\\n      \\\\n    WHEN 'update' THEN\\\\n      UPDATE public.categories\\\\n      SET \\\\n        name = category_data->>'name',\\\\n        slug = category_data->>'slug'\\\\n      WHERE id = category_id_param\\\\n      RETURNING jsonb_build_object('id', id, 'updated', true) INTO result","\\\\n      \\\\n    WHEN 'delete' THEN\\\\n      DELETE FROM public.categories WHERE id = category_id_param\\\\n      RETURNING jsonb_build_object('id', id, 'deleted', true) INTO result","\\\\n      \\\\n    ELSE\\\\n      RAISE EXCEPTION 'Invalid action_type: %', action_type","\\\\n  END CASE","\\\\n  \\\\n  RETURN result","\\\\nEND","\\\\n$$","\\\\n\\\\n-- Admin function to manage products\\\\nCREATE OR REPLACE FUNCTION public.admin_manage_product(\\\\n  action_type text,\\\\n  product_data jsonb DEFAULT '{}'::jsonb,\\\\n  product_id_param uuid DEFAULT NULL\\\\n)\\\\nRETURNS jsonb\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nAS $$\\\\nDECLARE\\\\n  result jsonb","\\\\nBEGIN\\\\n  -- Check if current user is admin\\\\n  IF NOT public.is_current_user_admin() THEN\\\\n    RAISE EXCEPTION 'Access denied: Admin role required'","\\\\n  END IF","\\\\n\\\\n  CASE action_type\\\\n    WHEN 'create' THEN\\\\n      INSERT INTO public.products (\\\\n        category_id, name, slug, description, unit, list_price, active\\\\n      )\\\\n      VALUES (\\\\n        (product_data->>'category_id')::uuid,\\\\n        product_data->>'name',\\\\n        product_data->>'slug',\\\\n        product_data->>'description',\\\\n        product_data->>'unit',\\\\n        (product_data->>'list_price')::numeric,\\\\n        COALESCE((product_data->>'active')::boolean, true)\\\\n      )\\\\n      RETURNING jsonb_build_object('id', id, 'created', true) INTO result","\\\\n      \\\\n    WHEN 'update' THEN\\\\n      UPDATE public.products\\\\n      SET \\\\n        category_id = (product_data->>'category_id')::uuid,\\\\n        name = product_data->>'name',\\\\n        slug = product_data->>'slug',\\\\n        description = product_data->>'description',\\\\n        unit = product_data->>'unit',\\\\n        list_price = (product_data->>'list_price')::numeric,\\\\n        active = COALESCE((product_data->>'active')::boolean, true)\\\\n      WHERE id = product_id_param\\\\n      RETURNING jsonb_build_object('id', id, 'updated', true) INTO result","\\\\n      \\\\n    WHEN 'delete' THEN\\\\n      DELETE FROM public.products WHERE id = product_id_param\\\\n      RETURNING jsonb_build_object('id', id, 'deleted', true) INTO result","\\\\n      \\\\n    ELSE\\\\n      RAISE EXCEPTION 'Invalid action_type: %', action_type","\\\\n  END CASE","\\\\n  \\\\n  RETURN result","\\\\nEND","\\\\n$$","\\\\n\\\\n-- Admin function to manage user profiles (BYPASSES RLS)\\\\nCREATE OR REPLACE FUNCTION public.admin_manage_user_profile(\\\\n  action_type text,\\\\n  target_user_id uuid,\\\\n  profile_data jsonb DEFAULT '{}'::jsonb\\\\n)\\\\nRETURNS jsonb\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nAS $$\\\\nDECLARE\\\\n  result jsonb","\\\\nBEGIN\\\\n  -- Check if current user is admin\\\\n  IF NOT public.is_current_user_admin() THEN\\\\n    RAISE EXCEPTION 'Access denied: Admin role required'","\\\\n  END IF","\\\\n\\\\n  CASE action_type\\\\n    WHEN 'upsert' THEN\\\\n      INSERT INTO public.user_profiles (\\\\n        user_id, \\\\n        role_app, \\\\n        display_name,\\\\n        phone\\\\n      )\\\\n      VALUES (\\\\n        target_user_id,\\\\n        profile_data->>'role_app',\\\\n        profile_data->>'display_name',\\\\n        profile_data->>'phone'\\\\n      )\\\\n      ON CONFLICT (user_id) \\\\n      DO UPDATE SET \\\\n        role_app = EXCLUDED.role_app,\\\\n        display_name = COALESCE(EXCLUDED.display_name, public.user_profiles.display_name),\\\\n        phone = COALESCE(EXCLUDED.phone, public.user_profiles.phone)\\\\n      RETURNING jsonb_build_object('user_id', user_id, 'upserted', true) INTO result","\\\\n      \\\\n    WHEN 'update_role' THEN\\\\n      UPDATE public.user_profiles\\\\n      SET role_app = profile_data->>'role_app'\\\\n      WHERE user_id = target_user_id\\\\n      RETURNING jsonb_build_object('user_id', user_id, 'role_updated', true) INTO result","\\\\n      \\\\n    ELSE\\\\n      RAISE EXCEPTION 'Invalid action_type: %', action_type","\\\\n  END CASE","\\\\n  \\\\n  RETURN result","\\\\nEND","\\\\n$$","\\\\n\\\\n-- Reload schema cache\\\\nDO $$\\\\nBEGIN\\\\n  PERFORM pg_notify('pgrst', 'reload schema')","\\\\nEXCEPTION WHEN OTHERS THEN\\\\n  NULL","\\\\nEND $$","\\\\n\\\\nCOMMIT",""}	dark_scene
20250903033724	{"-- ================================================================\\\\n-- SUPROSER — FIX GLOBAL (RLS client_users + RPC dashboard)\\\\n-- ÚNICO SCRIPT. Idempotente. No borra datos.\\\\n-- ================================================================\\\\n\\\\nBEGIN","\\\\n\\\\n-- Asegurar extensión usada en seeds/funciones\\\\nCREATE EXTENSION IF NOT EXISTS \\"pgcrypto\\"","\\\\n\\\\n-- ----------------------------------------------------------------\\\\n-- 1) Helper que evita recursión en políticas de client_users\\\\n--    (lee client_users con SECURITY DEFINER y sin RLS)\\\\n-- ----------------------------------------------------------------\\\\nCREATE OR REPLACE FUNCTION public.is_master_of_client(p_user uuid, p_client uuid)\\\\nRETURNS boolean\\\\nLANGUAGE sql\\\\nSECURITY DEFINER\\\\nSET search_path = public\\\\nAS $$\\\\n  SELECT EXISTS (\\\\n    SELECT 1\\\\n    FROM public.client_users\\\\n    WHERE user_id = p_user\\\\n      AND client_id = p_client\\\\n      AND role_in_client = 'master'\\\\n  )","\\\\n$$","\\\\n\\\\nCOMMENT ON FUNCTION public.is_master_of_client(uuid,uuid)\\\\n  IS 'Devuelve true si el usuario es MASTER del cliente. SECURITY DEFINER para evitar recursión en políticas.'","\\\\n\\\\n-- ----------------------------------------------------------------\\\\n-- 2) Reescribir SOLO las políticas de client_users para eliminar\\\\n--    la auto-referencia (la causa del \\"infinite recursion\\").\\\\n--    El resto de políticas que ya tienes quedan intactas.\\\\n-- ----------------------------------------------------------------\\\\nALTER TABLE public.client_users ENABLE ROW LEVEL SECURITY","\\\\n\\\\n-- Drop previas\\\\nDROP POLICY IF EXISTS cusers_read                  ON public.client_users","\\\\nDROP POLICY IF EXISTS cusers_manage_admin_master   ON public.client_users","\\\\n\\\\n-- Lectura de client_users:\\\\n--  - admin ve todo\\\\n--  - el propio usuario ve sus filas\\\\n--  - los MASTER de un cliente ven TODAS las filas de ese cliente\\\\nCREATE POLICY cusers_read\\\\n  ON public.client_users\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR user_id = auth.uid()\\\\n    OR public.is_master_of_client(auth.uid(), client_id)\\\\n  )","\\\\n\\\\n-- Escritura/gestión:\\\\n--  - admin total\\\\n--  - MASTER del cliente puede gestionar filas de su mismo client_id\\\\nCREATE POLICY cusers_manage_admin_master\\\\n  ON public.client_users\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR public.is_master_of_client(auth.uid(), client_id)\\\\n  )\\\\n  WITH CHECK (\\\\n    public.get_user_role(auth.uid()) = 'admin'\\\\n    OR public.is_master_of_client(auth.uid(), client_id)\\\\n  )","\\\\n\\\\n-- ----------------------------------------------------------------\\\\n-- 3) RPC para el resumen del panel de Admin\\\\n--    (lo llama el front como /rpc/admin_get_dashboard_stats)\\\\n-- ----------------------------------------------------------------\\\\nCREATE OR REPLACE FUNCTION public.admin_get_dashboard_stats()\\\\nRETURNS TABLE (\\\\n  total_products               bigint,\\\\n  total_categories             bigint,\\\\n  total_clients                bigint,\\\\n  total_orders                 bigint,\\\\n  orders_borrador              bigint,\\\\n  orders_pendiente_aprobacion  bigint,\\\\n  orders_aprobado              bigint,\\\\n  orders_pagado                bigint,\\\\n  orders_en_preparacion        bigint,\\\\n  orders_despachado            bigint,\\\\n  orders_completado            bigint,\\\\n  orders_anulado               bigint,\\\\n  recent_status                jsonb,\\\\n  recent_payments              jsonb\\\\n)\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nSET search_path = public, auth\\\\nAS $$\\\\nBEGIN\\\\n  IF public.get_user_role(auth.uid()) <> 'admin' THEN\\\\n    RAISE EXCEPTION 'not_authorized'","\\\\n  END IF","\\\\n\\\\n  RETURN QUERY\\\\n  WITH\\\\n    o_counts AS (\\\\n      SELECT\\\\n        COUNT(*)::bigint AS total_orders,\\\\n        COUNT(*) FILTER (WHERE status='borrador')::bigint                AS orders_borrador,\\\\n        COUNT(*) FILTER (WHERE status='pendiente_aprobacion')::bigint    AS orders_pendiente_aprobacion,\\\\n        COUNT(*) FILTER (WHERE status='aprobado')::bigint                AS orders_aprobado,\\\\n        COUNT(*) FILTER (WHERE status='pagado')::bigint                  AS orders_pagado,\\\\n        COUNT(*) FILTER (WHERE status='en_preparacion')::bigint          AS orders_en_preparacion,\\\\n        COUNT(*) FILTER (WHERE status='despachado')::bigint              AS orders_despachado,\\\\n        COUNT(*) FILTER (WHERE status='completado')::bigint              AS orders_completado,\\\\n        COUNT(*) FILTER (WHERE status='anulado')::bigint                 AS orders_anulado\\\\n      FROM public.orders\\\\n    ),\\\\n    r_status AS (\\\\n      SELECT COALESCE(\\\\n        jsonb_agg(jsonb_build_object(\\\\n          'id', id,\\\\n          'order_id', order_id,\\\\n          'from_status', from_status,\\\\n          'to_status', to_status,\\\\n          'at', at\\\\n        ) ORDER BY at DESC),\\\\n        '[]'::jsonb\\\\n      ) AS js\\\\n      FROM (\\\\n        SELECT id, order_id, from_status, to_status, at\\\\n        FROM public.order_status_history\\\\n        ORDER BY at DESC\\\\n        LIMIT 10\\\\n      ) t\\\\n    ),\\\\n    r_payments AS (\\\\n      SELECT COALESCE(\\\\n        jsonb_agg(jsonb_build_object(\\\\n          'id', id,\\\\n          'order_id', order_id,\\\\n          'method', method,\\\\n          'status', status,\\\\n          'amount', amount,\\\\n          'created_at', created_at\\\\n        ) ORDER BY created_at DESC),\\\\n        '[]'::jsonb\\\\n      ) AS js\\\\n      FROM (\\\\n        SELECT id, order_id, method, status, amount, created_at\\\\n        FROM public.payments\\\\n        ORDER BY created_at DESC\\\\n        LIMIT 10\\\\n      ) p\\\\n    )\\\\n  SELECT\\\\n    (SELECT COUNT(*) FROM public.products)::bigint    AS total_products,\\\\n    (SELECT COUNT(*) FROM public.categories)::bigint  AS total_categories,\\\\n    (SELECT COUNT(*) FROM public.clients)::bigint     AS total_clients,\\\\n    oc.total_orders,\\\\n    oc.orders_borrador,\\\\n    oc.orders_pendiente_aprobacion,\\\\n    oc.orders_aprobado,\\\\n    oc.orders_pagado,\\\\n    oc.orders_en_preparacion,\\\\n    oc.orders_despachado,\\\\n    oc.orders_completado,\\\\n    oc.orders_anulado,\\\\n    rs.js AS recent_status,\\\\n    rp.js AS recent_payments\\\\n  FROM o_counts oc, r_status rs, r_payments rp","\\\\nEND","\\\\n$$","\\\\n\\\\nGRANT EXECUTE ON FUNCTION public.admin_get_dashboard_stats() TO authenticated","\\\\n\\\\n-- ----------------------------------------------------------------\\\\n-- 4) Recargar cache de PostgREST (para que aparezcan cambios ya)\\\\n-- ----------------------------------------------------------------\\\\nDO $$\\\\nBEGIN\\\\n  PERFORM pg_notify('pgrst', 'reload schema')","\\\\nEXCEPTION WHEN OTHERS THEN\\\\n  NULL","\\\\nEND $$","\\\\n\\\\nCOMMIT","\\\\n"}	ancient_gate
20250903034659	{"\\\\n\\\\n-- ================================================================\\\\n-- COMPLETE POLICY RESET - NO RECURSION\\\\n-- ================================================================\\\\n\\\\n-- Step 1: Drop ALL existing policies to start clean\\\\nDO $$\\\\nDECLARE\\\\n    pol record","\\\\nBEGIN\\\\n    FOR pol IN \\\\n        SELECT schemaname, tablename, policyname\\\\n        FROM pg_policies \\\\n        WHERE schemaname = 'public'\\\\n    LOOP\\\\n        EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', \\\\n                      pol.policyname, pol.schemaname, pol.tablename)","\\\\n    END LOOP","\\\\nEND $$","\\\\n\\\\n-- Step 2: Drop the problematic function\\\\nDROP FUNCTION IF EXISTS public.get_user_role(uuid) CASCADE","\\\\n\\\\n-- ================================================================\\\\n-- SIMPLE NON-RECURSIVE POLICIES\\\\n-- ================================================================\\\\n\\\\n-- user_profiles: Only self-access (NO admin policy to avoid recursion)\\\\nCREATE POLICY profiles_self_only\\\\n  ON public.user_profiles\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (user_id = auth.uid())\\\\n  WITH CHECK (user_id = auth.uid())","\\\\n\\\\n-- categories: Public read, admin manages via RPC only\\\\nCREATE POLICY categories_public_read\\\\n  ON public.categories\\\\n  FOR SELECT\\\\n  TO anon, authenticated\\\\n  USING (true)","\\\\n\\\\n-- products: Public read active products, admin manages via RPC only  \\\\nCREATE POLICY products_public_read\\\\n  ON public.products\\\\n  FOR SELECT\\\\n  TO anon, authenticated\\\\n  USING (active = true)","\\\\n\\\\n-- product_images: Public read for active products\\\\nCREATE POLICY product_images_public_read\\\\n  ON public.product_images\\\\n  FOR SELECT\\\\n  TO anon, authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM public.products p\\\\n      WHERE p.id = product_id AND p.active = true\\\\n    )\\\\n  )","\\\\n\\\\n-- clients: NO direct access - admin uses RPC only\\\\n-- (No policies = no access except via RPC)\\\\n\\\\n-- client_branches: NO direct access - admin uses RPC only\\\\n-- (No policies = no access except via RPC)\\\\n\\\\n-- client_users: NO direct access - admin uses RPC only\\\\n-- (No policies = no access except via RPC)\\\\n\\\\n-- price_overrides: NO direct access - admin uses RPC only\\\\n-- (No policies = no access except via RPC)\\\\n\\\\n-- orders: NO direct access - admin uses RPC only\\\\n-- (No policies = no access except via RPC)\\\\n\\\\n-- order_items: NO direct access - admin uses RPC only\\\\n-- (No policies = no access except via RPC)\\\\n\\\\n-- order_status_history: NO direct access - admin uses RPC only\\\\n-- (No policies = no access except via RPC)\\\\n\\\\n-- payments: NO direct access - admin uses RPC only\\\\n-- (No policies = no access except via RPC)\\\\n\\\\n-- webhook_events: Admin only via RPC\\\\n-- (No policies = no access except via RPC)\\\\n\\\\n-- audit_log: Insert only for logging\\\\nCREATE POLICY audit_insert_only\\\\n  ON public.audit_log\\\\n  FOR INSERT\\\\n  TO authenticated\\\\n  WITH CHECK (true)","\\\\n\\\\n-- ================================================================\\\\n-- ADMIN RPC FUNCTIONS (SECURITY DEFINER)\\\\n-- ================================================================\\\\n\\\\n-- Helper function to check if current user is admin\\\\nCREATE OR REPLACE FUNCTION public.is_current_user_admin()\\\\nRETURNS boolean\\\\nLANGUAGE sql\\\\nSECURITY DEFINER\\\\nSTABLE\\\\nAS $$\\\\n  SELECT COALESCE(\\\\n    (SELECT role_app = 'admin' \\\\n     FROM public.user_profiles \\\\n     WHERE user_id = auth.uid()), \\\\n    false\\\\n  )","\\\\n$$","\\\\n\\\\n-- Admin: Get recent orders for dashboard\\\\nCREATE OR REPLACE FUNCTION public.admin_get_recent_orders()\\\\nRETURNS TABLE (\\\\n  id uuid,\\\\n  status text,\\\\n  total numeric,\\\\n  created_at timestamptz,\\\\n  client_id uuid,\\\\n  client_name text\\\\n)\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nAS $$\\\\nBEGIN\\\\n  -- Check admin access\\\\n  IF NOT public.is_current_user_admin() THEN\\\\n    RAISE EXCEPTION 'Access denied: Admin role required'","\\\\n  END IF","\\\\n\\\\n  RETURN QUERY\\\\n  SELECT \\\\n    o.id,\\\\n    o.status,\\\\n    o.total,\\\\n    o.created_at,\\\\n    o.client_id,\\\\n    c.name as client_name\\\\n  FROM public.orders o\\\\n  LEFT JOIN public.clients c ON c.id = o.client_id\\\\n  ORDER BY o.created_at DESC\\\\n  LIMIT 10","\\\\nEND","\\\\n$$","\\\\n\\\\n-- Admin: Get order status changes for dashboard  \\\\nCREATE OR REPLACE FUNCTION public.admin_get_status_changes()\\\\nRETURNS TABLE (\\\\n  id bigint,\\\\n  order_id uuid,\\\\n  from_status text,\\\\n  to_status text,\\\\n  at timestamptz\\\\n)\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nAS $$\\\\nBEGIN\\\\n  -- Check admin access\\\\n  IF NOT public.is_current_user_admin() THEN\\\\n    RAISE EXCEPTION 'Access denied: Admin role required'","\\\\n  END IF","\\\\n\\\\n  RETURN QUERY\\\\n  SELECT \\\\n    osh.id,\\\\n    osh.order_id,\\\\n    osh.from_status,\\\\n    osh.to_status,\\\\n    osh.at\\\\n  FROM public.order_status_history osh\\\\n  ORDER BY osh.at DESC\\\\n  LIMIT 10","\\\\nEND","\\\\n$$","\\\\n\\\\n-- Admin: Get price overrides\\\\nCREATE OR REPLACE FUNCTION public.admin_get_price_overrides()\\\\nRETURNS TABLE (\\\\n  id uuid,\\\\n  client_id uuid,\\\\n  product_id uuid,\\\\n  discount_pct numeric,\\\\n  custom_price numeric,\\\\n  created_at timestamptz,\\\\n  client_name text,\\\\n  product_name text,\\\\n  product_list_price numeric\\\\n)\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nAS $$\\\\nBEGIN\\\\n  -- Check admin access\\\\n  IF NOT public.is_current_user_admin() THEN\\\\n    RAISE EXCEPTION 'Access denied: Admin role required'","\\\\n  END IF","\\\\n\\\\n  RETURN QUERY\\\\n  SELECT \\\\n    po.id,\\\\n    po.client_id,\\\\n    po.product_id,\\\\n    po.discount_pct,\\\\n    po.custom_price,\\\\n    po.created_at,\\\\n    c.name as client_name,\\\\n    p.name as product_name,\\\\n    p.list_price as product_list_price\\\\n  FROM public.price_overrides po\\\\n  LEFT JOIN public.clients c ON c.id = po.client_id\\\\n  LEFT JOIN public.products p ON p.id = po.product_id\\\\n  ORDER BY po.created_at DESC","\\\\nEND","\\\\n$$","\\\\n\\\\n-- Admin: Get all clients\\\\nCREATE OR REPLACE FUNCTION public.admin_get_clients(search_query text DEFAULT NULL)\\\\nRETURNS TABLE (\\\\n  id uuid,\\\\n  name text,\\\\n  tax_id text,\\\\n  billing_email text,\\\\n  created_at timestamptz\\\\n)\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nAS $$\\\\nBEGIN\\\\n  -- Check admin access\\\\n  IF NOT public.is_current_user_admin() THEN\\\\n    RAISE EXCEPTION 'Access denied: Admin role required'","\\\\n  END IF","\\\\n\\\\n  RETURN QUERY\\\\n  SELECT \\\\n    c.id,\\\\n    c.name,\\\\n    c.tax_id,\\\\n    c.billing_email,\\\\n    c.created_at\\\\n  FROM public.clients c\\\\n  WHERE (\\\\n    search_query IS NULL \\\\n    OR c.name ILIKE '%' || search_query || '%'\\\\n  )\\\\n  ORDER BY c.name ASC","\\\\nEND","\\\\n$$","\\\\n\\\\n-- Admin: Get all payments\\\\nCREATE OR REPLACE FUNCTION public.admin_get_payments(\\\\n  page_offset int DEFAULT 0,\\\\n  page_limit int DEFAULT 20\\\\n)\\\\nRETURNS TABLE (\\\\n  id uuid,\\\\n  order_id uuid,\\\\n  method text,\\\\n  provider_ref text,\\\\n  status text,\\\\n  amount numeric,\\\\n  created_at timestamptz,\\\\n  client_name text,\\\\n  order_status text\\\\n)\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nAS $$\\\\nBEGIN\\\\n  -- Check admin access\\\\n  IF NOT public.is_current_user_admin() THEN\\\\n    RAISE EXCEPTION 'Access denied: Admin role required'","\\\\n  END IF","\\\\n\\\\n  RETURN QUERY\\\\n  SELECT \\\\n    p.id,\\\\n    p.order_id,\\\\n    p.method,\\\\n    p.provider_ref,\\\\n    p.status,\\\\n    p.amount,\\\\n    p.created_at,\\\\n    c.name as client_name,\\\\n    o.status as order_status\\\\n  FROM public.payments p\\\\n  LEFT JOIN public.orders o ON o.id = p.order_id\\\\n  LEFT JOIN public.clients c ON c.id = o.client_id\\\\n  ORDER BY p.created_at DESC\\\\n  OFFSET page_offset\\\\n  LIMIT page_limit","\\\\nEND","\\\\n$$","\\\\n\\\\n-- Reload schema\\\\nDO $$\\\\nBEGIN\\\\n  PERFORM pg_notify('pgrst', 'reload schema')","\\\\nEXCEPTION WHEN OTHERS THEN\\\\n  NULL","\\\\nEND $$",""}	jolly_unit
20250903035213	{"\\\\n\\\\n-- Drop all problematic policies that cause recursion\\\\nDROP POLICY IF EXISTS \\"orders_admin_full_access\\" ON orders","\\\\nDROP POLICY IF EXISTS \\"client_users_admin_full_access\\" ON client_users"," \\\\nDROP POLICY IF EXISTS \\"clients_admin_full_access\\" ON clients","\\\\nDROP POLICY IF EXISTS \\"client_branches_admin_full_access\\" ON client_branches","\\\\nDROP POLICY IF EXISTS \\"price_overrides_admin_full_access\\" ON price_overrides","\\\\nDROP POLICY IF EXISTS \\"payments_admin_full_access\\" ON payments","\\\\nDROP POLICY IF EXISTS \\"order_status_history_admin_full_access\\" ON order_status_history","\\\\nDROP POLICY IF EXISTS \\"webhook_events_admin_full_access\\" ON webhook_events","\\\\nDROP POLICY IF EXISTS \\"cusers_read_self_or_admin\\" ON client_users","\\\\nDROP POLICY IF EXISTS \\"cusers_admin_manage_only\\" ON client_users","\\\\n\\\\n-- Drop the problematic function completely\\\\nDROP FUNCTION IF EXISTS get_user_role(uuid) CASCADE","\\\\n\\\\n-- Create simple admin policies without recursion\\\\n-- These check role_app directly from user_profiles without helper functions\\\\n\\\\n-- user_profiles: Only self access (no admin policy to avoid recursion)\\\\n-- Admin will use service role for profile management\\\\n\\\\n-- clients: Admin full access\\\\nCREATE POLICY \\"clients_admin_access\\"\\\\n  ON clients\\\\n  FOR ALL \\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\n-- client_branches: Admin full access\\\\nCREATE POLICY \\"client_branches_admin_access\\"\\\\n  ON client_branches\\\\n  FOR ALL \\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\n-- client_users: Admin full access + self access for clients\\\\nCREATE POLICY \\"client_users_admin_access\\"\\\\n  ON client_users\\\\n  FOR ALL \\\\n  TO authenticated\\\\n  USING (\\\\n    -- Admin can see all\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n    OR\\\\n    -- Users can see their own assignments\\\\n    user_id = auth.uid()\\\\n  )\\\\n  WITH CHECK (\\\\n    -- Admin can manage all\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\n-- orders: Admin full access + client access\\\\nCREATE POLICY \\"orders_admin_and_client_access\\"\\\\n  ON orders\\\\n  FOR ALL \\\\n  TO authenticated\\\\n  USING (\\\\n    -- Admin can see all orders\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n    OR\\\\n    -- Client users can see their client's orders\\\\n    EXISTS (\\\\n      SELECT 1 FROM client_users cu\\\\n      WHERE cu.user_id = auth.uid() \\\\n      AND cu.client_id = orders.client_id\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    -- Admin can manage all orders\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n    OR\\\\n    -- Client users can create/update their client's orders\\\\n    EXISTS (\\\\n      SELECT 1 FROM client_users cu\\\\n      WHERE cu.user_id = auth.uid() \\\\n      AND cu.client_id = orders.client_id\\\\n    )\\\\n  )","\\\\n\\\\n-- price_overrides: Admin only\\\\nCREATE POLICY \\"price_overrides_admin_only\\"\\\\n  ON price_overrides\\\\n  FOR ALL \\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\n-- payments: Admin only\\\\nCREATE POLICY \\"payments_admin_only\\"\\\\n  ON payments\\\\n  FOR ALL \\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\n-- order_status_history: Admin + related order access\\\\nCREATE POLICY \\"order_status_history_admin_and_related\\"\\\\n  ON order_status_history\\\\n  FOR ALL \\\\n  TO authenticated\\\\n  USING (\\\\n    -- Admin can see all\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n    OR\\\\n    -- Users can see history of orders they have access to\\\\n    EXISTS (\\\\n      SELECT 1 FROM orders o\\\\n      JOIN client_users cu ON cu.client_id = o.client_id\\\\n      WHERE o.id = order_status_history.order_id \\\\n      AND cu.user_id = auth.uid()\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    -- Admin can create all status changes\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n    OR\\\\n    -- Users can create status changes for their orders\\\\n    EXISTS (\\\\n      SELECT 1 FROM orders o\\\\n      JOIN client_users cu ON cu.client_id = o.client_id\\\\n      WHERE o.id = order_status_history.order_id \\\\n      AND cu.user_id = auth.uid()\\\\n    )\\\\n  )","\\\\n\\\\n-- webhook_events: Admin only\\\\nCREATE POLICY \\"webhook_events_admin_only\\"\\\\n  ON webhook_events\\\\n  FOR ALL \\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n  )\\\\n  WITH CHECK (\\\\n    EXISTS (\\\\n      SELECT 1 FROM user_profiles \\\\n      WHERE user_id = auth.uid() \\\\n      AND role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\n-- Simple helper function without recursion\\\\nCREATE OR REPLACE FUNCTION is_current_user_admin()\\\\nRETURNS boolean\\\\nLANGUAGE plpgsql\\\\nSECURITY DEFINER\\\\nAS $$\\\\nBEGIN\\\\n  RETURN EXISTS (\\\\n    SELECT 1 FROM user_profiles \\\\n    WHERE user_id = auth.uid() \\\\n    AND role_app = 'admin'\\\\n  )","\\\\nEND","\\\\n$$",""}	navy_tree
20250903041654	{"-- ================================================================\\\\n-- SUPROSER — Patch de RLS estable (solo políticas problemáticas)\\\\n-- Objetivo:\\\\n--   - Evitar recursión e infinitos \\"spinners\\" para MASTER/GERENTE\\\\n--   - No tocar tablas, funciones ni el resto de políticas que ya funcionan\\\\n--   - Quitar duplicados y dejar un set simple y coherente\\\\n-- ================================================================\\\\n\\\\n-- Seguridad: trabajar siempre en esquema public\\\\nSET search_path = public","\\\\n\\\\n-- =========================\\\\n-- ORDERS\\\\n-- Reemplaza las 3 políticas antiguas por 1 compacta y clara\\\\n-- =========================\\\\n\\\\n-- (limpieza de posibles restos / nombres previos)\\\\nDROP POLICY IF EXISTS orders_client_scope        ON public.orders","\\\\nDROP POLICY IF EXISTS orders_read_scoped        ON public.orders","\\\\nDROP POLICY IF EXISTS orders_insert_scoped      ON public.orders","\\\\nDROP POLICY IF EXISTS orders_update_scoped      ON public.orders","\\\\nDROP POLICY IF EXISTS \\"orders_admin_and_client_access\\" ON public.orders","\\\\n\\\\n-- Política única para todas las operaciones en orders\\\\nCREATE POLICY orders_client_scope\\\\nON public.orders\\\\nFOR ALL\\\\nTO authenticated\\\\nUSING (\\\\n  -- Admin ve todo\\\\n  EXISTS (SELECT 1 FROM public.user_profiles up\\\\n          WHERE up.user_id = auth.uid() AND up.role_app = 'admin')\\\\n  OR\\\\n  -- Master del mismo cliente\\\\n  EXISTS (\\\\n    SELECT 1 FROM public.client_users cu_m\\\\n    WHERE cu_m.user_id = auth.uid()\\\\n      AND cu_m.client_id = public.orders.client_id\\\\n      AND cu_m.role_in_client = 'master'\\\\n  )\\\\n  OR\\\\n  -- Gerente de la sucursal del pedido\\\\n  EXISTS (\\\\n    SELECT 1 FROM public.client_users cu_g\\\\n    WHERE cu_g.user_id = auth.uid()\\\\n      AND cu_g.client_id = public.orders.client_id\\\\n      AND cu_g.branch_id = public.orders.branch_id\\\\n      AND cu_g.role_in_client = 'gerente_sucursal'\\\\n  )\\\\n)\\\\nWITH CHECK (\\\\n  -- Para INSERT/UPDATE, se exige el mismo alcance\\\\n  EXISTS (SELECT 1 FROM public.user_profiles up\\\\n          WHERE up.user_id = auth.uid() AND up.role_app = 'admin')\\\\n  OR\\\\n  EXISTS (\\\\n    SELECT 1 FROM public.client_users cu_m\\\\n    WHERE cu_m.user_id = auth.uid()\\\\n      AND cu_m.client_id = public.orders.client_id\\\\n      AND cu_m.role_in_client = 'master'\\\\n  )\\\\n  OR\\\\n  EXISTS (\\\\n    SELECT 1 FROM public.client_users cu_g\\\\n    WHERE cu_g.user_id = auth.uid()\\\\n      AND cu_g.client_id = public.orders.client_id\\\\n      AND cu_g.branch_id = public.orders.branch_id\\\\n      AND cu_g.role_in_client = 'gerente_sucursal'\\\\n  )\\\\n)","\\\\n\\\\n-- =========================\\\\n-- CLIENT_USERS\\\\n-- Reemplaza políticas antiguas por una pareja SELECT / WRITE\\\\n-- =========================\\\\n\\\\n-- (limpieza de posibles restos / nombres previos)\\\\nDROP POLICY IF EXISTS client_users_scope_select         ON public.client_users","\\\\nDROP POLICY IF EXISTS client_users_scope_write          ON public.client_users","\\\\nDROP POLICY IF EXISTS cusers_read                       ON public.client_users","\\\\nDROP POLICY IF EXISTS cusers_manage_admin_master        ON public.client_users","\\\\nDROP POLICY IF EXISTS \\"client_users_admin_access\\"       ON public.client_users","\\\\nDROP POLICY IF EXISTS \\"client_users_scope\\"              ON public.client_users","\\\\n\\\\n-- Solo lectura (evita acceso abierto y soporta vista de master)\\\\nCREATE POLICY client_users_scope_select\\\\nON public.client_users\\\\nFOR SELECT\\\\nTO authenticated\\\\nUSING (\\\\n  -- Admin ve todo\\\\n  EXISTS (SELECT 1 FROM public.user_profiles up\\\\n          WHERE up.user_id = auth.uid() AND up.role_app = 'admin')\\\\n  OR\\\\n  -- Propias filas (el usuario ve su propia relación)\\\\n  (public.client_users.user_id = auth.uid())\\\\n  OR\\\\n  -- Master puede ver usuarios de SU cliente\\\\n  EXISTS (\\\\n    SELECT 1\\\\n    FROM public.client_users cu_master\\\\n    WHERE cu_master.user_id = auth.uid()\\\\n      AND cu_master.client_id = public.client_users.client_id\\\\n      AND cu_master.role_in_client = 'master'\\\\n  )\\\\n)","\\\\n\\\\n-- Escritura (insert/update/delete) solo admin o master del mismo cliente\\\\nCREATE POLICY client_users_scope_write\\\\nON public.client_users\\\\nFOR ALL\\\\nTO authenticated\\\\nUSING (\\\\n  EXISTS (SELECT 1 FROM public.user_profiles up\\\\n          WHERE up.user_id = auth.uid() AND up.role_app = 'admin')\\\\n  OR\\\\n  EXISTS (\\\\n    SELECT 1\\\\n    FROM public.client_users cu_master\\\\n    WHERE cu_master.user_id = auth.uid()\\\\n      AND cu_master.client_id = public.client_users.client_id\\\\n      AND cu_master.role_in_client = 'master'\\\\n  )\\\\n)\\\\nWITH CHECK (\\\\n  EXISTS (SELECT 1 FROM public.user_profiles up\\\\n          WHERE up.user_id = auth.uid() AND up.role_app = 'admin')\\\\n  OR\\\\n  EXISTS (\\\\n    SELECT 1\\\\n    FROM public.client_users cu_master\\\\n    WHERE cu_master.user_id = auth.uid()\\\\n      AND cu_master.client_id = public.client_users.client_id\\\\n      AND cu_master.role_in_client = 'master'\\\\n  )\\\\n)","\\\\n\\\\n-- =========================\\\\n-- CLIENT_BRANCHES\\\\n-- Unifica acceso de admin/master/gerente por alcance\\\\n-- =========================\\\\n\\\\n-- (limpieza)\\\\nDROP POLICY IF EXISTS client_branches_scope             ON public.client_branches","\\\\nDROP POLICY IF EXISTS branches_read_scoped              ON public.client_branches","\\\\nDROP POLICY IF EXISTS branches_manage_admin_master      ON public.client_branches","\\\\nDROP POLICY IF EXISTS \\"client_branches_admin_access\\"    ON public.client_branches","\\\\n\\\\nCREATE POLICY client_branches_scope\\\\nON public.client_branches\\\\nFOR ALL\\\\nTO authenticated\\\\nUSING (\\\\n  -- Admin ve todo\\\\n  EXISTS (SELECT 1 FROM public.user_profiles up\\\\n          WHERE up.user_id = auth.uid() AND up.role_app = 'admin')\\\\n  OR\\\\n  -- Master del cliente\\\\n  EXISTS (\\\\n    SELECT 1 FROM public.client_users cu_m\\\\n    WHERE cu_m.user_id = auth.uid()\\\\n      AND cu_m.client_id = public.client_branches.client_id\\\\n      AND cu_m.role_in_client = 'master'\\\\n  )\\\\n  OR\\\\n  -- Gerente de esta sucursal\\\\n  EXISTS (\\\\n    SELECT 1 FROM public.client_users cu_g\\\\n    WHERE cu_g.user_id = auth.uid()\\\\n      AND cu_g.client_id = public.client_branches.client_id\\\\n      AND cu_g.branch_id = public.client_branches.id\\\\n      AND cu_g.role_in_client = 'gerente_sucursal'\\\\n  )\\\\n)\\\\nWITH CHECK (\\\\n  -- Solo admin o master pueden crear/editar/eliminar sucursales\\\\n  EXISTS (SELECT 1 FROM public.user_profiles up\\\\n          WHERE up.user_id = auth.uid() AND up.role_app = 'admin')\\\\n  OR\\\\n  EXISTS (\\\\n    SELECT 1 FROM public.client_users cu_m\\\\n    WHERE cu_m.user_id = auth.uid()\\\\n      AND cu_m.client_id = public.client_branches.client_id\\\\n      AND cu_m.role_in_client = 'master'\\\\n  )\\\\n)","\\\\n\\\\n-- =========================\\\\n-- ORDER_STATUS_HISTORY\\\\n-- Mantener lectura acotada y permitir INSERT del trigger\\\\n-- =========================\\\\n\\\\n-- (limpieza)\\\\nDROP POLICY IF EXISTS order_status_history_scope_read   ON public.order_status_history","\\\\nDROP POLICY IF EXISTS ostatus_read_scoped               ON public.order_status_history","\\\\nDROP POLICY IF EXISTS \\"order_status_history_admin_and_related\\" ON public.order_status_history","\\\\n\\\\n-- Lectura por alcance (admin / master cliente / gerente sucursal)\\\\nCREATE POLICY order_status_history_scope_read\\\\nON public.order_status_history\\\\nFOR SELECT\\\\nTO authenticated\\\\nUSING (\\\\n  EXISTS (SELECT 1 FROM public.user_profiles up\\\\n          WHERE up.user_id = auth.uid() AND up.role_app = 'admin')\\\\n  OR\\\\n  EXISTS (\\\\n    SELECT 1\\\\n    FROM public.orders o\\\\n    JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n    WHERE o.id = public.order_status_history.order_id\\\\n      AND cu.user_id = auth.uid()\\\\n      AND (\\\\n        cu.role_in_client = 'master'\\\\n        OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = o.branch_id)\\\\n      )\\\\n  )\\\\n)","\\\\n\\\\n-- Mantener (o crear si faltara) la política de INSERT libre por trigger\\\\n-- para no romper track_order_status_change()\\\\nDROP POLICY IF EXISTS ostatus_insert_by_trigger ON public.order_status_history","\\\\nCREATE POLICY ostatus_insert_by_trigger\\\\nON public.order_status_history\\\\nFOR INSERT\\\\nTO authenticated\\\\nWITH CHECK (true)","\\\\n\\\\n-- =========================\\\\n-- ORDER_ITEMS\\\\n-- Consolidar en una sola política estable (opcional pero recomendado)\\\\n-- =========================\\\\n\\\\n-- (limpieza)\\\\nDROP POLICY IF EXISTS order_items_scope           ON public.order_items","\\\\nDROP POLICY IF EXISTS oitems_read_scoped         ON public.order_items","\\\\nDROP POLICY IF EXISTS oitems_manage_scoped       ON public.order_items","\\\\n\\\\nCREATE POLICY order_items_scope\\\\nON public.order_items\\\\nFOR ALL\\\\nTO authenticated\\\\nUSING (\\\\n  EXISTS (SELECT 1 FROM public.user_profiles up\\\\n          WHERE up.user_id = auth.uid() AND up.role_app = 'admin')\\\\n  OR\\\\n  EXISTS (\\\\n    SELECT 1\\\\n    FROM public.orders o\\\\n    JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n    WHERE o.id = public.order_items.order_id\\\\n      AND cu.user_id = auth.uid()\\\\n      AND (\\\\n        cu.role_in_client = 'master'\\\\n        OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = o.branch_id)\\\\n      )\\\\n  )\\\\n)\\\\nWITH CHECK (\\\\n  EXISTS (SELECT 1 FROM public.user_profiles up\\\\n          WHERE up.user_id = auth.uid() AND up.role_app = 'admin')\\\\n  OR\\\\n  EXISTS (\\\\n    SELECT 1\\\\n    FROM public.orders o\\\\n    JOIN public.client_users cu ON cu.client_id = o.client_id\\\\n    WHERE o.id = public.order_items.order_id\\\\n      AND cu.user_id = auth.uid()\\\\n      AND (\\\\n        cu.role_in_client = 'master'\\\\n        OR (cu.role_in_client = 'gerente_sucursal' AND cu.branch_id = o.branch_id)\\\\n      )\\\\n  )\\\\n)","\\\\n\\\\n-- ================================================================\\\\n-- Nota:\\\\n--  - No se modifica user_profiles ni sus políticas (evita recursion 42P17).\\\\n--  - Se evitaron llamadas a get_user_role()"," solo se usa user_profiles.role_app.\\\\n--  - Se quitaron políticas antiguas para prevenir duplicados/conflictos.\\\\n--  - No hay HTML/JSON basura"," todo termina en '","'.\\\\n-- ================================================================"}	nameless_surf
20250903042959	{"\\\\n\\\\n-- Drop the problematic policy\\\\nDROP POLICY IF EXISTS \\"client_users_scope\\" ON client_users","\\\\n\\\\n-- Create a simple, non-recursive policy\\\\nCREATE POLICY \\"client_users_simple_access\\" ON client_users FOR ALL TO authenticated\\\\nUSING (\\\\n  -- Admin has full access\\\\n  EXISTS (SELECT 1 FROM user_profiles WHERE user_id = auth.uid() AND role_app = 'admin')\\\\n  OR\\\\n  -- Users can see their own assignments\\\\n  user_id = auth.uid()\\\\n)\\\\nWITH CHECK (\\\\n  -- Admin can manage all\\\\n  EXISTS (SELECT 1 FROM user_profiles WHERE user_id = auth.uid() AND role_app = 'admin')\\\\n  OR\\\\n  -- Masters can manage their client (but we'll handle this in app logic instead of RLS)\\\\n  user_id = auth.uid()\\\\n)","\\\\n\\\\n-- Also simplify other policies to avoid potential recursion\\\\n\\\\n-- Fix client_branches policy (remove complex exists)\\\\nDROP POLICY IF EXISTS \\"client_branches_scope\\" ON client_branches","\\\\nCREATE POLICY \\"client_branches_simple_access\\" ON client_branches FOR ALL TO authenticated\\\\nUSING (\\\\n  EXISTS (SELECT 1 FROM user_profiles WHERE user_id = auth.uid() AND role_app = 'admin')\\\\n)","\\\\n\\\\n-- Fix orders policy (remove complex joins)\\\\nDROP POLICY IF EXISTS \\"orders_client_scope\\" ON orders","\\\\nCREATE POLICY \\"orders_simple_access\\" ON orders FOR ALL TO authenticated\\\\nUSING (\\\\n  EXISTS (SELECT 1 FROM user_profiles WHERE user_id = auth.uid() AND role_app = 'admin')\\\\n)","\\\\n\\\\n-- Fix order_items policy\\\\nDROP POLICY IF EXISTS \\"order_items_scope\\" ON order_items","\\\\nCREATE POLICY \\"order_items_simple_access\\" ON order_items FOR ALL TO authenticated\\\\nUSING (\\\\n  EXISTS (SELECT 1 FROM user_profiles WHERE user_id = auth.uid() AND role_app = 'admin')\\\\n)","\\\\n\\\\n-- Fix order_status_history policy\\\\nDROP POLICY IF EXISTS \\"order_status_history_scope\\" ON order_status_history","\\\\nCREATE POLICY \\"order_status_history_simple_access\\" ON order_status_history FOR ALL TO authenticated\\\\nUSING (\\\\n  EXISTS (SELECT 1 FROM user_profiles WHERE user_id = auth.uid() AND role_app = 'admin')\\\\n)",""}	cool_night
20250903043755	{"\\\\n\\\\n-- Drop ALL existing policies to start fresh\\\\nDROP POLICY IF EXISTS profiles_read_own ON public.user_profiles","\\\\nDROP POLICY IF EXISTS profiles_update_own ON public.user_profiles","\\\\nDROP POLICY IF EXISTS profiles_admin_all ON public.user_profiles","\\\\nDROP POLICY IF EXISTS profiles_self_only ON public.user_profiles","\\\\n\\\\nDROP POLICY IF EXISTS clients_read_scoped ON public.clients","\\\\nDROP POLICY IF EXISTS clients_admin_all ON public.clients","\\\\nDROP POLICY IF EXISTS clients_admin_access ON public.clients","\\\\n\\\\nDROP POLICY IF EXISTS branches_read_scoped ON public.client_branches","\\\\nDROP POLICY IF EXISTS branches_manage_admin_master ON public.client_branches","\\\\nDROP POLICY IF EXISTS client_branches_simple_access ON public.client_branches","\\\\n\\\\nDROP POLICY IF EXISTS cusers_read ON public.client_users","\\\\nDROP POLICY IF EXISTS cusers_manage_admin_master ON public.client_users","\\\\nDROP POLICY IF EXISTS client_users_scope_select ON public.client_users","\\\\nDROP POLICY IF EXISTS client_users_scope_write ON public.client_users","\\\\nDROP POLICY IF EXISTS client_users_simple_access ON public.client_users","\\\\n\\\\nDROP POLICY IF EXISTS categories_public_read ON public.categories","\\\\nDROP POLICY IF EXISTS categories_admin_all ON public.categories","\\\\n\\\\nDROP POLICY IF EXISTS products_public_read ON public.products","\\\\nDROP POLICY IF EXISTS products_admin_all ON public.products","\\\\n\\\\nDROP POLICY IF EXISTS pimgs_public_read ON public.product_images","\\\\nDROP POLICY IF EXISTS pimgs_admin_all ON public.product_images","\\\\nDROP POLICY IF EXISTS product_images_public_read ON public.product_images","\\\\n\\\\nDROP POLICY IF EXISTS poverrides_read_scoped ON public.price_overrides","\\\\nDROP POLICY IF EXISTS poverrides_admin_all ON public.price_overrides","\\\\nDROP POLICY IF EXISTS price_overrides_admin_only ON public.price_overrides","\\\\n\\\\nDROP POLICY IF EXISTS orders_read_scoped ON public.orders","\\\\nDROP POLICY IF EXISTS orders_insert_scoped ON public.orders","\\\\nDROP POLICY IF EXISTS orders_update_scoped ON public.orders","\\\\nDROP POLICY IF EXISTS orders_simple_access ON public.orders","\\\\n\\\\nDROP POLICY IF EXISTS oitems_read_scoped ON public.order_items","\\\\nDROP POLICY IF EXISTS oitems_manage_scoped ON public.order_items","\\\\nDROP POLICY IF EXISTS order_items_simple_access ON public.order_items","\\\\n\\\\nDROP POLICY IF EXISTS ostatus_read_scoped ON public.order_status_history","\\\\nDROP POLICY IF EXISTS ostatus_insert_by_trigger ON public.order_status_history","\\\\nDROP POLICY IF EXISTS order_status_history_scope_read ON public.order_status_history","\\\\nDROP POLICY IF EXISTS order_status_history_simple_access ON public.order_status_history","\\\\n\\\\nDROP POLICY IF EXISTS payments_read_scoped ON public.payments","\\\\nDROP POLICY IF EXISTS payments_admin_all ON public.payments","\\\\nDROP POLICY IF EXISTS payments_admin_only ON public.payments","\\\\n\\\\nDROP POLICY IF EXISTS webhooks_admin_all ON public.webhook_events","\\\\nDROP POLICY IF EXISTS webhook_events_admin_only ON public.webhook_events","\\\\n\\\\nDROP POLICY IF EXISTS audit_admin_read ON public.audit_log","\\\\nDROP POLICY IF EXISTS audit_insert ON public.audit_log","\\\\nDROP POLICY IF EXISTS audit_insert_only ON public.audit_log","\\\\n\\\\n-- ================================================================\\\\n-- SIMPLE POLICIES WITHOUT RECURSION\\\\n-- ================================================================\\\\n\\\\n-- user_profiles: self-management\\\\nCREATE POLICY \\"profiles_self_manage\\"\\\\n  ON public.user_profiles\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (user_id = auth.uid())\\\\n  WITH CHECK (user_id = auth.uid())","\\\\n\\\\n-- categories: public read\\\\nCREATE POLICY \\"categories_public_read\\"\\\\n  ON public.categories\\\\n  FOR SELECT\\\\n  TO anon, authenticated\\\\n  USING (true)","\\\\n\\\\n-- products: public read for active\\\\nCREATE POLICY \\"products_public_read\\"\\\\n  ON public.products\\\\n  FOR SELECT\\\\n  TO anon, authenticated\\\\n  USING (active = true)","\\\\n\\\\n-- product_images: public read for active products\\\\nCREATE POLICY \\"product_images_public_read\\"\\\\n  ON public.product_images\\\\n  FOR SELECT\\\\n  TO anon, authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM public.products p \\\\n      WHERE p.id = product_id AND p.active = true\\\\n    )\\\\n  )","\\\\n\\\\n-- ================================================================\\\\n-- ADMIN-ONLY POLICIES (no recursion)\\\\n-- ================================================================\\\\n\\\\n-- All management tables: admin-only\\\\nCREATE POLICY \\"clients_admin_only\\"\\\\n  ON public.clients\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM public.user_profiles up\\\\n      WHERE up.user_id = auth.uid() AND up.role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY \\"client_branches_admin_only\\"\\\\n  ON public.client_branches\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM public.user_profiles up\\\\n      WHERE up.user_id = auth.uid() AND up.role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\n-- client_users: SIMPLE admin-only policy (no self-reference)\\\\nCREATE POLICY \\"client_users_admin_only\\"\\\\n  ON public.client_users\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM public.user_profiles up\\\\n      WHERE up.user_id = auth.uid() AND up.role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY \\"price_overrides_admin_only\\"\\\\n  ON public.price_overrides\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM public.user_profiles up\\\\n      WHERE up.user_id = auth.uid() AND up.role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY \\"orders_admin_only\\"\\\\n  ON public.orders\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM public.user_profiles up\\\\n      WHERE up.user_id = auth.uid() AND up.role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY \\"order_items_admin_only\\"\\\\n  ON public.order_items\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM public.user_profiles up\\\\n      WHERE up.user_id = auth.uid() AND up.role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY \\"order_status_history_admin_only\\"\\\\n  ON public.order_status_history\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM public.user_profiles up\\\\n      WHERE up.user_id = auth.uid() AND up.role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY \\"payments_admin_only\\"\\\\n  ON public.payments\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM public.user_profiles up\\\\n      WHERE up.user_id = auth.uid() AND up.role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY \\"webhook_events_admin_only\\"\\\\n  ON public.webhook_events\\\\n  FOR ALL\\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM public.user_profiles up\\\\n      WHERE up.user_id = auth.uid() AND up.role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY \\"audit_log_admin_read\\"\\\\n  ON public.audit_log\\\\n  FOR SELECT\\\\n  TO authenticated\\\\n  USING (\\\\n    EXISTS (\\\\n      SELECT 1 FROM public.user_profiles up\\\\n      WHERE up.user_id = auth.uid() AND up.role_app = 'admin'\\\\n    )\\\\n  )","\\\\n\\\\nCREATE POLICY \\"audit_log_insert_any\\"\\\\n  ON public.audit_log\\\\n  FOR INSERT\\\\n  TO authenticated\\\\n  WITH CHECK (true)","\\\\n\\\\n-- ================================================================\\\\n-- ADMIN MANAGEMENT FUNCTIONS (bypass RLS)\\\\n-- ================================================================\\\\n\\\\n-- Get client users for admin (bypass RLS)\\\\nCREATE OR REPLACE FUNCTION public.admin_get_client_users(\\\\n  search_term text DEFAULT NULL,\\\\n  client_filter uuid DEFAULT NULL,\\\\n  branch_filter uuid DEFAULT NULL,\\\\n  role_filter text DEFAULT NULL,\\\\n  page_num integer DEFAULT 1,\\\\n  page_size integer DEFAULT 25\\\\n)\\\\nRETURNS TABLE (\\\\n  id uuid,\\\\n  user_id uuid,\\\\n  client_id uuid,\\\\n  branch_id uuid,\\\\n  role_in_client text,\\\\n  created_at timestamptz,\\\\n  client_name text,\\\\n  branch_name text\\\\n)\\\\nSECURITY DEFINER\\\\nLANGUAGE plpgsql\\\\nAS $$\\\\nDECLARE\\\\n  offset_val integer := (page_num - 1) * page_size","\\\\nBEGIN\\\\n  -- Check admin role\\\\n  IF NOT EXISTS (\\\\n    SELECT 1 FROM public.user_profiles up\\\\n    WHERE up.user_id = auth.uid() AND up.role_app = 'admin'\\\\n  ) THEN\\\\n    RAISE EXCEPTION 'Access denied: admin role required'","\\\\n  END IF","\\\\n\\\\n  RETURN QUERY\\\\n  SELECT \\\\n    cu.id,\\\\n    cu.user_id,\\\\n    cu.client_id,\\\\n    cu.branch_id,\\\\n    cu.role_in_client,\\\\n    cu.created_at,\\\\n    c.name as client_name,\\\\n    cb.name as branch_name\\\\n  FROM client_users cu\\\\n  JOIN clients c ON c.id = cu.client_id\\\\n  LEFT JOIN client_branches cb ON cb.id = cu.branch_id\\\\n  WHERE \\\\n    (client_filter IS NULL OR cu.client_id = client_filter)\\\\n    AND (branch_filter IS NULL OR cu.branch_id = branch_filter)\\\\n    AND (role_filter IS NULL OR cu.role_in_client = role_filter)\\\\n  ORDER BY cu.created_at DESC\\\\n  LIMIT page_size\\\\n  OFFSET offset_val","\\\\nEND","\\\\n$$",""}	warm_marsh
20250903050229	{"-- ================================================================\\\\n-- PATCH RLS — client_users sin recursión (Master/Gerente desbloqueados)\\\\n-- No toca tablas, vistas, triggers ni otras políticas.\\\\n-- ================================================================\\\\nSET search_path = public","\\\\n\\\\n-- Helpers de rol (usan auth.uid()"," SECURITY DEFINER evita recursión)\\\\nCREATE OR REPLACE FUNCTION public.is_admin()\\\\nRETURNS boolean\\\\nLANGUAGE sql\\\\nSTABLE\\\\nSECURITY DEFINER\\\\nSET search_path = public\\\\nAS $$\\\\n  SELECT EXISTS (\\\\n    SELECT 1 FROM public.user_profiles\\\\n    WHERE user_id = auth.uid() AND role_app = 'admin'\\\\n  )","\\\\n$$","\\\\n\\\\nCREATE OR REPLACE FUNCTION public.is_master(p_client uuid)\\\\nRETURNS boolean\\\\nLANGUAGE sql\\\\nSTABLE\\\\nSECURITY DEFINER\\\\nSET search_path = public\\\\nAS $$\\\\n  SELECT EXISTS (\\\\n    SELECT 1 FROM public.client_users\\\\n    WHERE user_id = auth.uid()\\\\n      AND client_id = p_client\\\\n      AND role_in_client = 'master'\\\\n  )","\\\\n$$","\\\\n\\\\nCREATE OR REPLACE FUNCTION public.is_gerente(p_client uuid, p_branch uuid)\\\\nRETURNS boolean\\\\nLANGUAGE sql\\\\nSTABLE\\\\nSECURITY DEFINER\\\\nSET search_path = public\\\\nAS $$\\\\n  SELECT EXISTS (\\\\n    SELECT 1 FROM public.client_users\\\\n    WHERE user_id = auth.uid()\\\\n      AND client_id = p_client\\\\n      AND branch_id = p_branch\\\\n      AND role_in_client = 'gerente_sucursal'\\\\n  )","\\\\n$$","\\\\n\\\\n-- Limpiar políticas previas de client_users para evitar conflictos\\\\nDROP POLICY IF EXISTS client_users_scope_select  ON public.client_users","\\\\nDROP POLICY IF EXISTS client_users_scope_write   ON public.client_users","\\\\nDROP POLICY IF EXISTS client_users_scope_update  ON public.client_users","\\\\nDROP POLICY IF EXISTS client_users_scope_delete  ON public.client_users","\\\\nDROP POLICY IF EXISTS cusers_read                ON public.client_users","\\\\nDROP POLICY IF EXISTS cusers_manage_admin_master ON public.client_users","\\\\nDROP POLICY IF EXISTS \\"client_users_scope\\"       ON public.client_users","\\\\n\\\\n-- SELECT: Admin ve todo"," cada usuario ve su fila"," Master ve todos los de SU cliente.\\\\nCREATE POLICY client_users_scope_select\\\\nON public.client_users\\\\nFOR SELECT\\\\nTO authenticated\\\\nUSING (\\\\n  public.is_admin()\\\\n  OR (user_id = auth.uid())\\\\n  OR public.is_master(client_id)\\\\n)","\\\\n\\\\n-- INSERT: sólo Admin o Master del cliente\\\\nCREATE POLICY client_users_scope_write\\\\nON public.client_users\\\\nFOR INSERT\\\\nTO authenticated\\\\nWITH CHECK (\\\\n  public.is_admin() OR public.is_master(client_id)\\\\n)","\\\\n\\\\n-- UPDATE: sólo Admin o Master del cliente\\\\nCREATE POLICY client_users_scope_update\\\\nON public.client_users\\\\nFOR UPDATE\\\\nTO authenticated\\\\nUSING (\\\\n  public.is_admin() OR public.is_master(client_id)\\\\n)\\\\nWITH CHECK (\\\\n  public.is_admin() OR public.is_master(client_id)\\\\n)","\\\\n\\\\n-- DELETE: sólo Admin o Master del cliente\\\\nCREATE POLICY client_users_scope_delete\\\\nON public.client_users\\\\nFOR DELETE\\\\nTO authenticated\\\\nUSING (\\\\n  public.is_admin() OR public.is_master(client_id)\\\\n)","\\\\n\\\\n-- Opcional: refrescar PostgREST (si aplica)\\\\nDO $$\\\\nBEGIN\\\\n  PERFORM pg_notify('pgrst', 'reload schema')","\\\\nEXCEPTION WHEN OTHERS THEN\\\\n  NULL","\\\\nEND $$",""}	jolly_smoke
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 98, true);


--
-- Name: audit_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_log_id_seq', 1, true);


--
-- Name: order_status_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_status_history_id_seq', 6, true);


--
-- Name: webhook_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.webhook_events_id_seq', 1, false);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_client_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_client_id_key UNIQUE (client_id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_key UNIQUE (slug);


--
-- Name: client_branches client_branches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_branches
    ADD CONSTRAINT client_branches_pkey PRIMARY KEY (id);


--
-- Name: client_users client_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_users
    ADD CONSTRAINT client_users_pkey PRIMARY KEY (id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: order_status_history order_status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: payments payments_order_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_order_id_key UNIQUE (order_id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: price_overrides price_overrides_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_overrides
    ADD CONSTRAINT price_overrides_pkey PRIMARY KEY (id);


--
-- Name: product_images product_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: products products_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_slug_key UNIQUE (slug);


--
-- Name: user_profiles user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (user_id);


--
-- Name: webhook_events webhook_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.webhook_events
    ADD CONSTRAINT webhook_events_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_clients_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_client_id_idx ON auth.oauth_clients USING btree (client_id);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: idx_client_users_gerente_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_client_users_gerente_unique ON public.client_users USING btree (user_id, client_id, branch_id) WHERE ((role_in_client = 'gerente_sucursal'::text) AND (branch_id IS NOT NULL));


--
-- Name: idx_client_users_master_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_client_users_master_unique ON public.client_users USING btree (user_id, client_id) WHERE (role_in_client = 'master'::text);


--
-- Name: idx_order_items_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_order_items_order ON public.order_items USING btree (order_id);


--
-- Name: idx_orders_branch; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_branch ON public.orders USING btree (branch_id);


--
-- Name: idx_orders_client; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_client ON public.orders USING btree (client_id);


--
-- Name: idx_orders_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_status ON public.orders USING btree (status);


--
-- Name: idx_price_overrides_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_price_overrides_unique ON public.price_overrides USING btree (client_id, product_id);


--
-- Name: idx_product_images_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_images_product ON public.product_images USING btree (product_id);


--
-- Name: idx_products_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_active ON public.products USING btree (active) WHERE (active = true);


--
-- Name: idx_products_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_category ON public.products USING btree (category_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: order_items trg_oitems_after_recalc; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_oitems_after_recalc AFTER INSERT OR DELETE OR UPDATE ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.order_items_after_recalc_totals();


--
-- Name: order_items trg_oitems_before_set_total; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_oitems_before_set_total BEFORE INSERT OR UPDATE ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.order_items_before_set_line_total();


--
-- Name: orders trg_orders_status_history; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_orders_status_history AFTER UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.track_order_status_change();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: audit_log audit_log_actor_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_actor_user_id_fkey FOREIGN KEY (actor_user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: client_branches client_branches_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_branches
    ADD CONSTRAINT client_branches_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: client_users client_users_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_users
    ADD CONSTRAINT client_users_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.client_branches(id) ON DELETE CASCADE;


--
-- Name: client_users client_users_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_users
    ADD CONSTRAINT client_users_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: client_users client_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_users
    ADD CONSTRAINT client_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: order_status_history order_status_history_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_by_user_id_fkey FOREIGN KEY (by_user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: order_status_history order_status_history_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: orders orders_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.client_branches(id) ON DELETE RESTRICT;


--
-- Name: orders orders_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE RESTRICT;


--
-- Name: orders orders_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE RESTRICT;


--
-- Name: payments payments_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: price_overrides price_overrides_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_overrides
    ADD CONSTRAINT price_overrides_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: price_overrides price_overrides_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_overrides
    ADD CONSTRAINT price_overrides_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: product_images product_images_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- Name: user_profiles user_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: audit_log audit_admin_read; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY audit_admin_read ON public.audit_log FOR SELECT TO authenticated USING ((public.get_user_role(auth.uid()) = 'admin'::text));


--
-- Name: audit_log audit_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY audit_insert ON public.audit_log FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: audit_log; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

--
-- Name: client_branches branches_manage_admin_master; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY branches_manage_admin_master ON public.client_branches TO authenticated USING (((public.get_user_role(auth.uid()) = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM public.client_users cu
  WHERE ((cu.user_id = auth.uid()) AND (cu.client_id = client_branches.client_id) AND (cu.role_in_client = 'master'::text)))))) WITH CHECK (((public.get_user_role(auth.uid()) = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM public.client_users cu
  WHERE ((cu.user_id = auth.uid()) AND (cu.client_id = client_branches.client_id) AND (cu.role_in_client = 'master'::text))))));


--
-- Name: client_branches branches_read_scoped; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY branches_read_scoped ON public.client_branches FOR SELECT TO authenticated USING (((public.get_user_role(auth.uid()) = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM public.client_users cu
  WHERE ((cu.user_id = auth.uid()) AND (cu.client_id = client_branches.client_id))))));


--
-- Name: categories; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

--
-- Name: categories categories_admin_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY categories_admin_all ON public.categories TO authenticated USING ((public.get_user_role(auth.uid()) = 'admin'::text)) WITH CHECK ((public.get_user_role(auth.uid()) = 'admin'::text));


--
-- Name: categories categories_public_read; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY categories_public_read ON public.categories FOR SELECT TO authenticated, anon USING (true);


--
-- Name: client_branches; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.client_branches ENABLE ROW LEVEL SECURITY;

--
-- Name: client_users; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.client_users ENABLE ROW LEVEL SECURITY;

--
-- Name: clients; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

--
-- Name: clients clients_admin_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY clients_admin_all ON public.clients TO authenticated USING ((public.get_user_role(auth.uid()) = 'admin'::text)) WITH CHECK ((public.get_user_role(auth.uid()) = 'admin'::text));


--
-- Name: clients clients_read_scoped; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY clients_read_scoped ON public.clients FOR SELECT TO authenticated USING (((public.get_user_role(auth.uid()) = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM public.client_users cu
  WHERE ((cu.user_id = auth.uid()) AND (cu.client_id = cu.id))))));


--
-- Name: client_users cusers_admin_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY cusers_admin_all ON public.client_users TO authenticated USING ((public.get_user_role(auth.uid()) = 'admin'::text)) WITH CHECK ((public.get_user_role(auth.uid()) = 'admin'::text));


--
-- Name: client_users cusers_select_self_or_admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY cusers_select_self_or_admin ON public.client_users FOR SELECT TO authenticated USING (((public.get_user_role(auth.uid()) = 'admin'::text) OR (user_id = auth.uid())));


--
-- Name: order_items oitems_manage_scoped; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY oitems_manage_scoped ON public.order_items TO authenticated USING (((public.get_user_role(auth.uid()) = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM (public.orders o
     JOIN public.client_users cu ON ((cu.client_id = o.client_id)))
  WHERE ((o.id = order_items.order_id) AND (cu.user_id = auth.uid()) AND ((cu.role_in_client = 'master'::text) OR ((cu.role_in_client = 'gerente_sucursal'::text) AND (cu.branch_id = o.branch_id)))))))) WITH CHECK (((public.get_user_role(auth.uid()) = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM (public.orders o
     JOIN public.client_users cu ON ((cu.client_id = o.client_id)))
  WHERE ((o.id = order_items.order_id) AND (cu.user_id = auth.uid()) AND ((cu.role_in_client = 'master'::text) OR ((cu.role_in_client = 'gerente_sucursal'::text) AND (cu.branch_id = o.branch_id))))))));


--
-- Name: order_items oitems_read_scoped; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY oitems_read_scoped ON public.order_items FOR SELECT TO authenticated USING (((public.get_user_role(auth.uid()) = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM (public.orders o
     JOIN public.client_users cu ON ((cu.client_id = o.client_id)))
  WHERE ((o.id = order_items.order_id) AND (cu.user_id = auth.uid()) AND ((cu.role_in_client = 'master'::text) OR ((cu.role_in_client = 'gerente_sucursal'::text) AND (cu.branch_id = o.branch_id))))))));


--
-- Name: order_items; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;

--
-- Name: order_status_history; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.order_status_history ENABLE ROW LEVEL SECURITY;

--
-- Name: orders; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

--
-- Name: orders orders_insert_scoped; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY orders_insert_scoped ON public.orders FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.client_users cu
  WHERE ((cu.user_id = auth.uid()) AND (cu.client_id = orders.client_id) AND ((cu.role_in_client = 'master'::text) OR ((cu.role_in_client = 'gerente_sucursal'::text) AND (cu.branch_id = orders.branch_id)))))));


--
-- Name: orders orders_read_scoped; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY orders_read_scoped ON public.orders FOR SELECT TO authenticated USING (((public.get_user_role(auth.uid()) = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM public.client_users cu
  WHERE ((cu.user_id = auth.uid()) AND (cu.client_id = orders.client_id) AND ((cu.role_in_client = 'master'::text) OR ((cu.role_in_client = 'gerente_sucursal'::text) AND (cu.branch_id = orders.branch_id))))))));


--
-- Name: orders orders_update_scoped; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY orders_update_scoped ON public.orders FOR UPDATE TO authenticated USING (((public.get_user_role(auth.uid()) = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM public.client_users cu
  WHERE ((cu.user_id = auth.uid()) AND (cu.client_id = orders.client_id) AND ((cu.role_in_client = 'master'::text) OR ((cu.role_in_client = 'gerente_sucursal'::text) AND (cu.branch_id = orders.branch_id)))))))) WITH CHECK (((public.get_user_role(auth.uid()) = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM public.client_users cu
  WHERE ((cu.user_id = auth.uid()) AND (cu.client_id = orders.client_id) AND ((cu.role_in_client = 'master'::text) OR ((cu.role_in_client = 'gerente_sucursal'::text) AND (cu.branch_id = orders.branch_id))))))));


--
-- Name: order_status_history ostatus_insert_by_trigger; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY ostatus_insert_by_trigger ON public.order_status_history FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: order_status_history ostatus_read_scoped; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY ostatus_read_scoped ON public.order_status_history FOR SELECT TO authenticated USING (((public.get_user_role(auth.uid()) = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM (public.orders o
     JOIN public.client_users cu ON ((cu.client_id = o.client_id)))
  WHERE ((o.id = order_status_history.order_id) AND (cu.user_id = auth.uid()))))));


--
-- Name: payments; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;

--
-- Name: payments payments_admin_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY payments_admin_all ON public.payments TO authenticated USING ((public.get_user_role(auth.uid()) = 'admin'::text)) WITH CHECK ((public.get_user_role(auth.uid()) = 'admin'::text));


--
-- Name: payments payments_read_scoped; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY payments_read_scoped ON public.payments FOR SELECT TO authenticated USING (((public.get_user_role(auth.uid()) = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM (public.orders o
     JOIN public.client_users cu ON ((cu.client_id = o.client_id)))
  WHERE ((o.id = payments.order_id) AND (cu.user_id = auth.uid()))))));


--
-- Name: product_images pimgs_admin_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY pimgs_admin_all ON public.product_images TO authenticated USING ((public.get_user_role(auth.uid()) = 'admin'::text)) WITH CHECK ((public.get_user_role(auth.uid()) = 'admin'::text));


--
-- Name: product_images pimgs_public_read; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY pimgs_public_read ON public.product_images FOR SELECT TO authenticated, anon USING ((EXISTS ( SELECT 1
   FROM public.products p
  WHERE ((p.id = product_images.product_id) AND (p.active = true)))));


--
-- Name: price_overrides poverrides_admin_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY poverrides_admin_all ON public.price_overrides TO authenticated USING ((public.get_user_role(auth.uid()) = 'admin'::text)) WITH CHECK ((public.get_user_role(auth.uid()) = 'admin'::text));


--
-- Name: price_overrides poverrides_read_scoped; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY poverrides_read_scoped ON public.price_overrides FOR SELECT TO authenticated USING (((public.get_user_role(auth.uid()) = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM public.client_users cu
  WHERE ((cu.user_id = auth.uid()) AND (cu.client_id = price_overrides.client_id))))));


--
-- Name: price_overrides; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.price_overrides ENABLE ROW LEVEL SECURITY;

--
-- Name: product_images; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.product_images ENABLE ROW LEVEL SECURITY;

--
-- Name: products; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

--
-- Name: products products_admin_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY products_admin_all ON public.products TO authenticated USING ((public.get_user_role(auth.uid()) = 'admin'::text)) WITH CHECK ((public.get_user_role(auth.uid()) = 'admin'::text));


--
-- Name: products products_public_read; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY products_public_read ON public.products FOR SELECT TO authenticated, anon USING ((active = true));


--
-- Name: user_profiles profiles_admin_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profiles_admin_all ON public.user_profiles TO authenticated USING ((public.get_user_role(auth.uid()) = 'admin'::text)) WITH CHECK ((public.get_user_role(auth.uid()) = 'admin'::text));


--
-- Name: user_profiles profiles_read_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profiles_read_own ON public.user_profiles FOR SELECT TO authenticated USING ((user_id = auth.uid()));


--
-- Name: user_profiles profiles_update_own; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY profiles_update_own ON public.user_profiles FOR UPDATE TO authenticated USING ((user_id = auth.uid()));


--
-- Name: user_profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: webhook_events; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.webhook_events ENABLE ROW LEVEL SECURITY;

--
-- Name: webhook_events webhooks_admin_all; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY webhooks_admin_all ON public.webhook_events TO authenticated USING ((public.get_user_role(auth.uid()) = 'admin'::text)) WITH CHECK ((public.get_user_role(auth.uid()) = 'admin'::text));


--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO postgres;


--
-- Name: FUNCTION admin_get_client_users(search_term text, client_filter uuid, branch_filter uuid, role_filter text, page_num integer, page_size integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_get_client_users(search_term text, client_filter uuid, branch_filter uuid, role_filter text, page_num integer, page_size integer) TO anon;
GRANT ALL ON FUNCTION public.admin_get_client_users(search_term text, client_filter uuid, branch_filter uuid, role_filter text, page_num integer, page_size integer) TO authenticated;
GRANT ALL ON FUNCTION public.admin_get_client_users(search_term text, client_filter uuid, branch_filter uuid, role_filter text, page_num integer, page_size integer) TO service_role;


--
-- Name: FUNCTION admin_get_clients(search_query text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_get_clients(search_query text) TO anon;
GRANT ALL ON FUNCTION public.admin_get_clients(search_query text) TO authenticated;
GRANT ALL ON FUNCTION public.admin_get_clients(search_query text) TO service_role;


--
-- Name: FUNCTION admin_get_dashboard_stats(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_get_dashboard_stats() TO anon;
GRANT ALL ON FUNCTION public.admin_get_dashboard_stats() TO authenticated;
GRANT ALL ON FUNCTION public.admin_get_dashboard_stats() TO service_role;


--
-- Name: FUNCTION admin_get_payments(page_offset integer, page_limit integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_get_payments(page_offset integer, page_limit integer) TO anon;
GRANT ALL ON FUNCTION public.admin_get_payments(page_offset integer, page_limit integer) TO authenticated;
GRANT ALL ON FUNCTION public.admin_get_payments(page_offset integer, page_limit integer) TO service_role;


--
-- Name: FUNCTION admin_get_price_overrides(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_get_price_overrides() TO anon;
GRANT ALL ON FUNCTION public.admin_get_price_overrides() TO authenticated;
GRANT ALL ON FUNCTION public.admin_get_price_overrides() TO service_role;


--
-- Name: FUNCTION admin_get_recent_orders(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_get_recent_orders() TO anon;
GRANT ALL ON FUNCTION public.admin_get_recent_orders() TO authenticated;
GRANT ALL ON FUNCTION public.admin_get_recent_orders() TO service_role;


--
-- Name: FUNCTION admin_get_status_changes(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_get_status_changes() TO anon;
GRANT ALL ON FUNCTION public.admin_get_status_changes() TO authenticated;
GRANT ALL ON FUNCTION public.admin_get_status_changes() TO service_role;


--
-- Name: FUNCTION admin_manage_category(action_type text, category_data jsonb, category_id_param uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_manage_category(action_type text, category_data jsonb, category_id_param uuid) TO anon;
GRANT ALL ON FUNCTION public.admin_manage_category(action_type text, category_data jsonb, category_id_param uuid) TO authenticated;
GRANT ALL ON FUNCTION public.admin_manage_category(action_type text, category_data jsonb, category_id_param uuid) TO service_role;


--
-- Name: FUNCTION admin_manage_product(action_type text, product_data jsonb, product_id_param uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_manage_product(action_type text, product_data jsonb, product_id_param uuid) TO anon;
GRANT ALL ON FUNCTION public.admin_manage_product(action_type text, product_data jsonb, product_id_param uuid) TO authenticated;
GRANT ALL ON FUNCTION public.admin_manage_product(action_type text, product_data jsonb, product_id_param uuid) TO service_role;


--
-- Name: FUNCTION admin_manage_user_profile(action_type text, target_user_id uuid, profile_data jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_manage_user_profile(action_type text, target_user_id uuid, profile_data jsonb) TO anon;
GRANT ALL ON FUNCTION public.admin_manage_user_profile(action_type text, target_user_id uuid, profile_data jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.admin_manage_user_profile(action_type text, target_user_id uuid, profile_data jsonb) TO service_role;


--
-- Name: FUNCTION admin_search_users(search_query text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_search_users(search_query text) TO anon;
GRANT ALL ON FUNCTION public.admin_search_users(search_query text) TO authenticated;
GRANT ALL ON FUNCTION public.admin_search_users(search_query text) TO service_role;


--
-- Name: FUNCTION calculate_order_totals(order_uuid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.calculate_order_totals(order_uuid uuid) TO anon;
GRANT ALL ON FUNCTION public.calculate_order_totals(order_uuid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.calculate_order_totals(order_uuid uuid) TO service_role;


--
-- Name: FUNCTION get_user_role(user_uuid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_user_role(user_uuid uuid) TO anon;
GRANT ALL ON FUNCTION public.get_user_role(user_uuid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_user_role(user_uuid uuid) TO service_role;


--
-- Name: FUNCTION is_admin(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_admin() TO anon;
GRANT ALL ON FUNCTION public.is_admin() TO authenticated;
GRANT ALL ON FUNCTION public.is_admin() TO service_role;


--
-- Name: FUNCTION is_current_user_admin(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_current_user_admin() TO anon;
GRANT ALL ON FUNCTION public.is_current_user_admin() TO authenticated;
GRANT ALL ON FUNCTION public.is_current_user_admin() TO service_role;


--
-- Name: FUNCTION is_gerente(p_client uuid, p_branch uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_gerente(p_client uuid, p_branch uuid) TO anon;
GRANT ALL ON FUNCTION public.is_gerente(p_client uuid, p_branch uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_gerente(p_client uuid, p_branch uuid) TO service_role;


--
-- Name: FUNCTION is_master(p_client uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_master(p_client uuid) TO anon;
GRANT ALL ON FUNCTION public.is_master(p_client uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_master(p_client uuid) TO service_role;


--
-- Name: FUNCTION is_master_of_client(p_user uuid, p_client uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_master_of_client(p_user uuid, p_client uuid) TO anon;
GRANT ALL ON FUNCTION public.is_master_of_client(p_user uuid, p_client uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_master_of_client(p_user uuid, p_client uuid) TO service_role;


--
-- Name: FUNCTION log_security_event(actor uuid, action text, entity text, entity_id text, meta jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.log_security_event(actor uuid, action text, entity text, entity_id text, meta jsonb) TO anon;
GRANT ALL ON FUNCTION public.log_security_event(actor uuid, action text, entity text, entity_id text, meta jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.log_security_event(actor uuid, action text, entity text, entity_id text, meta jsonb) TO service_role;


--
-- Name: FUNCTION master_assign_client_user(p_user_id uuid, p_branch_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.master_assign_client_user(p_user_id uuid, p_branch_id uuid) TO anon;
GRANT ALL ON FUNCTION public.master_assign_client_user(p_user_id uuid, p_branch_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.master_assign_client_user(p_user_id uuid, p_branch_id uuid) TO service_role;


--
-- Name: FUNCTION master_get_user_by_email(p_email text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.master_get_user_by_email(p_email text) TO anon;
GRANT ALL ON FUNCTION public.master_get_user_by_email(p_email text) TO authenticated;
GRANT ALL ON FUNCTION public.master_get_user_by_email(p_email text) TO service_role;


--
-- Name: FUNCTION master_list_client_users(branch_filter uuid, client_filter uuid, page_num integer, page_size integer, role_filter text, search text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.master_list_client_users(branch_filter uuid, client_filter uuid, page_num integer, page_size integer, role_filter text, search text) TO anon;
GRANT ALL ON FUNCTION public.master_list_client_users(branch_filter uuid, client_filter uuid, page_num integer, page_size integer, role_filter text, search text) TO authenticated;
GRANT ALL ON FUNCTION public.master_list_client_users(branch_filter uuid, client_filter uuid, page_num integer, page_size integer, role_filter text, search text) TO service_role;


--
-- Name: FUNCTION order_items_after_recalc_totals(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.order_items_after_recalc_totals() TO anon;
GRANT ALL ON FUNCTION public.order_items_after_recalc_totals() TO authenticated;
GRANT ALL ON FUNCTION public.order_items_after_recalc_totals() TO service_role;


--
-- Name: FUNCTION order_items_before_set_line_total(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.order_items_before_set_line_total() TO anon;
GRANT ALL ON FUNCTION public.order_items_before_set_line_total() TO authenticated;
GRANT ALL ON FUNCTION public.order_items_before_set_line_total() TO service_role;


--
-- Name: FUNCTION track_order_status_change(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.track_order_status_change() TO anon;
GRANT ALL ON FUNCTION public.track_order_status_change() TO authenticated;
GRANT ALL ON FUNCTION public.track_order_status_change() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE audit_log; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.audit_log TO anon;
GRANT ALL ON TABLE public.audit_log TO authenticated;
GRANT ALL ON TABLE public.audit_log TO service_role;


--
-- Name: SEQUENCE audit_log_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.audit_log_id_seq TO anon;
GRANT ALL ON SEQUENCE public.audit_log_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.audit_log_id_seq TO service_role;


--
-- Name: TABLE categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.categories TO anon;
GRANT ALL ON TABLE public.categories TO authenticated;
GRANT ALL ON TABLE public.categories TO service_role;


--
-- Name: TABLE client_branches; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.client_branches TO anon;
GRANT ALL ON TABLE public.client_branches TO authenticated;
GRANT ALL ON TABLE public.client_branches TO service_role;


--
-- Name: TABLE client_users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.client_users TO anon;
GRANT ALL ON TABLE public.client_users TO authenticated;
GRANT ALL ON TABLE public.client_users TO service_role;


--
-- Name: TABLE clients; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.clients TO anon;
GRANT ALL ON TABLE public.clients TO authenticated;
GRANT ALL ON TABLE public.clients TO service_role;


--
-- Name: TABLE order_items; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.order_items TO anon;
GRANT ALL ON TABLE public.order_items TO authenticated;
GRANT ALL ON TABLE public.order_items TO service_role;


--
-- Name: TABLE order_status_history; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.order_status_history TO anon;
GRANT ALL ON TABLE public.order_status_history TO authenticated;
GRANT ALL ON TABLE public.order_status_history TO service_role;


--
-- Name: SEQUENCE order_status_history_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.order_status_history_id_seq TO anon;
GRANT ALL ON SEQUENCE public.order_status_history_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.order_status_history_id_seq TO service_role;


--
-- Name: TABLE orders; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.orders TO anon;
GRANT ALL ON TABLE public.orders TO authenticated;
GRANT ALL ON TABLE public.orders TO service_role;


--
-- Name: TABLE payments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.payments TO anon;
GRANT ALL ON TABLE public.payments TO authenticated;
GRANT ALL ON TABLE public.payments TO service_role;


--
-- Name: TABLE price_overrides; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.price_overrides TO anon;
GRANT ALL ON TABLE public.price_overrides TO authenticated;
GRANT ALL ON TABLE public.price_overrides TO service_role;


--
-- Name: TABLE product_images; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.product_images TO anon;
GRANT ALL ON TABLE public.product_images TO authenticated;
GRANT ALL ON TABLE public.product_images TO service_role;


--
-- Name: TABLE products; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.products TO anon;
GRANT ALL ON TABLE public.products TO authenticated;
GRANT ALL ON TABLE public.products TO service_role;


--
-- Name: TABLE user_profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_profiles TO anon;
GRANT ALL ON TABLE public.user_profiles TO authenticated;
GRANT ALL ON TABLE public.user_profiles TO service_role;


--
-- Name: TABLE v_effective_prices; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_effective_prices TO anon;
GRANT ALL ON TABLE public.v_effective_prices TO authenticated;
GRANT ALL ON TABLE public.v_effective_prices TO service_role;


--
-- Name: TABLE webhook_events; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.webhook_events TO anon;
GRANT ALL ON TABLE public.webhook_events TO authenticated;
GRANT ALL ON TABLE public.webhook_events TO service_role;


--
-- Name: SEQUENCE webhook_events_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.webhook_events_id_seq TO anon;
GRANT ALL ON SEQUENCE public.webhook_events_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.webhook_events_id_seq TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

\unrestrict bOkjDpGfbRrddwoJbSzGXMehkl7yPZo1gWJNt4ibpfHptiB08MUujsK9CpTDem7

--
-- PostgreSQL database cluster dump complete
--

