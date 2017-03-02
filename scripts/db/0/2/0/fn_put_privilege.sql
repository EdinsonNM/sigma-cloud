/* scripts/db/0/3/22/fn_put_privilege.sql */

CREATE OR REPLACE FUNCTION fn_put_privilege (
	P_uid	integer,
	P_roles	integer,
	P_modby	integer
) RETURNS json AS $$

DECLARE fd record;

BEGIN

	CASE
		WHEN P_uid IS NULL THEN RAISE not_null_violation USING MESSAGE = 'P_uid parameter is required.';
		WHEN P_roles IS NULL THEN RAISE not_null_violation USING MESSAGE = 'P_roles parameter is required.';
		WHEN P_modby IS NULL THEN RAISE not_null_violation USING MESSAGE = 'P_modby parameter is required.';
		ELSE

			INSERT INTO privileged ( uid, roles, modifiedBy, createdBy )
			VALUES ( P_uid, p_roles, P_modby, P_modby )
			ON CONFLICT (uid) DO UPDATE SET
				roles = P_roles,
				modifiedBy = P_modby
			RETURNING created,modified into fd;

	END CASE;

	RETURN json_build_object (
		'modified',fd.modified,
		'created',fd.created
	);

END;
$$ LANGUAGE 'plpgsql';
