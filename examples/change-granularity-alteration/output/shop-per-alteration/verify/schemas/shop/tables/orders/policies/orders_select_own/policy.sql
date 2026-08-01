-- Verify: schemas/shop/tables/orders/policies/orders_select_own/policy


SELECT 1/(CASE WHEN EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'orders_select_own' AND tablename = 'orders' AND schemaname = 'shop') THEN 1 ELSE 0 END);


