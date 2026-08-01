-- Deploy: schemas/audit/tables/change_log/columns/operation/column
-- made with <3 @ constructive.io

-- requires: schemas/audit/schema
-- requires: schemas/audit/tables/change_log/table


ALTER TABLE audit.change_log 
  ADD COLUMN operation text
    NOT NULL;

