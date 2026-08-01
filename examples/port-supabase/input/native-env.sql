-- Minimal stand-in for the vendor's managed environment: the native auth
-- subsystem surface (auth.users + auth.uid()) and the extensions schema.
-- On a real Supabase stack all of this already exists; the ported-back
-- module deploys straight on top of it.
BEGIN;

CREATE SCHEMA auth;

CREATE TABLE auth.users (
  id uuid PRIMARY KEY
);

CREATE FUNCTION auth.uid() RETURNS uuid AS $$
  SELECT nullif(current_setting('request.jwt.claim.sub', true), '')::uuid;
$$ LANGUAGE sql STABLE;

CREATE SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" SCHEMA extensions;

COMMIT;
