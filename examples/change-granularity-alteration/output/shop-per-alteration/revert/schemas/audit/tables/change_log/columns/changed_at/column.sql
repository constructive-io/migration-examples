-- Revert: schemas/audit/tables/change_log/columns/changed_at/column


ALTER TABLE audit.change_log 
  DROP COLUMN changed_at RESTRICT;


