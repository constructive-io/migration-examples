-- Revert: schemas/shop/tables/orders/columns/id


ALTER TABLE shop.orders 
  DROP COLUMN id RESTRICT;


