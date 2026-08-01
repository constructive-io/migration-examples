-- Deploy: schemas/shop/tables/orders/constraints/orders_pkey/constraint
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/orders/table
-- requires: schemas/shop/tables/orders/columns/id/column


ALTER TABLE ONLY shop.orders 
  ADD CONSTRAINT orders_pkey PRIMARY KEY (id);

