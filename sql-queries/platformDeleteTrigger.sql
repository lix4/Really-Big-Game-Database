CREATE TRIGGER Platform_Delete ON Platform
FOR DELETE
AS
BEGIN
-- Check if this platform is the only available one for a Game
  IF EXISTS (SELECT * FROM Game
               WHERE NOT EXISTS (SELECT * FROM Available_On
                                   WHERE Available_On.Game_id = Game.Game_id))
  BEGIN
    RAISERROR('This is the last platform a game is available on', 16, 1)
    ROLLBACK TRANSACTION
  END
END
GO
