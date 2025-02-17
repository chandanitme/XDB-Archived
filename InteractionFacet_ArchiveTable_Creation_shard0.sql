

/****** Object:  Table [xdb_collection].[InteractionFacets_Archive]    Script Date: 10/02/2025 07:09:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[InteractionFacets_Archive_Shard0](
	[InteractionId] [uniqueidentifier] NOT NULL,
	[FacetKey] [nvarchar](50) NOT NULL,
	[ContactId] [uniqueidentifier] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
	[ConcurrencyToken] [uniqueidentifier] NOT NULL,
	[FacetData] [nvarchar](max) NOT NULL,
	[ShardKey] [binary](1) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


