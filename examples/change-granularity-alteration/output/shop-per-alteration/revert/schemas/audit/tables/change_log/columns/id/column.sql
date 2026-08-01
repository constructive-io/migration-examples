-- Revert: schemas/audit/tables/change_log/columns/id/column


ALTER TABLE audit.change_log 
  DROP COLUMN id RESTRICT;


