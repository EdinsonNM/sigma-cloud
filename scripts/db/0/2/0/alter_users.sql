/* scripts/db/0/3/22/alter_fbusers.sql */

ALTER TABLE IF EXISTS users ALTER COLUMN profile jsonb;
ALTER TABLE IF EXISTS fbusers ADD CONSTRAINT pk_users_id PRIMARY KEY ( uid );
