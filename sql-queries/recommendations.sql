CREATE PROCEDURE recommendations
  @uname char(25),
  @result_ct smallint, -- number of results to return
  @game_id int = 0,
  @mod_id int = 0,
  @w_series smallint = 10, -- weight for games sharing a series
  @w_studio smallint = 2, -- weight for games sharing a studio
  @w_gtags smallint = 10, -- weight for items with similar tags
  @w_mod float = 0.5, -- how much to dilute findings from a mod's
                         -- base game
  @w_siblings smallint = 10, -- different mods from the same base game
  @w_mtags smallint = 10,
  @w_utags smallint = 10, -- weight for tags detected from User's likes
  @w_mods_for_liked smallint = 5
AS

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
  EXEC addModsSharingTags @mod_id, @w_mtags
END

EXEC addModsSharingGame @game_id, @w_siblings, @mod_id
EXEC addModsForLikedGames @uname, @w_mods_for_liked, @mod_id

-- Add 10 to all games in the same series
SELECT @w_series = @w_series * @mod_weight
EXEC addGamesSharingSeries @game_id, @w_series
-- Add 2 to all games made by the same studio
SELECT @w_studio = @w_studio * @mod_weight
EXEC addGamesSharingStudio @game_id, @w_studio
-- Add 10 (reduced by the popularity of different tags) to all games
-- with similar tags
SELECT @w_gtags = @w_gtags * @mod_weight
EXEC addGamesSharingTags @game_id, @w_gtags
SELECT @w_utags = @w_utags * @mod_weight
EXEC addGamesWithUserTags @uname, @w_utags

DECLARE @results TABLE (game_id int NULL, mod_id int NULL, score smallint)

INSERT INTO @results (game_id, score)
  SELECT game_id, score FROM #g_results

INSERT INTO @results (mod_id, score)
  SELECT mod_id, score FROM #m_results

SELECT TOP (@result_ct) game_id, mod_id FROM @results
  ORDER BY -score
