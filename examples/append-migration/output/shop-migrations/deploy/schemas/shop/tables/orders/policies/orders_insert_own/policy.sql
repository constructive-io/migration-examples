-- Deploy: schemas/shop/tables/orders/policies/orders_insert_own/policy
-- made with <3 @ constructive.io




CREATE POLICY orders_insert_own
  ON shop.orders
  AS PERMISSIVE
  FOR INSERT
  TO PUBLIC
  WITH CHECK (
    customer_id = (current_setting('app.current_customer_id', true))::uuid
  );

