-- Revert: schemas/shop/tables/order_items/table/grants/app_user


REVOKE SELECT, INSERT ON shop.order_items FROM app_user RESTRICT;


