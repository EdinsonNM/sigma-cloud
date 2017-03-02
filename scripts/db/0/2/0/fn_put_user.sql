/* scripts/db/0/2/0/fn_put_user.sql */

CREATE OR REPLACE FUNCTION fn_put_user (
	P_uid	integer,
	P_me	json,
	P_modifiedby integer,
	P_created integer
) RETURNS json AS $$

DECLARE fd RECORD;
DECLARE p_fbtfb text;

BEGIN

	CASE
		WHEN P_uid IS NULL THEN RAISE not_null_violation USING MESSAGE = 'P_uid parameter is required.';
		WHEN P_me IS NULL THEN RAISE not_null_violation USING MESSAGE = 'P_me parameter is required.';
		WHEN P_modifiedby IS NULL THEN RAISE not_null_violation USING MESSAGE = 'P_modifiedby is required.';
		ELSE

			CASE WHEN P_created IS NULL THEN P_created := get_timestamp(); ELSE END CASE;

			INSERT INTO users ( uid, profile, modifiedBy, created, createdBy )
			VALUES ( P_uid, P_me::jsonb, P_modifiedby, P_created, P_modifiedby )
			ON CONFLICT (uid) DO UPDATE SET
				profile = P_me::jsonb,
				modifiedBy = P_modifiedby

			RETURNING uid,modified,created INTO fd;

	END CASE;

	RETURN json_build_object (
		'uid',P_uid,
		'modified',fd.modified,
		'created',fd.created
	);

END;
$$ LANGUAGE 'plpgsql';
