CREATE TRIGGER insertCategorizesTrigger ON Categorizes
FOR INSERT
AS

DECLARE @r_id int

DECLARE insertedCursor CURSOR LOCAL FOR
  SELECT R_id FROM Inserted
OPEN insertedCursor

FETCH NEXT FROM insertedCursor INTO @r_id
WHILE @@FETCH_STATUS = 0
BEGIN
  EXEC updateTagsFromReview @r_id
  FETCH NEXT FROM insertedCursor INTO @r_id
END
