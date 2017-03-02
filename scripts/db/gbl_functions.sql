/* gbl_functions.sql */

CREATE OR REPLACE FUNCTION get_timestamp()
RETURNS double precision
AS
$$
	SELECT ( FLOOR(EXTRACT(EPOCH FROM clock_timestamp()) * 1000) :: double precision );
$$
LANGUAGE SQL VOLATILE;


CREATE OR REPLACE FUNCTION update_modified_timestamp()
	RETURNS TRIGGER AS $$
	BEGIN
		NEW.modified = get_timestamp();
		RETURN NEW;
	END;
	$$ language 'plpgsql';

CREATE OR REPLACE FUNCTION insert_created_timestamp()
	RETURNS TRIGGER AS $$
	DECLARE timestmp double precision;
	BEGIN
		timestmp = get_timestamp();
		NEW.created = timestmp;
		NEW.modified = timestmp;
		RETURN NEW;
	END;
	$$ language 'plpgsql';

CREATE OR REPLACE FUNCTION ins_created_ts_no_modified()
	RETURNS TRIGGER AS $$
	DECLARE timestmp double precision;
	BEGIN
		timestmp = get_timestamp();
		NEW.created = timestmp;
		RETURN NEW;
	END;
	$$ language 'plpgsql';

CREATE OR REPLACE FUNCTION ins_audit_data()
	RETURNS TRIGGER AS $$
	DECLARE timestmp double precision;
	BEGIN
		timestmp = get_timestamp();
		NEW.created = COALESCE(NEW.created,timestmp);
		NEW.modified = COALESCE(NEW.created,timestmp);
		IF NEW.modifiedBy IS NULL
			THEN NEW.modifiedBy = NEW.createdBy;
		END IF;
		RETURN NEW;
	END;
	$$ language 'plpgsql';
