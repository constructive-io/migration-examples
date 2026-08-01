-- Deploy: schemas/audit/tables/change_log/table
-- made with <3 @ constructive.io

-- requires: schemas/audit/schema


CREATE TABLE audit.change_log (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  table_name text NOT NULL,
  row_id uuid NOT NULL,
  operation text NOT NULL,
  changed_at timestamptz DEFAULT now() NOT NULL,
  CONSTRAINT change_log_pkey PRIMARY KEY (id)
);

