-- Deploy: schemas/audit/tables/change_log/table
-- made with <3 @ constructive.io

-- requires: schemas/audit/schema


CREATE TABLE audit.change_log (

);

ALTER TABLE audit.change_log 
  ADD COLUMN id bigint
    GENERATED ALWAYS AS IDENTITY
    NOT NULL;

ALTER TABLE audit.change_log 
  ADD COLUMN table_name text
    NOT NULL;

ALTER TABLE audit.change_log 
  ADD COLUMN row_id uuid
    NOT NULL;

ALTER TABLE audit.change_log 
  ADD COLUMN operation text
    NOT NULL;

ALTER TABLE audit.change_log 
  ADD COLUMN changed_at timestamptz
    DEFAULT now()
    NOT NULL;

ALTER TABLE audit.change_log 
  ADD CONSTRAINT change_log_pkey PRIMARY KEY (id);

