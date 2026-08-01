-- Deploy: schemas/shop/tables/order_items/table/grants/app_user
-- made with <3 @ constructive.io

-- requires: shop-app:schemas/shop/schema
-- requires: shop-app:schemas/shop/tables/order_items/table
-- requires: shop-app:schemas/shop/tables/order_items/constraints/order_items/constraint


GRANT SELECT, INSERT ON shop.order_items TO app_user;

