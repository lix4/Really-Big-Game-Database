CREATE PROCEDURE addModsSharingGame
  @mod_id int,
  @score smallint
AS
DECLARE @game_id int
DECLARE @s_results TABLE (mod_id int, score smallint)
DECLARE @score_sum TABLE (mod_id int, score smallint)

SELECT @game_id = Game_id FROM Mod WHERE M_id = @mod_id

INSERT INTO @s_results (mod_id, score)
  SELECT M_id, @score
    FROM Mod
    WHERE M_id <> @mod_id
      AND Game_id = @game_id

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
