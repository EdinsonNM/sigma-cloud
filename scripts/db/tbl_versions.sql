/* scripts/db/tbl_versions.sql */

CREATE TABLE IF NOT EXISTS versions (
	ver			text,
	status		integer,
	created		double  precision NOT NULL,
	CONSTRAINT pk_versions_id PRIMARY KEY ( ver )
);

DROP INDEX IF EXISTS idx_versions_created;
CREATE INDEX idx_versions_created ON versions (created);

DROP TRIGGER IF EXISTS tr_versions_ins0 on versions;
CREATE TRIGGER tr_versions_ins0
	BEFORE INSERT ON versions
	FOR EACH ROW EXECUTE PROCEDURE ins_created_ts_no_modified();
