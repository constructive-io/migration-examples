-- Deploy: schemas/inventory/tables/warehouses/table
-- made with <3 @ constructive.io

-- requires: schemas/inventory/schema


CREATE TABLE inventory.warehouses (
  id serial PRIMARY KEY,
  name text NOT NULL
);

