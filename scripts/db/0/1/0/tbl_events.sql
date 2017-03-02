/* scripts/db/0/1/0/tbl_events.sql */

CREATE TABLE IF NOT EXISTS events (
	eid	bigserial NOT NULL,
	pub	bigint DEFAULT 0,
	lct	integer NOT NULL,
	lcl	smallint DEFAULT 0,
	ini	bigint NOT NULL,
	dur	integer DEFAULT 3600,
	rpt	jsonb DEFAULT '{}'::jsonb,
	tag	bigint[] DEFAULT '{}',
	tst	varchar(280) NOT NULL, -- title(24) + short(256)
	prc	decimal DEFAULT 0.00,
	ref	text,
	img	bigint,
	cre	bigint NOT NULL,
	crb	bigint NOT NULL,
	mod	bigint NOT NULL,
	mob	bigint NOT NULL
	own	bigint NOT NULL,
	CONSTRAINT pk_events_id PRIMARY KEY ( eid )
);

DROP INDEX IF EXISTS idx_events_audit;
CREATE INDEX idx_users_audit ON events USING btree (cre,crb,mod,mob);

DROP TRIGGER IF EXISTS tr_events_ins0 ON events;
CREATE TRIGGER tr_events_ins0
	BEFORE INSERT ON events
	FOR EACH ROW EXECUTE PROCEDURE ins_audit_data();

DROP TRIGGER IF EXISTS tr_events_upd1 ON events;
CREATE TRIGGER tr_events_upd1
	AFTER UPDATE ON events
	FOR EACH ROW EXECUTE PROCEDURE update_modified_timestamp();


CREATE TABLE IF NOT EXISTS en_events ( LIKE events INCLUDING ALL );
ALTER TABLE en_events ADD CONSTRAINT chk_locale_en CHECK ( lcl < 16 );
ALTER TABLE en_events INHERIT events;
CREATE INDEX idx_en_events_tsvector ON en_events ( to_tsvector('english',tst) );
--http://rachbelaid.com/postgres-full-text-search-is-good-enough/

CREATE TABLE IF NOT EXISTS en_US_events ( LIKE events INCLUDING ALL );
ALTER TABLE en_US_events ADD CONSTRAINT chk_locale_en_US CHECK ( lcl = 0 );
ALTER TABLE en_US_events INHERIT en_events;




CREATE TABLE IF NOT EXISTS es_events ( LIKE events INCLUDING ALL );
ALTER TABLE es_events ADD CONSTRAINT chk_locale_es CHECK ( lcl > 15 AND lcl < 26 );
ALTER TABLE es_events INHERIT events;
CREATE INDEX idx_en_events_tsvector ON es_events ( to_tsvector('spanish',tst) );


CREATE TABLE IF NOT EXISTS es_PE_events ( LIKE events INCLUDING ALL );
ALTER TABLE es_PE_events ADD CONSTRAINT chk_locale_en_US CHECK ( lcl = 16 );
ALTER TABLE es_PE_events INHERIT es_events;


/* NOTE: does this need to be a trigger if we *never* insert directly to tables?
CREATE OR REPLACE FUNCTION route_event_trigger()
RETURNS TRIGGER AS $$
BEGIN
	CASE
		WHEN NEW.lcl =  0 THEN INSERT INTO en_US_events VALUES (NEW.*);
		WHEN NEW.lcl =  1 THEN INSERT INTO en_XX_events VALUES (NEW.*);
		WHEN NEW.lcl = 25 THEN INSERT INTO es_PE_events VALUES (NEW.*);
		ELSE
		RAISE EXCEPTION 'Date out of range.  Fix the measurement_insert_trigger() function!';
	END
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;


CREATE TRIGGER tr_events_ins1
	BEFORE INSERT ON events
	FOR EACH ROW EXECUTE PROCEDURE route_event_trigger();
*/
