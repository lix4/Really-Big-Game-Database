CREATE TRIGGER insertCategorizesTrigger ON Categorizes
AFTER INSERT
AS

DECLARE @r_ids TABLE (R_id int NOT NULL)
DECLARE @r_id int

INSERT INTO @r_ids (R_id)
  SELECT R_id FROM Inserted

DECLARE insertedCursor CURSOR LOCAL FOR
  SELECT R_id FROM @r_ids
OPEN insertedCursor

FETCH NEXT FROM insertedCursor INTO @r_id
WHILE @@FETCH_STATUS = 0
BEGIN
  EXEC updateTagsFromReview @r_id
  FETCH NEXT FROM insertedCursor INTO @r_id
END
