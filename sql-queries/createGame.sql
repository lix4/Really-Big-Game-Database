CREATE PROCEDURE createGame
  @pname char(20),
  @studio char(50),
  @gname char(50),
  @year date,
  @forceAddGame BIT = NULL, -- 1: assume GName is unique if there's a conflict
  @esrb char(1) = NULL,
  @series char(50) = NULL,
  @picture char(765) = NULL
AS
IF NOT EXISTS (SELECT * FROM Platform WHERE PName = @pname)
BEGIN
  INSERT INTO Platform VALUES (@pname)
END

IF EXISTS (SELECT * FROM Game WHERE GName = @gname)
BEGIN
  IF @forceAddGame IS NOT NULL
    AND @forceAddGame = 1
  BEGIN
    INSERT INTO Available_On (PName, Game_id)
      VALUES (@pname, (SELECT Game_id FROM Game
                         WHERE GName = @gname))
  END
  ELSE
  BEGIN
    PRINT 'There is already a game named ' + @gname + '.'
    PRINT 'If this is the same game, you will need to manually insert it.'
  END
END
ELSE
BEGIN
 INSERT INTO Game (Studio, GName, Year, ESRB, Series, Picture)
   VALUES (@studio, @gname, @year, @esrb, @series, @picture)
 INSERT INTO Available_On (PName, Game_id)
   VALUES (@pname, (SELECT TOP(1) Game_id FROM Game
                      WHERE GName = @gname
                      ORDER BY -Game_id))
END
