-- Deploy: schemas/shop/schema
-- made with <3 @ constructive.io




CREATE SCHEMA shop;

COMMENT ON SCHEMA shop IS 'Storefront: customers, products, orders.';

GRANT USAGE ON SCHEMA shop TO app_user;

