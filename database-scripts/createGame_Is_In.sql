USE [ReallyBigGameDatabase]
GO

/****** Object:  Table [dbo].[Game_Is_In]    Script Date: 2/18/2017 5:24:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Game_Is_In](
	[Game_id] [int] NOT NULL,
	[TName] [char](20) NOT NULL,
	[percentage] [float] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Game_Is_In]  WITH CHECK ADD  CONSTRAINT [FK_Game_Is_In_Game] FOREIGN KEY([Game_id])
REFERENCES [dbo].[Game] ([Game_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Game_Is_In] CHECK CONSTRAINT [FK_Game_Is_In_Game]
GO

ALTER TABLE [dbo].[Game_Is_In]  WITH CHECK ADD  CONSTRAINT [FK_Game_Is_In_Tag] FOREIGN KEY([TName])
REFERENCES [dbo].[Tag] ([TName])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Game_Is_In] CHECK CONSTRAINT [FK_Game_Is_In_Tag]
GO

