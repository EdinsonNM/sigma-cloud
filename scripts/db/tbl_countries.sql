/* scripts/db/tbl_countries.sql */

CREATE TABLE IF NOT EXISTS countries (
	id		character varying(12) NOT NULL,
	prnt	character varying(12) NOT NULL,
	name 	character varying(44) NOT NULL,
	iso 	character varying(2) NOT NULL,
	ccode	character varying(3) NOT NULL, -- currency code
	cname	character varying(13) NOT NULL, -- currency name
	pcoderx	character varying(111) NOT NULL, -- postal code regex
	langs	character varying(89) NOT NULL,
	CONSTRAINT pk_countries_id PRIMARY KEY ( id ),
	FOREIGN KEY (prnt) REFERENCES countries (id)
);
