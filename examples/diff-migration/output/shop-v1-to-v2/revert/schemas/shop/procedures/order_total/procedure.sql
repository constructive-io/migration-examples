-- Revert: schemas/shop/procedures/order_total/procedure


COMMENT ON FUNCTION shop.order_total(p_order_id uuid) IS NULL;
DROP FUNCTION shop.order_total(uuid);
CREATE FUNCTION shop.order_total(
  p_order_id uuid
) RETURNS int LANGUAGE sql STABLE AS $$
  SELECT COALESCE(SUM(quantity * unit_price_cents), 0)::integer
  FROM shop.order_items
  WHERE order_id = p_order_id;
$$;
COMMENT ON FUNCTION shop.order_total(p_order_id uuid) IS 'Sum of line totals for an order, in cents.';


