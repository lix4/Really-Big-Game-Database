CREATE TRIGGER deleteReviewTrigger ON Review
FOR DELETE
AS

DECLARE @uname char(25)
DECLARE @game_id int

DECLARE unameCursor CURSOR LOCAL FOR
  SELECT Uname FROM Deleted
OPEN unameCursor

DECLARE gameCursor CURSOR LOCAL FOR
  SELECT Game_id FROM Deleted
OPEN gameCursor

FETCH NEXT FROM unameCursor INTO @uname
FETCH NEXT FROM gameCursor INTO @game_id
WHILE @@FETCH_STATUS = 0
BEGIN
  DELETE FROM Likes
    WHERE Game_id = @game_id
      AND Uname = @uname
      
  FETCH NEXT FROM unameCursor INTO @uname
  FETCH NEXT FROM gameCursor INTO @game_id
END
