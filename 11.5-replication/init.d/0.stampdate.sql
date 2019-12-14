CREATE OR REPLACE FUNCTION stampdate()
RETURNS numeric AS $$
	select to_number(to_char(now(),'YYYYMMDDHH24MISS'),'99999999999999');
$$ LANGUAGE sql;