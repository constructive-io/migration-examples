-- Revert: schemas/audit/tables/change_log/constraints/change_log_pkey


ALTER TABLE ONLY audit.change_log 
  DROP CONSTRAINT change_log_pkey RESTRICT;


