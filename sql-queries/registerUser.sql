CREATE PROCEDURE registerUser
  @uname char(25),
  @pass char(30),
  @alias char(30),
  @res VARCHAR(255) OUTPUT
AS
IF EXISTS (SELECT * FROM Users WHERE Uname = @uname)
BEGIN
  SET @res = 'That username has already been used.'
  RETURN
END

DECLARE @hash BINARY(30)
EXECUTE saltedHash @uname, @pass, @hash OUTPUT
INSERT INTO Users (Uname, Password, Alias)
  VALUES (@uname, @hash, @alias)
SET @res = 'Successfully created user'
