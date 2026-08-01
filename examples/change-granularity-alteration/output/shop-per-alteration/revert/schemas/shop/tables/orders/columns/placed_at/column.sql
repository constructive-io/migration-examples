-- Revert: schemas/shop/tables/orders/columns/placed_at/column


ALTER TABLE shop.orders 
  DROP COLUMN placed_at RESTRICT;


