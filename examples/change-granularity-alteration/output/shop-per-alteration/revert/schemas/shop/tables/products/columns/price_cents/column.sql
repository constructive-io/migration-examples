-- Revert: schemas/shop/tables/products/columns/price_cents/column


ALTER TABLE shop.products 
  DROP COLUMN price_cents RESTRICT;


