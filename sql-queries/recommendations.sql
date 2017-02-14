CREATE PROCEDURE recommendations
  @uname char(25),
  @result_ct smallint,
  @game_id int = 0,
  @mod_id int = 0
AS

DECLARE @g_studio char(50)
DECLARE @g_esrb char(1)
DECLARE @g_gname char(50)
DECLARE @g_year date
DECLARE @g_series char(50)

DECLARE @t_score_sum TABLE (id int, score smallint)
DECLARE @t_results TABLE (id int, score smallint)
CREATE TABLE #g_results (game_id int, score smallint)
DECLARE @m_results TABLE (mod_id int, score smallint)

IF @game_id <> 0
BEGIN
  -- Initialize convinince variables
  SELECT @g_studio = Studio, @g_esrb = ESRB, @g_gname = GName, @g_year = Year,
    @g_series = Series
  FROM Game WHERE Game_id = @game_id

  -- Add 10 to all games in the same series
  INSERT INTO @t_results (id, score)
    SELECT game_id, 10 FROM Game
    WHERE Game.game_id <> @game_id
      AND Game.Series = @g_series

  INSERT INTO #g_results (game_id, score)
    SELECT id, score FROM @t_results

  DELETE FROM @t_results

  -- Add 5 to all games made by the same studio
  EXEC addGamesSharingStudio @game_id, 5
END

DECLARE @results TABLE (game_id int NULL, mod_id int NULL, score smallint)

INSERT INTO @results (game_id, score)
  SELECT game_id, score FROM #g_results

INSERT INTO @results (mod_id, score)
  SELECT mod_id, score FROM @m_results

SELECT TOP (@result_ct) game_id, mod_id FROM @results
  ORDER BY -score
