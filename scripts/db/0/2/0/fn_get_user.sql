/* scripts/db/0/2/0/fn_get_user.sql */

CREATE OR REPLACE FUNCTION fn_get_user (
	P_uid	integer
) RETURNS json AS $$

DECLARE fd RECORD;

BEGIN

	CASE
		WHEN P_uid IS NULL THEN RAISE not_null_violation USING MESSAGE = 'P_uid parameter is required.';
		ELSE
			SELECT f.uid,f.profile,p.roles,f.modified,f.created INTO fd
			FROM users AS f
			LEFT JOIN privileged p ON f.uid = p.uid
			WHERE uid = P_uid;

			IF NOT FOUND THEN
				RAISE EXCEPTION 'user uid: % does not exist', P_uid USING
				ERRCODE = 'R1QA1';
			ELSE
				RETURN json_build_object (
					'uid',P_uid,
					'profile',fd.profile,
					'privilege',json_build_object (
						'roles',fd.roles
					),
					'created',fd.created,
					'modified',fd.modified
				);
			END IF;

	END CASE;


END;
$$ LANGUAGE 'plpgsql';
