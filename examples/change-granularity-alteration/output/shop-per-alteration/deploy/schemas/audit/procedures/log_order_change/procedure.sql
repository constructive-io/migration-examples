-- Deploy: schemas/audit/procedures/log_order_change/procedure
-- made with <3 @ constructive.io

-- requires: schemas/audit/schema


CREATE FUNCTION audit.log_order_change() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO audit.change_log (table_name, row_id, operation)
  VALUES (TG_TABLE_NAME, NEW.id, TG_OP);
  RETURN NEW;
END;
$$;

