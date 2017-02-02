CREATE PROCEDURE login
  @uname char(25),
  @pass char(30),
  @result BIT OUTPUT
AS
  IF EXISTS (SELECT *
               FROM Users
               WHERE Users.Uname = @uname
               AND Users.Password = HASHBYTES('SHA1', CONCAT(@uname, @pass)))
  SET @result = 1
ELSE
  SET @result = 0;
