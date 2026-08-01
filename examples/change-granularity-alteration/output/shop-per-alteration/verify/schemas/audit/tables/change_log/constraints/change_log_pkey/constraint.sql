-- Verify: schemas/audit/tables/change_log/constraints/change_log_pkey/constraint


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'change_log' AND constraint_name = 'change_log_pkey' AND table_schema = 'audit') THEN 1 ELSE 0 END);


