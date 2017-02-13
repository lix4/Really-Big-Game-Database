CREATE TRIGGER deleteCategorizesTrigger ON Categorizes
FOR DELETE
AS

DECLARE @r_id int

DECLARE deletedCursor CURSOR LOCAL FOR
  SELECT R_id FROM Deleted
OPEN deletedCursor

FETCH NEXT FROM deletedCursor INTO @r_id
WHILE @@FETCH_STATUS = 0
BEGIN
  EXEC updateTagsFromReview @r_id
  FETCH NEXT FROM deletedCursor INTO @r_id
END
