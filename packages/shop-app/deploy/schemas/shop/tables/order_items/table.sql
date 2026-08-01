-- Deploy: schemas/shop/tables/order_items/table
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema


CREATE TABLE shop.order_items (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  order_id uuid NOT NULL,
  product_id uuid NOT NULL,
  quantity int DEFAULT 1 NOT NULL,
  unit_price_cents int NOT NULL,
  CONSTRAINT order_items_pkey PRIMARY KEY (id)
);

