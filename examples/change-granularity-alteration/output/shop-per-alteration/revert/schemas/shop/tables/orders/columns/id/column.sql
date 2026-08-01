-- Revert: schemas/shop/tables/orders/columns/id/column


ALTER TABLE shop.orders 
  DROP COLUMN id RESTRICT;


