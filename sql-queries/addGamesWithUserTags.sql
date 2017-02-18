CREATE PROCEDURE addGamesWithUserTags
  @uname char(25),
  @score smallint
AS
DECLARE @tags TABLE (TName char(20))
DECLARE @s_results TABLE (game_id int, score smallint)
DECLARE @score_sum TABLE (game_id int, score smallint)

INSERT INTO @tags
  SELECT TOP(10) TName
  FROM Likes, Game_Is_In
  WHERE Likes.UName = @uname
    AND Game_Is_In.Game_id = Likes.Game_id
  GROUP BY TName
  ORDER BY -COUNT(*)

INSERT INTO @s_results (game_id, score)
  SELECT Game_id, @score FROM Game_Is_In
  WHERE Game_id NOT IN (SELECT Game_id FROM Likes
                                     WHERE Uname = @uname)
    AND TName IN (SELECT TName FROM @tags)

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
