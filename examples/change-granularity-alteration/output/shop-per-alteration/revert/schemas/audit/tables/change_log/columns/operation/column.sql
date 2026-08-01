-- Revert: schemas/audit/tables/change_log/columns/operation/column


ALTER TABLE audit.change_log 
  DROP COLUMN operation RESTRICT;


