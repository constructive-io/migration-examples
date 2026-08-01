-- Deploy: schemas/audit/tables/change_log/columns/id
-- made with <3 @ constructive.io

-- requires: schemas/audit/schema
-- requires: schemas/audit/tables/change_log/table


ALTER TABLE audit.change_log 
  ADD COLUMN id bigint
    GENERATED ALWAYS AS IDENTITY
    NOT NULL;

