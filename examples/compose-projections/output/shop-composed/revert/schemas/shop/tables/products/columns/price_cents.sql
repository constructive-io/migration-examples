-- Revert: schemas/shop/tables/products/columns/price_cents


ALTER TABLE shop.products 
  DROP COLUMN price_cents RESTRICT;


