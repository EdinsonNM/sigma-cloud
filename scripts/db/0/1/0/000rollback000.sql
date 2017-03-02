/* scripts/db/0/1/0/rollback.sql */

DROP FUNCTION IF EXISTS fn_get_user;
DROP FUNCTION IF EXISTS fn_put_user;
DROP TABLE IF EXISTS users;
