


/****** Object:  Table [xdb_collection].[Interactions_Archive]    Script Date: 10/02/2025 07:08:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Interactions_Archive_Shard1](
	[InteractionId] [uniqueidentifier] NOT NULL,
	[LastModified] [datetime2](7) NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[ConcurrencyToken] [uniqueidentifier] NOT NULL,
	[ContactId] [uniqueidentifier] NOT NULL,
	[StartDateTime] [datetime2](7) NOT NULL,
	[EndDateTime] [datetime2](7) NOT NULL,
	[Initiator] [smallint] NOT NULL,
	[DeviceProfileId] [uniqueidentifier] NULL,
	[ChannelId] [uniqueidentifier] NOT NULL,
	[VenueId] [uniqueidentifier] NULL,
	[CampaignId] [uniqueidentifier] NULL,
	[Events] [nvarchar](max) NOT NULL,
	[UserAgent] [nvarchar](900) NOT NULL,
	[EngagementValue] [int] NOT NULL,
	[Percentile] [float] NOT NULL,
	[ShardKey] [binary](1) NOT NULL,
 CONSTRAINT [PK_Interactions_Archive_Shard1] PRIMARY KEY CLUSTERED 
(
	[InteractionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


