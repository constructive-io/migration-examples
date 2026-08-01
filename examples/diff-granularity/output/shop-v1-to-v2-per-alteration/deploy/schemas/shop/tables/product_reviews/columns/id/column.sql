-- Deploy: schemas/shop/tables/product_reviews/columns/id/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/tables/product_reviews/table


ALTER TABLE shop.product_reviews 
  ADD COLUMN id uuid
    DEFAULT gen_random_uuid()
    NOT NULL;

