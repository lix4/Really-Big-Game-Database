USE [ReallyBigGameDatabase]
GO

/****** Object:  Table [dbo].[Game]    Script Date: 2/18/2017 5:24:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Game](
	[Game_id] [int] IDENTITY(1,1) NOT NULL,
	[Studio] [char](50) NOT NULL,
	[ESRB] [char](1) NULL,
	[GName] [char](50) NOT NULL,
	[Year] [date] NOT NULL,
	[Series] [char](50) NULL,
	[Picture] [char](765) NULL,
 CONSTRAINT [PK_Game] PRIMARY KEY CLUSTERED 
(
	[Game_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Game]  WITH CHECK ADD  CONSTRAINT [Valid_Date] CHECK  (([Year]<=getdate() AND [Year]>='1950-01-01' OR [Year] IS NULL))
GO

ALTER TABLE [dbo].[Game] CHECK CONSTRAINT [Valid_Date]
GO

ALTER TABLE [dbo].[Game]  WITH CHECK ADD  CONSTRAINT [Valid_ESRB] CHECK  (([ESRB]='C' OR [ESRB]='e' OR [ESRB]='E' OR [ESRB]='T' OR [ESRB]='M' OR [ESRB]='A' OR [ESRB] IS NULL))
GO

ALTER TABLE [dbo].[Game] CHECK CONSTRAINT [Valid_ESRB]
GO

