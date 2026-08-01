-- Verify: schemas/audit/tables/change_log/table


SELECT 1/(CASE WHEN to_regclass('audit.change_log') IS NOT NULL THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'change_log' AND column_name = 'id' AND table_schema = 'audit') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'change_log' AND column_name = 'table_name' AND table_schema = 'audit') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'change_log' AND column_name = 'row_id' AND table_schema = 'audit') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'change_log' AND column_name = 'operation' AND table_schema = 'audit') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'change_log' AND column_name = 'changed_at' AND table_schema = 'audit') THEN 1 ELSE 0 END);

SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'change_log' AND constraint_name = 'change_log_pkey' AND table_schema = 'audit') THEN 1 ELSE 0 END);


