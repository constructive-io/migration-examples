-- Deploy: schemas/shop/tables/customers/table/alter
-- made with <3 @ constructive.io




ALTER TABLE shop.customers ADD COLUMN marketing_opt_in boolean DEFAULT false NOT NULL;
ALTER TABLE shop.customers DROP COLUMN phone RESTRICT;

