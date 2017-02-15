CREATE PROCEDURE createReview
  @uname char(25),
  @rating smallint,
  @game_id int,
  @mod_id int,
  @text char(4000),
  @tags char(200),
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
  IF EXISTS (SELECT *
               FROM Review
               WHERE Uname = @uname
                 AND (Game_id = @game_id
                      OR Mod_id = @mod_id))
  BEGIN
    SET @result = 'You have already posted a review on this game/mod'
    RETURN
  END

  IF @game_id = 0
  BEGIN
    INSERT INTO Review (Uname, Rating, Text, Mod_id)
      VALUES (@uname, @rating, @text, @mod_id);
    SET @result = 'Mod review Posted'
  END
  ELSE
  BEGIN
    INSERT INTO Review (Uname, Rating, Text, Game_id)
      VALUES (@uname, @rating, @text, @game_id);
    SET @result = 'Game review Posted'
  END

  -- Use string manipulation magic to form a table of tags from the
  -- semicolon-delimited input @tags
  SET @tags = REPLACE(@tags, ';', '''),(''')
  CREATE TABLE #tags_table (TName char(20) NOT NULL)
  EXEC('INSERT INTO #tags_table (TNAME) VALUES ('''
    + @tags + ''')')

  INSERT INTO Tag (TName)
    SELECT TName FROM #tags_table
      WHERE #tags_table.TName NOT IN (SELECT TName FROM Tag)

  INSERT INTO Categorizes (R_id, TName)
    SELECT (SELECT TOP(1) R_id FROM Review ORDER BY -R_id),
           TName
      FROM #tags_table
