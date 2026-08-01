-- Revert: schemas/shop/tables/product_reviews/columns/rating/column


ALTER TABLE shop.product_reviews DROP COLUMN rating RESTRICT;


