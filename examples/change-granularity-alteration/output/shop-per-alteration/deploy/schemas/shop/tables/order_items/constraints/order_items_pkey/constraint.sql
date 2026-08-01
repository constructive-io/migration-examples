-- Deploy: schemas/shop/tables/order_items/constraints/order_items_pkey/constraint
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/order_items/table
-- requires: schemas/shop/tables/order_items/columns/id/column


ALTER TABLE ONLY shop.order_items 
  ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);

