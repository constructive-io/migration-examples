-- Deploy: schemas/shop/tables/products/constraints/products_sku_key/constraint
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/products/table
-- requires: schemas/shop/tables/products/columns/sku/column


ALTER TABLE ONLY shop.products 
  ADD CONSTRAINT products_sku_key 
    UNIQUE (sku);

