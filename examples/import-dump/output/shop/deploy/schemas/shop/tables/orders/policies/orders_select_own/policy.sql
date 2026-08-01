-- Deploy: schemas/shop/tables/orders/policies/orders_select_own/policy
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/orders/table


CREATE POLICY orders_select_own
  ON shop.orders
  AS PERMISSIVE
  FOR SELECT
  TO PUBLIC
  USING (
    customer_id = (current_setting('app.current_customer_id', true))::uuid
  );

