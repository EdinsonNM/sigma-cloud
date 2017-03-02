/* scripts/db/0/1/0/tbl_users.sql */

CREATE TABLE IF NOT EXISTS users (
	uid			integer NOT NULL,
	profile		json,
	created		double precision NOT NULL,
	createdBy	double precision NOT NULL,
	modified	double precision NOT NULL,
	modifiedBy	double precision NOT NULL
	--,CONSTRAINT pk_users_id PRIMARY KEY ( uid )
);

DROP INDEX IF EXISTS idx_users_audit;
CREATE INDEX idx_users_audit ON users USING btree (created,createdBy,modified,modifiedBy);

DROP TRIGGER IF EXISTS tr_users_ins0 ON users;
CREATE TRIGGER tr_users_ins0
	BEFORE INSERT ON users
	FOR EACH ROW EXECUTE PROCEDURE ins_audit_data();
