-- Verify: schemas/audit/procedures/log_order_change


SELECT 1/(CASE WHEN to_regprocedure('audit.log_order_change()') IS NOT NULL THEN 1 ELSE 0 END);


