/* tbl_privileged.sql */

CREATE TABLE IF NOT EXISTS privileged (
	uid			integer NOT NULL,
	roles		integer	NOT NULL,
	createdBy	double precision NOT NULL,
	created		double precision NOT NULL,
	modifiedBy	double precision NOT NULL,
	modified	double precision NOT NULL,
	CONSTRAINT pk_privileged_id PRIMARY KEY ( uid )
);

DROP INDEX IF EXISTS idx_privileged_createdBy;
CREATE INDEX idx_privileged_createdBy ON privileged USING btree (createdBy);

DROP INDEX IF EXISTS idx_privileged_audit;
CREATE INDEX idx_privileged_audit ON privileged USING btree (created, createdBy, modified, modifiedBy);

DROP TRIGGER IF EXISTS tr_privileged_insert0 ON privileged;
CREATE TRIGGER tr_privileged_insert0
	BEFORE INSERT ON privileged
	FOR EACH ROW EXECUTE PROCEDURE ins_audit_data();

DROP TRIGGER IF EXISTS tr_privileged_update ON privileged;
CREATE TRIGGER tr_privileged_update
	AFTER UPDATE ON privileged
	-- WHEN (OLD.* IS DISTINCT FROM NEW.*)
	FOR EACH ROW EXECUTE PROCEDURE update_modified_timestamp();
