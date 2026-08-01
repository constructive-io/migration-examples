-- Revert: schemas/audit/tables/change_log/columns/row_id


ALTER TABLE audit.change_log 
  DROP COLUMN row_id RESTRICT;


