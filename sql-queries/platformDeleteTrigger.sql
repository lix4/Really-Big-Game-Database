CREATE TRIGGER Platform_Delete ON Platform
FOR DELETE
AS
BEGIN
-- Check if this platform is the only available one for a Game
  IF EXISTS (SELECT *
               FROM Available_On, Deleted
               WHERE Available_On.PName = Deleted.PName
               GROUP BY Game_id
               HAVING COUNT(*) = 1)
  BEGIN
    RAISERROR('This is the last platform a game is available on', 16, 1)
    ROLLBACK TRANSACTION
  END
END
