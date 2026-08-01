-- Deploy: schemas/shop/tables/customers/columns/full_name/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/customers/table


ALTER TABLE shop.customers 
  ADD COLUMN full_name text
    NOT NULL;

