CREATE PROCEDURE topModTags
  @mod_id int
AS
IF NOT EXISTS (SELECT * FROM Mod WHERE M_id = @mod_id)
  RETURN
DECLARE @totalTags float
SELECT @totalTags = (SELECT COUNT(*)
                       FROM Review, Categorizes
                       WHERE Review.R_id = Categorizes.R_id
                         AND Mod_id = @mod_id)
SELECT TOP 8 TName, 100 * COUNT(*) / @totalTags AS Percentage
  FROM Review, Categorizes
  WHERE Mod_id = @mod_id
    AND Review.R_id = Categorizes.R_id
  GROUP BY TName
  ORDER BY -COUNT(*)
