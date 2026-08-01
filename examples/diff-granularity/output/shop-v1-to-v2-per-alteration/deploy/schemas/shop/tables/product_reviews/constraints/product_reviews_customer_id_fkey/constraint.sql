-- Deploy: schemas/shop/tables/product_reviews/constraints/product_reviews_customer_id_fkey/constraint
-- made with <3 @ constructive.io

-- requires: schemas/shop/tables/product_reviews/table
-- requires: schemas/shop/tables/product_reviews/columns/customer_id/column


ALTER TABLE ONLY shop.product_reviews 
  ADD CONSTRAINT product_reviews_customer_id_fkey
    FOREIGN KEY(customer_id)
    REFERENCES shop.customers (id);

COMMENT ON TABLE shop.product_reviews IS 'Customer product reviews, 1-5 stars.';

GRANT SELECT, INSERT ON shop.product_reviews TO app_user;

