-- Deploy: schemas/shop/tables/product_reviews/indexes/idx_product_reviews_product_id
-- made with <3 @ constructive.io

-- requires: schemas/shop/tables/product_reviews/constraints/product_reviews_customer_id_fkey/constraint


CREATE INDEX idx_product_reviews_product_id ON shop.product_reviews (product_id);

