CREATE PROCEDURE addModsSharingTags
  @mod_id int,
  @score smallint
AS
DECLARE @tags TABLE (tname char(20))
DECLARE @s_results TABLE (mod_id int, score smallint)
DECLARE @score_sum TABLE (mod_id int, score smallint)

INSERT INTO @tags
  SELECT TName FROM Mod_Is_In
    WHERE M_id = @Mod_id

INSERT INTO @s_results (mod_id, score)
  SELECT M_id, @score * Percentage
    FROM Mod_is_in
    WHERE Mod_Is_In.M_id <> @mod_id
      AND Mod_is_in.TName IN (SELECT tname
                                 FROM @tags)

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
