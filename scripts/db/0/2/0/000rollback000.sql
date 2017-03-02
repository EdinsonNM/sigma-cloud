/* scripts/db/0/3/22/rollback.sql */

ALTER TABLE IF EXISTS users ALTER COLUMN profile json;
ALTER TABLE IF EXISTS users DROP CONSTRAINT pk_users_id;

DROP FUNCTION IF EXISTS fn_get_privilege(integer);
DROP FUNCTION IF EXISTS fn_put_privilege(text,integer,integer);

DROP TABLE IF EXISTS tbl_privileged;
