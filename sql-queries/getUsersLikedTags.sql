CREATE PROCEDURE getUsersLikedTags
  @uname char(25),
  @tag_ct smallint = 10
AS

SELECT TOP(@tag_ct) TName, COUNT(*)
  FROM Likes, Game_Is_In
  WHERE Likes.UName = @uname
    AND Game_Is_In.Game_id = Likes.Game_id
  GROUP BY TName
  ORDER BY -COUNT(*)
