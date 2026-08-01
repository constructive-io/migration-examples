-- Revert: schemas/shop/tables/orders/table/grants/app_user


REVOKE SELECT, INSERT, UPDATE ON shop.orders FROM app_user RESTRICT;


