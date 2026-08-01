-- Deploy: schemas/shop/tables/products/constraints/products_pkey/constraint
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/products/table
-- requires: schemas/shop/tables/products/columns/id/column


ALTER TABLE ONLY shop.products 
  ADD CONSTRAINT products_pkey PRIMARY KEY (id);

