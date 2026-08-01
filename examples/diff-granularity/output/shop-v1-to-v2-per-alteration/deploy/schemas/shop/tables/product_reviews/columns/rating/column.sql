-- Deploy: schemas/shop/tables/product_reviews/columns/rating/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/tables/product_reviews/table


ALTER TABLE shop.product_reviews 
  ADD COLUMN rating int
    NOT NULL;

