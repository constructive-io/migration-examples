-- Verify: schemas/audit/tables/change_log/table


SELECT 1/(CASE WHEN to_regclass('audit.change_log') IS NOT NULL THEN 1 ELSE 0 END);


