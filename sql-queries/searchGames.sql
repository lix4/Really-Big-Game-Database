CREATE PROCEDURE searchGames
  @text VARCHAR(255)
AS
-- String splitting logic taken from:
-- http://stackoverflow.com/questions/2647/how-do-i-split-a-string-so-i-can-access-item-x#2685
DECLARE @andText VARCHAR(255)
DECLARE @orText VARCHAR(255)
SET @andText = REPLACE(@text, ' ', ' AND ')
SET @orText = REPLACE(@text, ' ', ' OR ')
SELECT *
  FROM Game
  WHERE CONTAINS((GName, Series, Studio), @andText)
        OR CONTAINS((GName, Series, Studio), @orText)
  -- Sort so that those that have all the keywords are shown before
  -- those with only some.
  ORDER BY (CASE WHEN CONTAINS((GName, Series, Studio), @andText)
                   THEN 1
                 WHEN CONTAINS((GName, Series, Studio), @orText)
                   THEN 2
                 END)
