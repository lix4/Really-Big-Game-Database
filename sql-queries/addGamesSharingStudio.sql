CREATE PROCEDURE addGamesSharingStudio
  @game_id int,
  @score smallint
AS
-- Add 5 to all games made by the same studio
DECLARE @g_studio char(50)
DECLARE @s_results TABLE (game_id int, score smallint)
DECLARE @score_sum TABLE (game_id int, score smallint)

SELECT @g_studio = Studio FROM Game WHERE Game_id = @game_id

INSERT INTO @s_results (game_id, score)
  SELECT game_id, @score FROM Game
  WHERE Game.game_id <> @game_id
    AND Game.Studio = @g_studio

INSERT INTO @score_sum (game_id, score)
  SELECT g.game_id, g.score + s.score
    FROM #g_results AS g, @s_results AS s
    WHERE g.game_id = s.game_id

DELETE FROM @s_results
  WHERE game_id IN (SELECT game_id FROM @score_sum)

DELETE FROM #g_results
  WHERE game_id IN (SELECT game_id FROM @score_sum)

INSERT INTO #g_results (game_id, score)
  SELECT game_id, score FROM @score_sum
  UNION
  SELECT game_id, score FROM @s_results
