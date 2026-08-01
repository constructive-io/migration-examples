-- Revert: schemas/shop/tables/products/columns/description


ALTER TABLE shop.products 
  DROP COLUMN description RESTRICT;


