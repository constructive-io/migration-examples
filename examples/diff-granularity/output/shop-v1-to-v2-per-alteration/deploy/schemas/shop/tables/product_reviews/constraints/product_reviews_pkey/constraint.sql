-- Deploy: schemas/shop/tables/product_reviews/constraints/product_reviews_pkey/constraint
-- made with <3 @ constructive.io

-- requires: schemas/shop/tables/product_reviews/table
-- requires: schemas/shop/tables/product_reviews/columns/id/column


ALTER TABLE shop.product_reviews 
  ADD CONSTRAINT product_reviews_pkey PRIMARY KEY (id);

