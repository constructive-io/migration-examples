-- Deploy: schemas/audit/tables/change_log/columns/row_id/column
-- made with <3 @ constructive.io

-- requires: schemas/audit/schema
-- requires: schemas/audit/tables/change_log/table


ALTER TABLE audit.change_log 
  ADD COLUMN row_id uuid
    NOT NULL;

