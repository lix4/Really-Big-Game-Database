CREATE PROCEDURE topGameTags
  @game_id int
AS
IF NOT EXISTS (SELECT * FROM Game WHERE Game_id = @game_id)
  RETURN
DECLARE @totalTags float
SELECT @totalTags = (SELECT COUNT(*)
                       FROM Review, Categorizes
                       WHERE Review.R_id = Categorizes.R_id
                         AND Game_id = @game_id)
SELECT TOP 8 TName, 100 * COUNT(*) / @totalTags AS Percentage
  FROM Review, Categorizes
  WHERE Game_id = @game_id
    AND Review.R_id = Categorizes.R_id
  GROUP BY TName
  ORDER BY -COUNT(*)
