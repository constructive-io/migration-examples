-- Deploy: schemas/shop/tables/customers/constraints/customers_pkey/constraint
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/customers/table
-- requires: schemas/shop/tables/customers/columns/id/column


ALTER TABLE ONLY shop.customers 
  ADD CONSTRAINT customers_pkey PRIMARY KEY (id);

