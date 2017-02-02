CREATE PROCEDURE createReview
  @uname char(25),
  @pass char(30),
  @rating smallint,
  @game_id int,
  @mod_id int,
  @text char(4000),
  @result VARCHAR(255) OUTPUT
AS
  IF NOT EXISTS (SELECT * FROM Game WHERE Game_id = @game_id)
    AND NOT EXISTS (SELECT * FROM Mod WHERE M_id = @mod_id)
  BEGIN
     SET @result = 'No valid Game or Mod'
     RETURN
  END
  IF @game_id <> 0 AND @mod_id <> 0
  BEGIN
    SET @result = 'Can only review either a Game or a Mod, not both'
    RETURN
  END
  DECLARE @validLogin BIT
  EXECUTE login @uname, @pass, @validLogin OUTPUT
  IF @validLogin = 0
  BEGIN
    SET @result = 'Invalid login'
    RETURN
  END
  IF @game_id = 0
  BEGIN
    INSERT INTO Review (Uname, Rating, Text, Mod_id)
      VALUES (@uname, @rating, @text, @mod_id);
    SET @result = 'Mod review Posted'
    RETURN
  END
  INSERT INTO Review (Uname, Rating, Text, Game_id)
      VALUES (@uname, @rating, @text, @game_id);
  SET @result = 'Game review Posted'
  RETURN
