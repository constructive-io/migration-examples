-- Deploy: schemas/audit/tables/change_log/columns/changed_at
-- made with <3 @ constructive.io

-- requires: schemas/audit/schema
-- requires: schemas/audit/tables/change_log/table


ALTER TABLE audit.change_log 
  ADD COLUMN changed_at timestamptz
    DEFAULT now()
    NOT NULL;

