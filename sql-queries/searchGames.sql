CREATE PROCEDURE searchGames
  @text VARCHAR(255)
AS
-- String splitting logic taken from:
-- http://stackoverflow.com/questions/2647/how-do-i-split-a-string-so-i-can-access-item-x#2685
DECLARE @andText VARCHAR(255)
DECLARE @orText VARCHAR(255)
SET @andText = REPLACE(@text, ' ', ' AND ')
SET @orText = REPLACE(@text, ' ', ' OR ')
SELECT DISTINCT Sorted.Game_id, Sorted.GName, Sorted.Series, Sorted.Studio,
    Sorted.ESRB, Sorted.Picture, Sorted.Year
  FROM (SELECT TOP 100 PERCENT Game.Game_id, Game.GName, Game.Series, Game.Studio,
            Game.ESRB, Game.Picture, Game.Year
          FROM (SELECT Game.Game_id, Game.GName, Game.Series, Game.Studio,
                    Game.ESRB, Game.Picture, Game.Year, 1 AS rank
                  FROM Game
                  WHERE CONTAINS((GName, Series, Studio), @andText)
                UNION
                SELECT Game.Game_id, Game.GName, Game.Series, Game.Studio,
                     Game.ESRB, Game.Picture, Game.Year, 2 AS rank
                  FROM Game, Game_Is_In, Tag
                  WHERE Game.Game_id = Game_Is_In.Game_id
                    AND Game_Is_In.TName = Tag.TName
                    AND CONTAINS(Tag.TName, @orText)
                UNION
                SELECT Game.Game_id, Game.GName, Game.Series, Game.Studio,
                    Game.ESRB, Game.Picture, Game.Year, 3 AS rank
                  FROM Game
                  WHERE CONTAINS((GName, Series, Studio), @orText)) AS Game
          ORDER BY -Game.rank) AS Sorted
