CREATE PROCEDURE recommendations
  @uname char(25),
  @result_ct smallint, -- number of results to return
  @game_id int = 0,
  @mod_id int = 0,
  @w_series smallint = 10, -- weight for games sharing a series
  @w_studio smallint = 2, -- weight for games sharing a studio
  @w_tags smallint = 10, -- weight for items with similar tags
  @w_mod smallint = 0.5, -- how much to dilute findings from a mod's
                         -- base game
  @w_siblings smallint = 5 -- different mods from the same base game
AS

DECLARE @g_studio char(50)
DECLARE @g_esrb char(1)
DECLARE @g_gname char(50)
DECLARE @g_year date
DECLARE @g_series char(50)

-- Weight to multiply scores for the game by. This is just 1 if the
-- search is for a game, but when it's a mod it tells the procedure to
-- weight neighbors based off of the base game less heavily
DECLARE @mod_weight float
SET @mod_weight = 1.0

DECLARE @t_score_sum TABLE (id int, score smallint)
DECLARE @t_results TABLE (id int, score smallint)
CREATE TABLE #g_results (game_id int, score smallint)
CREATE TABLE #m_results (mod_id int, score smallint)

IF @mod_id <> 0
BEGIN
  SELECT @game_id = Game_id, @mod_weight = @w_mod
    FROM Mod WHERE M_id = @mod_id
  EXEC addModsSharingGame @mod_id, @w_siblings
END

-- Add 10 to all games in the same series
EXEC addGamesSharingSeries @game_id, @w_series * @mod_weight
-- Add 2 to all games made by the same studio
EXEC addGamesSharingStudio @game_id, @w_studio * @mod_weight
-- Add 10 (reduced by the popularity of different tags) to all games
-- with similar tags
EXEC addGamesSharingTags @game_id, @w_tags * @mod_weight

DECLARE @results TABLE (game_id int NULL, mod_id int NULL, score smallint)

INSERT INTO @results (game_id, score)
  SELECT game_id, score FROM #g_results

INSERT INTO @results (mod_id, score)
  SELECT mod_id, score FROM #m_results

SELECT TOP (@result_ct) game_id, mod_id FROM @results
  ORDER BY -score
