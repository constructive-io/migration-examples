-- Verify: schemas/audit/tables/change_log/columns/changed_at/column


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'change_log' AND column_name = 'changed_at' AND table_schema = 'audit') THEN 1 ELSE 0 END);


