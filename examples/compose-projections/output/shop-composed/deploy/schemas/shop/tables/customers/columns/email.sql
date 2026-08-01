-- Deploy: schemas/shop/tables/customers/columns/email
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/customers/table


ALTER TABLE shop.customers 
  ADD COLUMN email text
    NOT NULL;

