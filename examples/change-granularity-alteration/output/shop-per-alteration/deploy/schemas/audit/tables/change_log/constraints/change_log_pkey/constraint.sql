-- Deploy: schemas/audit/tables/change_log/constraints/change_log_pkey/constraint
-- made with <3 @ constructive.io

-- requires: schemas/audit/schema
-- requires: schemas/audit/tables/change_log/table
-- requires: schemas/audit/tables/change_log/columns/id/column


ALTER TABLE ONLY audit.change_log 
  ADD CONSTRAINT change_log_pkey PRIMARY KEY (id);

