-- Revert: schemas/shop/tables/customers/table/grants/app_user


REVOKE SELECT ON shop.customers FROM app_user RESTRICT;


