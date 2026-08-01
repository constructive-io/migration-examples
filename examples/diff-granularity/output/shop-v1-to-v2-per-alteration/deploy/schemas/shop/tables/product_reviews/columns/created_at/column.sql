-- Deploy: schemas/shop/tables/product_reviews/columns/created_at/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/tables/product_reviews/table


ALTER TABLE shop.product_reviews 
  ADD COLUMN created_at timestamptz
    DEFAULT now()
    NOT NULL;

