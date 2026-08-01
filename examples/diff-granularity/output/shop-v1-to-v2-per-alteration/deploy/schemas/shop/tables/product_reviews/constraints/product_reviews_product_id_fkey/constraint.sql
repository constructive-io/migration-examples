-- Deploy: schemas/shop/tables/product_reviews/constraints/product_reviews_product_id_fkey/constraint
-- made with <3 @ constructive.io

-- requires: schemas/shop/tables/product_reviews/table
-- requires: schemas/shop/tables/product_reviews/columns/product_id/column


ALTER TABLE ONLY shop.product_reviews 
  ADD CONSTRAINT product_reviews_product_id_fkey
    FOREIGN KEY(product_id)
    REFERENCES shop.products (id)
    ON DELETE CASCADE;

