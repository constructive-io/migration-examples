-- Revert: schemas/shop/tables/customers/table/alter


ALTER TABLE shop.customers ADD COLUMN phone text;
ALTER TABLE shop.customers DROP COLUMN marketing_opt_in RESTRICT;


