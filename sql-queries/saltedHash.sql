CREATE PROCEDURE saltedHash
  @uname char(25),
  @pass char(30),
  @result BINARY(30) OUTPUT
AS
  SET @result = HASHBYTES('SHA1', CONCAT(@uname, @pass))
