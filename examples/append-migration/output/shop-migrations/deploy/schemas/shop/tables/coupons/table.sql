-- Deploy: schemas/shop/tables/coupons/table
-- made with <3 @ constructive.io




CREATE TABLE shop.coupons (
  code text NOT NULL,
  percent_off int NOT NULL,
  expires_at timestamptz,
  CONSTRAINT coupons_pkey PRIMARY KEY (code)
);

COMMENT ON TABLE shop.coupons IS 'Discount coupons applied at checkout.';

