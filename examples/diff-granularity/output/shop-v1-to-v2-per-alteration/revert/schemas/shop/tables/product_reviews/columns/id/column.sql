-- Revert: schemas/shop/tables/product_reviews/columns/id/column


ALTER TABLE shop.product_reviews DROP COLUMN id RESTRICT;


