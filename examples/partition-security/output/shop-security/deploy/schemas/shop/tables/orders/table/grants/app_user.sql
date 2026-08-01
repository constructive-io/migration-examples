-- Deploy: schemas/shop/tables/orders/table/grants/app_user
-- made with <3 @ constructive.io

-- requires: shop-app:schemas/shop/schema
-- requires: shop-app:schemas/shop/tables/orders/table
-- requires: shop-app:schemas/shop/tables/orders/constraints/orders/constraint


GRANT SELECT, INSERT, UPDATE ON shop.orders TO app_user;

