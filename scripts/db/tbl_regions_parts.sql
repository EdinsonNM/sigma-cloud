/* scripts/db/tbl_regions_parts.sql */

/* US */
CREATE TABLE regions_US (
	CHECK ( country = 'US' )
) INHERITS (regions);
CREATE INDEX idx_regions_US_bounds ON regions_US USING GIST ( bounds );
CREATE INDEX idx_regions_US_boundsm ON regions_US USING GIST ( boundsm );

/* US_CA */
CREATE TABLE regions_US_CA (
	CHECK ( country = 'US_CA' )
) INHERITS (regions);
CREATE INDEX idx_regions_US_CA_bounds ON regions_US_CA USING GIST ( bounds );
CREATE INDEX idx_regions_US_CA_boundsm ON regions_US_CA USING GIST ( boundsm );

/* US_CA_LA */
CREATE TABLE regions_US_CA_LA (
	CHECK ( country = 'US_CA_LA' )
) INHERITS (regions_CA);
CREATE INDEX idx_regions_US_CA_LA_bounds ON regions_US_CA_LA USING GIST ( bounds );
CREATE INDEX idx_regions_US_CA_LA_boundsm ON regions_US_CA_LA USING GIST ( boundsm );



/* PE */
CREATE TABLE regions_PE (
	CHECK ( country = 'PE' )
) INHERITS (regions);
CREATE INDEX idx_regions_PE_bounds ON regions_PE USING GIST ( bounds );
CREATE INDEX idx_regions_PE_boundsm ON regions_PE USING GIST ( boundsm );

/* PE_LIMA */
CREATE TABLE regions_PE_LIMA (
	CHECK ( country = 'PE_LIMA' )
) INHERITS (regions_PE);
CREATE INDEX idx_regions_PE_LIMA_bounds ON regions_PE_LIMA USING GIST ( bounds );
CREATE INDEX idx_regions_PE_LIMA_boundsm ON regions_PE_LIMA USING GIST ( boundsm );

/* PE_LIMA_LIMA */
CREATE TABLE regions_PE_LIMA_LIMA (
	CHECK ( country = 'PE_LIMA_LIMA' )
) INHERITS (regions_PE_LIMA);
CREATE INDEX idx_regions_PE_LIMA_LIMA_bounds ON regions_PE_LIMA_LIMA USING GIST ( bounds );
CREATE INDEX idx_regions_PE_LIMA_LIMA_boundsm ON regions_PE_LIMA_LIMA USING GIST ( boundsm );
