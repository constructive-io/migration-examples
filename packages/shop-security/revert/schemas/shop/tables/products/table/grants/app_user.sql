-- Revert: schemas/shop/tables/products/table/grants/app_user


REVOKE SELECT ON shop.products FROM app_user RESTRICT;


