-- Deploy: schemas/shop/tables/order_items/constraints/order_items_pkey
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/order_items/table
-- requires: schemas/shop/tables/order_items/columns/id


ALTER TABLE ONLY shop.order_items 
  ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);

