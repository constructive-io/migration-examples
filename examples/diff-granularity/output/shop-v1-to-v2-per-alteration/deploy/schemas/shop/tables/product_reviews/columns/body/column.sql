-- Deploy: schemas/shop/tables/product_reviews/columns/body/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/tables/product_reviews/table


ALTER TABLE shop.product_reviews 
  ADD COLUMN body text;

