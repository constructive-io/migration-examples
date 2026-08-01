-- Revert: schemas/shop/tables/orders/constraints/orders_customer_id_fkey/constraint


ALTER TABLE ONLY shop.orders 
  DROP CONSTRAINT orders_customer_id_fkey RESTRICT;


