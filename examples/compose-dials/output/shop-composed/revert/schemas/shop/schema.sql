-- Revert: schemas/shop/schema


REVOKE USAGE ON SCHEMA shop FROM app_user RESTRICT;

COMMENT ON SCHEMA shop IS NULL;

DROP SCHEMA shop;


