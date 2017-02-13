CREATE PROCEDURE updateTagsFromReview
  @r_id int
AS
DECLARE @r_game_id int
DECLARE @r_mod_id int
DECLARE @tags TABLE(TName char(20), Percentage float)

SELECT @r_game_id = Game_id, @r_mod_id = Mod_id
  FROM Review, Inserted
  WHERE Review.R_id = @r_id

-- Is this reviewing a game?
IF NOT @r_game_id IS NULL
BEGIN
  DELETE FROM Game_Is_In WHERE Game_id = @r_game_id
  INSERT INTO @tags EXEC topGameTags @r_game_id
END
-- Or a mod?
ELSE
BEGIN
  DELETE FROM Mod_Is_In WHERE M_id = @r_mod_id
  INSERT INTO @tags EXEC topModTags @r_mod_id
END
