-- Deploy: schemas/shop/sequences/order_number_seq
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema


CREATE SEQUENCE shop.order_number_seq START 1000 INCREMENT 1 NO MINVALUE NO MAXVALUE CACHE 1;

