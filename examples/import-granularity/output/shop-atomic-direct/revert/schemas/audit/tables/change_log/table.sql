-- Revert: schemas/audit/tables/change_log/table


ALTER TABLE ONLY audit.change_log 
  DROP CONSTRAINT change_log_pkey RESTRICT;

ALTER TABLE audit.change_log 
  DROP COLUMN changed_at RESTRICT;

ALTER TABLE audit.change_log 
  DROP COLUMN operation RESTRICT;

ALTER TABLE audit.change_log 
  DROP COLUMN row_id RESTRICT;

ALTER TABLE audit.change_log 
  DROP COLUMN table_name RESTRICT;

ALTER TABLE audit.change_log 
  DROP COLUMN id RESTRICT;

DROP TABLE audit.change_log;


