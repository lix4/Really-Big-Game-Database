CREATE PROCEDURE testRecommendations
AS
DECLARE @res BIT
EXEC registerUser 'AlphaTester', 'AlphaPassword', 'Alpha', @res OUTPUT
IF @res = 0
BEGIN
  PRINT 'Could not create AlphaTester'
  RETURN
END
EXEC registerUser 'BetaTester', 'BetaPassword', 'Alpha', @res OUTPUT
IF @res = 0
BEGIN
  PRINT 'Could not create BetaTester'
  RETURN
END

DECLARE @game_1_id int
EXEC @game_1_id = createGame 'Platform1', 'Studio1', 'Game1', '2017-01-01', 0, NULL, 'Series1'
DECLARE @game_2_id int
EXEC @game_2_id = createGame 'Platform2', 'Studio2', 'Game2', '2017-01-01', 0, NULL, 'Series2'

INSERT INTO Mod (MName, Game_id)
  VALUES ('Game1-Mod1', @game_1_id),
         ('Game1-Mod2', @game_2_id)

DECLARE @text_res VARCHAR(255)
EXEC createReview 'AlphaTester', 5, @game_1_id, 0, 'This PLATFORMER was really fun!', 'Platformer;RPG;Story', @text_res OUTPUT
EXEC createReview 'BetaTester', 5, @game_2_id, 0, 'This PLATFORMER is also really fun!', 'Indie;Platformer;Cartoony', @text_res OUTPUT

EXEC addGameToLikes 'AlphaTester', 'AlphaPassword', @game_1_id, @text_res OUTPUT

DECLARE @ids TABLE (gid int NULL, mid int NULL)
INSERT INTO @ids (gid, mid)
  EXEC recommendations 'AlphaTester', 20, @game_1_id
SELECT Game.* FROM Game, @ids WHERE Game_id = gid
SELECT Mod.* FROM Mod, @ids WHERE M_id = mid

DELETE FROM Users WHERE UName = 'AlphaTester' OR UName = 'BetaTester'
DELETE FROM Game WHERE Game_id = @game_1_id OR Game_id = @game_2_id
