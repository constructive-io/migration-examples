-- Deploy: schemas/shop/tables/customers/table/grants/app_user
-- made with <3 @ constructive.io

-- requires: shop-app:schemas/shop/schema
-- requires: shop-app:schemas/shop/tables/customers/table


GRANT SELECT ON shop.customers TO app_user;

