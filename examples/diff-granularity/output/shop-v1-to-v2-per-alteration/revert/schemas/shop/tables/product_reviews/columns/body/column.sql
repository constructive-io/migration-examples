-- Revert: schemas/shop/tables/product_reviews/columns/body/column


ALTER TABLE shop.product_reviews DROP COLUMN body RESTRICT;


