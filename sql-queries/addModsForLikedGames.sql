CREATE PROCEDURE addModsForLikedGames
  @uname char(25),
  @score smallint,
  @mod_id int = 0
AS
DECLARE @s_results TABLE (mod_id int, score smallint)
DECLARE @score_sum TABLE (mod_id int, score smallint)

INSERT INTO @s_results (mod_id, score)
  SELECT M_id, @score
    FROM Mod
    WHERE M_id <> @mod_id
      AND Game_id IN (SELECT Game_id FROM Likes
                        WHERE Uname = @uname)

INSERT INTO @score_sum (mod_id, score)
  SELECT m.mod_id, m.score + s.score
    FROM #m_results AS m, @s_results AS s
    WHERE m.mod_id = s.mod_id

DELETE FROM @s_results
  WHERE mod_id IN (SELECT mod_id FROM @score_sum)

DELETE FROM #m_results
  WHERE mod_id IN (SELECT mod_id FROM @score_sum)

INSERT INTO #m_results (mod_id, score)
  SELECT mod_id, score FROM @score_sum
  UNION
  SELECT mod_id, score FROM @s_results
