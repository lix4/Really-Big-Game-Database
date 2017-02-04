CREATE PROCEDURE searchGames
  @text VARCHAR(255)
AS
-- String splitting logic taken from:
-- http://stackoverflow.com/questions/2647/how-do-i-split-a-string-so-i-can-access-item-x#2685
SET @text = REPLACE(@text, ' ', ' OR ')
SELECT * FROM Game
  WHERE CONTAINS ((GName, Series, Studio), @text)
