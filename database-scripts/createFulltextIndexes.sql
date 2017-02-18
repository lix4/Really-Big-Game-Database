CREATE FULLTEXT INDEX ON Tag (TName)
  KEY INDEX PK_Tag
  ON ft
GO

CREATE FULLTEXT INDEX ON Game (GName, Studio, Series)
  KEY INDEX PK_Game
  ON ft
GO

CREATE FULLTEXT INDEX ON Mod (MName)
  KEY INDEX PK_Mod
  ON ft
GO
