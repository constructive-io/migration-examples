-- Revert: schemas/shop/tables/order_items/columns/unit_price_cents/column


ALTER TABLE shop.order_items 
  DROP COLUMN unit_price_cents RESTRICT;


