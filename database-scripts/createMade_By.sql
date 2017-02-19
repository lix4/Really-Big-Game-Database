USE [ReallyBigGameDatabase]
GO

/****** Object:  Table [dbo].[Made_By]    Script Date: 2/18/2017 5:25:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Made_By](
	[M_id] [int] NOT NULL,
	[Uname] [char](25) NOT NULL,
 CONSTRAINT [PK_Made_By] PRIMARY KEY CLUSTERED 
(
	[M_id] ASC,
	[Uname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Made_By]  WITH CHECK ADD  CONSTRAINT [FK_Made_By_Mod] FOREIGN KEY([M_id])
REFERENCES [dbo].[Mod] ([M_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Made_By] CHECK CONSTRAINT [FK_Made_By_Mod]
GO

ALTER TABLE [dbo].[Made_By]  WITH CHECK ADD  CONSTRAINT [FK_Made_By_Users] FOREIGN KEY([Uname])
REFERENCES [dbo].[Users] ([Uname])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Made_By] CHECK CONSTRAINT [FK_Made_By_Users]
GO
