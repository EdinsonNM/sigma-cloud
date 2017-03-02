/* scripts/db/tbl_regions.sql */

CREATE TABLE IF NOT EXISTS regions (
	gid			bigint NOT NULL,
	name		text NOT NULL,
	country		char(2) NOT NULL,
	bounds		GEOGRAPHY(POLYGON,4326),
	boundsm		GEOGRAPHY(MULTIPOLYGON,4326),
	CONSTRAINT pk_regions_id PRIMARY KEY ( id )
);

CREATE INDEX idx_regions_bounds ON regions USING GIST ( bounds );

CREATE INDEX idx_regions_boundsm ON regions USING GIST ( boundsm );

CREATE OR REPLACE FUNCTION fntr_regions_ins0()
RETURNS TRIGGER AS $$
BEGIN
	CASE WHEN country = 'US' THEN INSERT INTO regions_US (NEW.*);
	CASE WHEN country = 'PE' THEN INSERT INTO regions_PE (NEW.*);
	ELSE RAISE EXCEPTION 'i dunno later';
	END
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;
