-- Deploy: schemas/shop/tables/products/table/grants/app_user
-- made with <3 @ constructive.io

-- requires: shop-app:schemas/shop/schema
-- requires: shop-app:schemas/shop/tables/products/table


GRANT SELECT ON shop.products TO app_user;

