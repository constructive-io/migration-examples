-- Revert: schemas/audit/tables/change_log/columns/changed_at


ALTER TABLE audit.change_log 
  DROP COLUMN changed_at RESTRICT;


