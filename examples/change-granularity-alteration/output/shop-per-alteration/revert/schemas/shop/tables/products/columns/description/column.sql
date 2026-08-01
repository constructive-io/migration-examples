-- Revert: schemas/shop/tables/products/columns/description/column


ALTER TABLE shop.products 
  DROP COLUMN description RESTRICT;


