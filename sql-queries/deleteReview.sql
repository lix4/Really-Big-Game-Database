CREATE PROCEDURE deleteReview
  @uname char(25),
  @game_id int = 0,
  @mod_id int = 0,
  @res VARCHAR(255) OUTPUT
AS
DECLARE @r_id int

IF @game_id <> 0 AND @mod_id <> 0
BEGIN
  SET @res = 'Only provide a legal game_id or mod_id'
  RETURN
END

IF @game_id <> 0
BEGIN
  SELECT @r_id = R_id
    FROM Review
    WHERE UName = @uname
      AND Game_id = @game_id
END

IF @mod_id <> 0
BEGIN
  SELECT @r_id = R_id
    FROM Review
    WHERE UName = @uname
      AND Mod_id = @mod_id
END

IF @r_id IS NULL
BEGIN
  SET @res = 'No legal review.'
  RETURN
END
SET @res = 'Successfully deleted review.'
DELETE FROM Review WHERE R_id = @r_id
