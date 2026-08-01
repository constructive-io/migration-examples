-- Revert: schemas/shop/tables/product_reviews/constraints/product_reviews_product_id_fkey/constraint


ALTER TABLE ONLY shop.product_reviews DROP CONSTRAINT product_reviews_product_id_fkey RESTRICT;


