/* scripts/db/0/1/0/fn_get_user.sql */

CREATE OR REPLACE FUNCTION fn_get_user (
	P_uid	integer
) RETURNS json AS $$

DECLARE fd RECORD;

BEGIN

	CASE
		WHEN P_uid IS NULL THEN RAISE not_null_violation USING MESSAGE = 'P_uid parameter is required.';
		ELSE
			SELECT f.uid,f.profile,f.modified,f.created INTO fd
			FROM fbusers AS f
			WHERE uid = P_uid
			LIMIT 1;

			IF NOT FOUND THEN
				RAISE EXCEPTION 'user uid: % does not exist', P_uid USING
				ERRCODE = 'R1QA1';
			ELSE
				RETURN json_build_object (
					'uid',P_uid,
					'created',fd.created,
					'modified',fd.modified,
					'profile',fd.profile
				);
			END IF;

	END CASE;


END;
$$ LANGUAGE 'plpgsql';
