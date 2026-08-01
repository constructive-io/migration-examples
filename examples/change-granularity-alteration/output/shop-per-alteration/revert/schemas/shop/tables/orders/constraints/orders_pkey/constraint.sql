-- Revert: schemas/shop/tables/orders/constraints/orders_pkey/constraint


ALTER TABLE ONLY shop.orders 
  DROP CONSTRAINT orders_pkey RESTRICT;


