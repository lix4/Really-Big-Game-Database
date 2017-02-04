CREATE PROCEDURE addGameToLikes
  @uname char(25),
  @pass char(30),
  @game_id int,
  @result VARCHAR(255) OUTPUT
AS
  IF NOT EXISTS (SELECT * FROM Game WHERE Game_id = @game_id)
  BEGIN
     SET @result = 'No such Game'
     RETURN
  END

  DECLARE @validLogin BIT
  EXECUTE login @uname, @pass, @validLogin OUTPUT
  IF @validLogin = 0
  BEGIN
    SET @result = 'Invalid login'
    RETURN
  END
  IF EXISTS (SELECT *
               FROM Likes
               WHERE Uname = @uname
                 AND Game_id = @game_id)
  BEGIN
    SET @result = 'You have already liked this game'
    RETURN
  END

  INSERT INTO Likes (Uname, Game_id)
      VALUES (@uname, @game_id);
  SET @result = 'Game added'
  RETURN
