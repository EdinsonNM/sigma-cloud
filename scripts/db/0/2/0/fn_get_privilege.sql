/* scripts/db/0/2/0/fn_get_privilege.sql */

CREATE OR REPLACE FUNCTION fn_get_privilege (
	P_uid	integer
) RETURNS json AS $$

DECLARE fd RECORD;

BEGIN

	CASE
		WHEN P_uid IS NULL THEN RAISE not_null_violation USING MESSAGE = 'P_uid parameter is required.';
		ELSE
			SELECT f.roles,f.modified,f.created INTO fd
			FROM privileged AS f
			WHERE fbid = P_fbid;

			IF NOT FOUND THEN
				RAISE EXCEPTION 'privileged fbid: % does not exist', P_fbid USING
				ERRCODE = 'R1QA1';
			ELSE
				RETURN json_build_object (
					'roles',fd.roles,
					'created',fd.created,
					'modified',fd.modified
				);
			END IF;

	END CASE;

END;
$$ LANGUAGE 'plpgsql';
