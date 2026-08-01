-- Revert: schemas/audit/tables/change_log/columns/table_name/column


ALTER TABLE audit.change_log 
  DROP COLUMN table_name RESTRICT;


