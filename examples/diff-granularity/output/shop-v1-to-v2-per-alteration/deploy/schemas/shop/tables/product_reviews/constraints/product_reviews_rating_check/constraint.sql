-- Deploy: schemas/shop/tables/product_reviews/constraints/product_reviews_rating_check/constraint
-- made with <3 @ constructive.io

-- requires: schemas/shop/tables/product_reviews/table


ALTER TABLE shop.product_reviews 
  ADD CONSTRAINT product_reviews_rating_check 
    CHECK (
    rating >= 1
      AND rating <= 5
  );

