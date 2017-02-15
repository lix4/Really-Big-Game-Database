CREATE PROCEDURE addGamesSharingTags
  @game_id int,
  @score smallint
AS
DECLARE @tags TABLE (tname char(20))
DECLARE @s_results TABLE (game_id int, score smallint)
DECLARE @score_sum TABLE (game_id int, score smallint)

INSERT INTO @tags
  SELECT TName FROM Game_is_in
    WHERE Game_id = @game_id

INSERT INTO @s_results (game_id, score)
  SELECT game_id, @score * Percentage
    FROM Game_is_in
    WHERE Game_is_in.game_id <> @game_id
      AND Game_is_in.TName IN (SELECT tname
                                 FROM @tags)

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
