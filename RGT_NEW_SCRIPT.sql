USE [RGT_NEW]
GO
/****** Object:  User [PUNIB8924\SQLServer2005MSSQLUser$PUNIB8924$MSSQLSERVER]    Script Date: 04/27/2010 17:42:11 ******/
CREATE USER [PUNIB8924\SQLServer2005MSSQLUser$PUNIB8924$MSSQLSERVER] FOR LOGIN [PUNIB8924\SQLServer2005MSSQLUser$PUNIB8924$MSSQLSERVER]
GO
/****** Object:  User [BUILTIN\Users]    Script Date: 04/27/2010 17:42:11 ******/
CREATE USER [BUILTIN\Users] FOR LOGIN [BUILTIN\Users]
GO
/****** Object:  StoredProcedure [dbo].[PR_UPDATE_ACTIVITY_SCRIPT]    Script Date: 04/27/2010 17:42:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PR_UPDATE_ACTIVITY_SCRIPT] 
-- Add the parameters for the stored procedure here
@script_ID int,
@script_Name varchar(50),
@description varchar(500),
@sla varchar(50),
@startTime varchar(50),
@endTime varchar(50),
@mail_to varchar(500),
@mail_cc varchar(500),
@mail_bcc varchar(500),
@client varchar(50),
@server_Type varchar(50),
@server varchar(50), 
@workingDir varchar(50),
@database_Name varchar(50),
@port varchar(50),
@query varchar(5000),
@command varchar(500),
@activityID varchar(50),
@projectID varchar(50)


AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
-- Insert statements for procedure here
if 
not exists
(select * from TBL_ACTIVITY_SCRIPT where SCRIPT_NAME=@script_Name
 and PROJECTID=@ProjectId 
 and SCRIPT_ID!=@script_ID)


update TBL_ACTIVITY_SCRIPT

set 

SCRIPT_NAME=rtrim(@script_Name),
DESCRIPTION=rtrim(@description),
SLA=rtrim(@sla),
START_TIME=rtrim(@startTime),
END_TIME=rtrim(@endTime),
MAIL_TO=rtrim(@mail_to),
MAIL_CC=rtrim(@mail_cc),
MAIL_BCC=rtrim(@mail_bcc),
CLIENT=rtrim(@client),
SERVER_TYPE=rtrim(@server_Type),
SERVER=rtrim(@server),
WORKING_DIR=rtrim(@workingDir),
DATABASE_NAME=rtrim(@database_Name),
PORT=rtrim(@port),
QUERY=rtrim(@query),
COMMAND=rtrim(@command),
ACTIVITY_ID=rtrim(@activityID),
PROJECTID=rtrim(@projectID)

where SCRIPT_ID =@script_ID   
    else 
     RAISERROR('Activity Already Exists',16,16)

END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_part]    Script Date: 04/27/2010 17:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[udf_part]
(
     @imput varchar(100),
     @delimiter varchar(1),
     @part integer
)
returns decimal(18,2) as
begin
     declare @temp varchar(2000)
     set @temp = @imput

     while @part > 1
     begin
             set @temp = substring(@temp, patindex('%' + @delimiter + '%', @temp + @delimiter) + 1, 2000)
          set @part = @part - 1
     end
     return (substring(@temp, 1, patindex('%' + @delimiter + '%', @temp + @delimiter) - 1))
end
GO
/****** Object:  StoredProcedure [dbo].[UPDATE_SERVER]    Script Date: 04/27/2010 17:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec UpdateActivityName 110,'Test',11111
CREATE PROCEDURE [dbo].[UPDATE_SERVER]
	-- Add the parameters for the stored procedure here
     @serverName varchar(50),
	 @serverIP varchar(50),
     @serverNameOld varchar(50),
     @ProjectId varchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
--    declare @ActivityOldName varchar(50)
--    select @ActivityOldName = ACTIVITY_NAME from TBL_ACTIVITY 
--    where ACTIVITY_ID=@ACTIVITY_ID
   
    if
	not exists(
		select * from TBL_SERVER 
		where SERVERNAME=@serverNameOld 
			and PROJECTID=@ProjectId)
		update TBL_SERVER 
		set SERVERNAME=rtrim(@serverName),
			IP=rtrim(@serverIP)
			
		where SERVERNAME=@serverNameOld and PROJECTID=@ProjectId  
	else 
		RAISERROR('Server Already Exists',16,16)
END
GO
/****** Object:  StoredProcedure [dbo].[PR_UPDATE_SERVER]    Script Date: 04/27/2010 17:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec UpdateActivityName 110,'Test',11111
CREATE PROCEDURE [dbo].[PR_UPDATE_SERVER]
	-- Add the parameters for the stored procedure here
     @ServerName varchar(50),
     @ServerIP varchar(50),
     @ServerNameOld varchar(50),
	@ProjectID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
--    declare @ActivityOldName varchar(50)
--    select @ActivityOldName = ACTIVITY_NAME from TBL_ACTIVITY 
--    where ACTIVITY_ID=@ACTIVITY_ID
   
	if(@ServerName=@ServerNameOld)
	update TBL_SERVER 
	set 
		IP=rtrim(@ServerIP)
	where
		SERVERNAME=@ServerName 
    else if not exists(
select * from TBL_SERVER where SERVERNAME=@ServerName and PROJECTID=@ProjectId)
    update TBL_SERVER 
	set 
		SERVERNAME=rtrim(@ServerName),
		IP=rtrim(@ServerIP)
	where
		SERVERNAME=@ServerNameOld 
	and 
		PROJECTID=@ProjectId   
    else 
     RAISERROR('Server Already Exists',16,16)
END
GO
/****** Object:  StoredProcedure [dbo].[PR_CREATE_KSHSCRIPT]    Script Date: 04/27/2010 17:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[PR_CREATE_KSHSCRIPT]
	-- Add the parameters for the stored procedure here
@name varchar(50),
@server varchar(50),
@username varchar(50),
@password varchar(50),
@workingDir varchar(500),
@command varchar(500),
@kshFile varchar(500),
@createdDate varchar(50),
@modifiedDate varchar(50),
@projectID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
insert into TBL_SCRIPT_SHELLSCRIPT values(
rtrim(@name) ,
rtrim(@server) ,
rtrim(@username) ,
rtrim(@password) ,
rtrim(@workingDir) ,
rtrim(@command) ,
rtrim(@kshFile) ,
rtrim(@createdDate) ,
rtrim(@modifiedDate),
rtrim(@projectID) )
END
GO
/****** Object:  StoredProcedure [dbo].[PR_STORE_XML]    Script Date: 04/27/2010 17:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PR_STORE_XML]
	-- Add the parameters for the stored procedure here
@xmlObj xml	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
insert into TBL_REPORT_DATA values(@xmlObj);	
END
GO
/****** Object:  Table [dbo].[TBL_PROJECT]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_PROJECT](
	[PROJECTID] [varchar](50) NOT NULL,
	[PROJECTNAME] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_PROJECT] PRIMARY KEY CLUSTERED 
(
	[PROJECTID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_ROLE]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_ROLE](
	[ROLEID] [int] NOT NULL,
	[ROLENAME] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_ROLE] PRIMARY KEY CLUSTERED 
(
	[ROLEID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[emp2]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[emp2](
	[empno] [int] NOT NULL,
	[dept] [char](10) NULL,
	[job] [char](10) NOT NULL,
	[salary] [decimal](8, 2) NULL,
	[comm] [decimal](8, 2) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_ZERO_TEST]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_ZERO_TEST](
	[SN] [varchar](50) NULL,
	[COL1] [varchar](50) NULL,
	[COL2] [varchar](50) NULL,
	[COL3] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[PR_INSERT_ACTIVITY_SCRIPT_DATA]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PR_INSERT_ACTIVITY_SCRIPT_DATA] 
-- Add the parameters for the stored procedure here
@script_id int,
@activity_id int,
@project_id varchar(50),
@data varchar(50),
@date varchar(50),
@comment varchar(5000)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
-- Insert statements for procedure here
insert into dbo.TBL_ACTIVITY_SCRIPT_DATA values
( rtrim(@script_id),
rtrim(@activity_id),
rtrim(@project_id),
rtrim(@data),
rtrim(@date),
rtrim(@comment)
)
END
GO
/****** Object:  StoredProcedure [dbo].[PR_CREATE_ACTIVITY_SCRIPT]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PR_CREATE_ACTIVITY_SCRIPT] 
-- Add the parameters for the stored procedure here
@script_Name varchar(50),
@description varchar(500),
@sla varchar(50),
@startTime varchar(50),
@endTime varchar(50),
@mail_to varchar(500),
@mail_cc varchar(500),
@mail_bcc varchar(500),
@client varchar(50),
@server_Type varchar(50),
@server varchar(50), 
@workingDir varchar(50),
@database_Name varchar(50),
@port varchar(50),
@query varchar(5000),
@command varchar(500),
@activityID varchar(50),
@projectID varchar(50)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
-- Insert statements for procedure here
insert into dbo.TBL_ACTIVITY_SCRIPT values
( rtrim(@script_Name),
rtrim(@description),
rtrim(@sla),
rtrim(@startTime),
rtrim(@endTime),
rtrim(@mail_to),
rtrim(@mail_cc),
rtrim(@mail_bcc),
rtrim(@client),
rtrim(@server_Type),
rtrim(@server),
rtrim(@workingDir),
rtrim(@database_Name),
rtrim(@port),
rtrim(@query),
rtrim(@command),
rtrim(@activityID),
rtrim(@projectID))
END
GO
/****** Object:  StoredProcedure [dbo].[PR_CREATE_CREDENTIALS]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PR_CREATE_CREDENTIALS] 
	-- Add the parameters for the stored procedure here
	
	@servername varchar(50),	
	@associateid bigint,	
	@username varchar(50),
	@password varchar(50),
	@projectID varchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into dbo.TBL_SERVER_CREDENTIALS values
(rtrim(@servername),@associateid,rtrim(@username),rtrim(@password),rtrim(@projectID))

END
GO
/****** Object:  StoredProcedure [dbo].[PR_CREATE_SERVER]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[PR_CREATE_SERVER]
	-- Add the parameters for the stored procedure here
	
	@serverName varchar(50),
	@serverIp varchar(50),
	@serverType varchar(50),
	@projectID varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into dbo.TBL_SERVER values(rtrim(@serverName),rtrim(@serverIp),rtrim(@serverType),rtrim(@projectID))
END
GO
/****** Object:  StoredProcedure [dbo].[PR_SAVE_CONSOLE_TEMPLATE]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PR_SAVE_CONSOLE_TEMPLATE] 
	-- Add the parameters for the stored procedure here
@projectID varchar(50),
@activityScript int,
@description int,
@sla int,
@client int,
@value1 int,
@status int,
@viewLog int,
@comment int

	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if
	not exists(select * from TBL_CONSOLE_TEMPLATE where PROJECTID=@projectID)

insert into TBL_CONSOLE_TEMPLATE values(
rtrim(@projectID),
rtrim(@activityScript),
rtrim(@description),
rtrim(@sla),
rtrim(@client),
rtrim(@value1),
rtrim(@status),
rtrim(@viewLog),
rtrim(@comment))

	else
	RAISERROR('Template data exists for this project.',16,16)


END
GO
/****** Object:  StoredProcedure [dbo].[GET_CONSOLE_TEMPLATE_DETAILS]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_CONSOLE_TEMPLATE_DETAILS]
	-- Add the parameters for the stored procedure here
@projectID varchar(50)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from TBL_CONSOLE_TEMPLATE;
END
GO
/****** Object:  Table [dbo].[TBL_PARENT]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_PARENT](
	[PARENT_ID] [int] NOT NULL,
	[PARENT_NAME] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_PARENT] PRIMARY KEY CLUSTERED 
(
	[PARENT_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_CHILD]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_CHILD](
	[CHILD_ID] [int] NOT NULL,
	[CHILD_NAME] [varchar](50) NOT NULL,
	[PARENT_ID1] [int] NOT NULL,
 CONSTRAINT [PK_TBL_CHILD] PRIMARY KEY CLUSTERED 
(
	[CHILD_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_ACTIVITY_NON_CONFIGURABLE_DATA]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_ACTIVITY_NON_CONFIGURABLE_DATA](
	[NON_CFG_ACTIVITY_DATA_ID] [int] NOT NULL,
	[ACTIVITY_ID] [int] NOT NULL,
	[XML] [varchar](max) NOT NULL,
	[GENERATED_DATE] [varchar](50) NOT NULL,
	[TIME] [varchar](50) NOT NULL,
	[TIMEZONE_ID] [varchar](100) NOT NULL,
 CONSTRAINT [PK_TBL_ACTIVITY_NON_CONFIGURABLE_DATA] PRIMARY KEY CLUSTERED 
(
	[NON_CFG_ACTIVITY_DATA_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_STATUS]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_STATUS](
	[ACTIVITY_ID] [int] NOT NULL,
	[STATUS_COL_ONE_ID] [int] NOT NULL,
	[STATUS_COL_TWO_ID] [int] NOT NULL,
	[RELATION] [varchar](50) NOT NULL,
	[STATUS_COLOUR] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_STATUS] PRIMARY KEY CLUSTERED 
(
	[ACTIVITY_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[PR_CREATE_LOG_INVESTIGATION]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PR_CREATE_LOG_INVESTIGATION] 
	-- Add the parameters for the stored procedure here
@scriptID int,
@activityID int,
@server_Type varchar(50),
@server varchar(50), 
@workingDir varchar(50),
@database_Name varchar(50),
@port varchar(50),
@query varchar(5000),
@command varchar(500),
@projectID varchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
insert into dbo.TBL_LOG_INVESTIGATION values
( rtrim(@scriptID),
rtrim(@activityID),
rtrim(@server_Type),
rtrim(@server),
rtrim(@workingDir),
rtrim(@database_Name),
rtrim(@port),
rtrim(@query),
rtrim(@command),
rtrim(@projectID))

END
GO
/****** Object:  StoredProcedure [dbo].[UpdateActivityName]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec UpdateActivityName 110,'Test',11111
CREATE PROCEDURE [dbo].[UpdateActivityName]
	-- Add the parameters for the stored procedure here
     @ACTIVITY_ID int,
     @ActivityNewName varchar(50),
     @ProjectId varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
--    declare @ActivityOldName varchar(50)
--    select @ActivityOldName = ACTIVITY_NAME from TBL_ACTIVITY 
--    where ACTIVITY_ID=@ACTIVITY_ID
   
    if not exists(select * from TBL_ACTIVITY where ACTIVITY_NAME=@ActivityNewName and PROJECTID=@ProjectId and ACTIVITY_ID!=@ACTIVITY_ID)
    update TBL_ACTIVITY set ACTIVITY_NAME=rtrim(@ActivityNewName) where ACTIVITY_ID =@ACTIVITY_ID   
    else 
     RAISERROR('Activity Already Exists',16,16)
END
GO
/****** Object:  StoredProcedure [dbo].[PR_CREATE_USER]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[PR_CREATE_USER] 
	-- Add the parameters for the stored procedure here
	@associateid bigint,
	
	@firstname varchar(50),
	@lastname varchar(50),
	@emailid varchar(50),
	@project bigint,
	@role int,
@password varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into dbo.TBL_USER values
(rtrim(@associateid),rtrim(@firstname),rtrim(@lastname),rtrim(@emailid),rtrim(@project),rtrim(@role),rtrim(@password))

END
GO
/****** Object:  StoredProcedure [dbo].[PR_CREATE_REPORT]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PR_CREATE_REPORT] 
	-- Add the parameters for the stored procedure here
	@reportname varchar(50),
	@caption varchar(50),
	@cronschedule varchar(50),
	@to varchar(50),
	@cc varchar(50),
	@bcc varchar(50),
	@created_date varchar(50),
	@modified_date varchar(50),
	@project_id varchar(50),
	@application_id int,
	@mail varchar(50),
	@notifyTo varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into dbo.TBL_REPORT 
	values(
			rtrim(@reportname),
			rtrim(@caption),
			rtrim(@cronschedule),
			rtrim(@to),
			rtrim(@cc),
			rtrim(@bcc),
			rtrim(@created_date),
			rtrim(@modified_date),
			rtrim(@project_id),
			rtrim(@application_id),
			rtrim(@mail),
			rtrim(@notifyTo)
			)

END
GO
/****** Object:  Table [dbo].[TBL_SQL_METADATA]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_SQL_METADATA](
	[SQL_ID] [bigint] NULL,
	[COLUMN_ID] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_Split]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Fn_Split] (   @SourceString sql_variant,    @Delimiter nvarchar(10) = N',')  RETURNS @Values TABLE( Position smallint IDENTITY, cValue varchar( 8000 ) , ncValue nvarchar( 4000 ) )  AS  BEGIN      DECLARE @NormalString    varchar( 8000 ) , @NationalString    nvarchar( 4000 ) ,              @NormalDelimiter varchar( 10 )   , @NationalDelimiter nvarchar( 10 )   ,              @IsNationalChar  bit             , @Position          int              ,              @NormalValue     varchar( 8000 ) , @NationalValue     nvarchar( 4000 )      SET @Delimiter      = COALESCE( @Delimiter, N',' )      SET @IsNationalChar = CASE                              WHEN SQL_VARIANT_PROPERTY( @SourceString , 'BaseType' ) IN ( 'char' , 'varchar' )                              THEN 0                              WHEN SQL_VARIANT_PROPERTY( @SourceString , 'BaseType' ) IN ( 'nchar' , 'nvarchar' )                              THEN 1                            END      IF @IsNationalChar IS NULL RETURN      IF @IsNationalChar = 0      BEGIN              SET @NormalDelimiter = @Delimiter              SET @NormalString    = CAST( @SourceString AS varchar(8000) )                IF LEFT( @NormalString , LEN( @NormalDelimiter ) ) = @NormalDelimiter                      SET @NormalString = SUBSTRING( @NormalString, LEN( @NormalDelimiter ) + 1, 8000 )              IF RIGHT( @NormalString , LEN( @NormalDelimiter ) ) <> @NormalDelimiter                      SET @NormalString = @NormalString + @NormalDelimiter              WHILE( 1 = 1 )              BEGIN                      SET @Position     = CHARINDEX( @NormalDelimiter , @NormalString ) - 1                      IF @Position <= 0 BREAK                      SET @NormalValue  = LEFT( @NormalString , @Position )                      SET @NormalString = STUFF( @NormalString , 1 , @Position + LEN( @NormalDelimiter ), '' )                      INSERT INTO @Values ( cValue ) VALUES( @NormalValue )              END      END      ELSE IF @IsNationalChar = 1      BEGIN              SET @NationalDelimiter = @Delimiter              SET @NationalString    = CAST( @SourceString AS varchar(8000) )                IF LEFT( @NationalString , LEN( @NationalDelimiter ) ) = @NationalDelimiter                      SET @NationalString = SUBSTRING( @NationalString, LEN( @NationalDelimiter ) + 1, 4000 )              IF RIGHT( @NationalString , LEN( @NationalDelimiter ) ) <> @NationalDelimiter                      SET @NationalString = @NationalString + @NationalDelimiter              WHILE( 1 = 1 )              BEGIN                      SET @Position     = CHARINDEX( @NationalDelimiter , @NationalString ) - 1                      IF @Position <= 0 BREAK                      SET @NationalValue  = LEFT( @NationalString , @Position )                      SET @NationalString = STUFF( @NationalString , 1 , @Position + LEN( @NationalDelimiter ), '' )                      INSERT INTO @Values ( ncValue ) VALUES( @NationalValue )              END      END      RETURN  END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_part_decimal]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[udf_part_decimal]
(
     @imput varchar(100),
     @delimiter varchar(1),
     @part integer
)
returns varchar(2000) as
begin
     declare @temp varchar(2000)
     set @temp = @imput

     while @part > 1
     begin
             set @temp = substring(@temp, patindex('%' + @delimiter + '%', @temp + @delimiter) + 1, 2000)
          set @part = @part - 1
     end
     return convert(decimal(18,2),(substring(@temp, 1, patindex('%' + @delimiter + '%', @temp + @delimiter) - 1)))
end
GO
/****** Object:  Table [dbo].[TBL_HOLIDAY]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_HOLIDAY](
	[HOLIDAY_ID] [int] NOT NULL,
	[HOLIDAY_NAME] [varchar](100) NOT NULL,
	[HOLIDAY_DATE] [varchar](100) NOT NULL,
	[PROJECTID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_HOLIDAY] PRIMARY KEY CLUSTERED 
(
	[HOLIDAY_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_APPLICATION]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_APPLICATION](
	[APPLICATION_ID] [int] IDENTITY(100,1) NOT NULL,
	[APPLICATION_NAME] [varchar](50) NOT NULL,
	[PROJECTID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_APPLICATION] PRIMARY KEY CLUSTERED 
(
	[APPLICATION_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_ACTIVITY]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_ACTIVITY](
	[ACTIVITY_ID] [int] NOT NULL,
	[ACTIVITY_NAME] [varchar](100) NOT NULL,
	[TYPE] [int] NOT NULL,
	[APPLICATION_ID] [int] NOT NULL,
	[PROJECTID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_ACTIVITY_TYPE] PRIMARY KEY CLUSTERED 
(
	[ACTIVITY_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_REPORT]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_REPORT](
	[REPORT_ID] [int] IDENTITY(100,1) NOT NULL,
	[REPORT_NAME] [varchar](50) NOT NULL,
	[CAPTION] [varchar](50) NOT NULL,
	[CRONSCHEDULE] [varchar](50) NULL,
	[MAIL_TO] [varchar](500) NOT NULL,
	[MAIL_CC] [varchar](500) NULL,
	[MAIL_BCC] [varchar](500) NULL,
	[CREATED_DATE] [varchar](50) NOT NULL,
	[MODIFIED_DATE] [varchar](50) NOT NULL,
	[PROJECTID] [varchar](50) NOT NULL,
	[APPLICATION_ID] [int] NOT NULL,
	[Mail] [varchar](50) NOT NULL,
	[NOTIFY_TO] [varchar](500) NOT NULL,
 CONSTRAINT [PK_TBL_REPORT] PRIMARY KEY CLUSTERED 
(
	[REPORT_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_USER]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_USER](
	[ASSOCIATEID] [bigint] NOT NULL,
	[FIRSTNAME] [varchar](50) NOT NULL,
	[LASTNAME] [varchar](50) NOT NULL,
	[EMAILID] [varchar](50) NOT NULL,
	[PROJECT] [varchar](50) NOT NULL,
	[ROLE] [int] NOT NULL,
	[PASSWORD] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_USER] PRIMARY KEY CLUSTERED 
(
	[ASSOCIATEID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_APPLICATION_RIGHTS]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_APPLICATION_RIGHTS](
	[ASSOCIATEID] [bigint] NOT NULL,
	[PROJECTID] [varchar](50) NOT NULL,
	[APPLICATION_ID] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_SCRIPT_SQL]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_SCRIPT_SQL](
	[SQL_ID] [int] IDENTITY(5001,1) NOT NULL,
	[NAME] [varchar](50) NOT NULL,
	[SERVER] [varchar](50) NOT NULL,
	[PORT] [varchar](50) NOT NULL,
	[USERID] [varchar](50) NOT NULL,
	[PASSWORD] [varchar](50) NOT NULL,
	[SQL_QUERY] [varchar](5000) NOT NULL,
	[CREATED_DATE] [varchar](50) NOT NULL,
	[MODIFIED_DATE] [varchar](50) NOT NULL,
	[PROJECTID] [varchar](50) NOT NULL,
	[DATABASE_TYPE] [varchar](50) NOT NULL,
	[DATABASE_NAME] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_SCRIPT_SQL] PRIMARY KEY CLUSTERED 
(
	[SQL_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_SCRIPT_SHELLSCRIPT]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_SCRIPT_SHELLSCRIPT](
	[SHELLSCRIPT_ID] [int] IDENTITY(3000,1) NOT NULL,
	[NAME] [varchar](50) NOT NULL,
	[SERVER] [varchar](50) NOT NULL,
	[USERNAME] [varchar](50) NOT NULL,
	[PASSWORD] [varchar](50) NOT NULL,
	[WORKING_DIR] [varchar](500) NOT NULL,
	[COMMAND] [varchar](500) NULL,
	[SCRIPT_FILE] [varchar](500) NULL,
	[CREATED_DATE] [varchar](50) NOT NULL,
	[MODIFIED_DATE] [varchar](50) NOT NULL,
	[PROJECTID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_SCRIPT_SHELLSCRIPT] PRIMARY KEY CLUSTERED 
(
	[SHELLSCRIPT_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_SECTION]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_SECTION](
	[SECTION_ID] [int] IDENTITY(500,1) NOT NULL,
	[SECTION_NAME] [varchar](100) NOT NULL,
	[CAPTION] [varchar](100) NOT NULL,
	[CREATED_DATE] [varchar](50) NOT NULL,
	[MODIFIED_DATE] [varchar](50) NOT NULL,
	[PROJECTID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_SECTION] PRIMARY KEY CLUSTERED 
(
	[SECTION_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_SCRIPT_XML]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_SCRIPT_XML](
	[XML_ID] [int] IDENTITY(2000,1) NOT NULL,
	[NAME] [varchar](50) NOT NULL,
	[XML_FILE] [varchar](500) NOT NULL,
	[CREATED_DATE] [varchar](50) NOT NULL,
	[MODIFIED_DATE] [varchar](50) NOT NULL,
	[PROJECTID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_SCRIPT_XML] PRIMARY KEY CLUSTERED 
(
	[XML_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_SUBSECTION]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_SUBSECTION](
	[SUBSECTION_ID] [int] IDENTITY(100,1) NOT NULL,
	[SUBSECTION_NAME] [varchar](100) NOT NULL,
	[CAPTION] [varchar](100) NOT NULL,
	[CREATED_DATE] [varchar](50) NOT NULL,
	[MODIFIED_DATE] [varchar](50) NOT NULL,
	[PROJECTID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_SUBSECTION] PRIMARY KEY CLUSTERED 
(
	[SUBSECTION_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_REPORT_SECTION_MAP]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_REPORT_SECTION_MAP](
	[REPORT_ID] [int] NOT NULL,
	[SECTION_ID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_SECTION_SUBSECTION_MAP]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_SECTION_SUBSECTION_MAP](
	[SECTION_ID] [int] NOT NULL,
	[SUBSECTION_ID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_SUBSECTION_SQL_SCRIPT_MAP]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_SUBSECTION_SQL_SCRIPT_MAP](
	[SUBSECTION_ID] [int] NOT NULL,
	[SQL_ID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_SUBSECTION_XML_SCRIPT_MAP]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_SUBSECTION_XML_SCRIPT_MAP](
	[SUBSECTION_ID] [int] NOT NULL,
	[XML_ID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_SUBSECTION_KSH_SCRIPT_MAP]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_SUBSECTION_KSH_SCRIPT_MAP](
	[SUBSECTION_ID] [int] NOT NULL,
	[SHELLSCRIPT_ID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_SCRIPT_SQL_PARAM]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_SCRIPT_SQL_PARAM](
	[SQL_ID] [int] NOT NULL,
	[DEFAULT_PARAM] [varchar](5000) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_REPORT_TYPE]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_REPORT_TYPE](
	[REPORT_ID] [int] NOT NULL,
	[REPORT_TYPE] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TBL_REPORT_TYPE] PRIMARY KEY CLUSTERED 
(
	[REPORT_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_REPORT_DATA]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_REPORT_DATA](
	[REPORT_DATA_ID] [int] IDENTITY(10000,1) NOT NULL,
	[REPORT_ID] [int] NOT NULL,
	[PROJECTID] [varchar](50) NOT NULL,
	[GENERATED_DATE] [varchar](50) NOT NULL,
	[TIME] [varchar](50) NOT NULL,
	[ASSOCIATEID] [bigint] NOT NULL,
	[REPORT_XML] [xml] NOT NULL,
	[APPLICATION_ID] [int] NOT NULL,
 CONSTRAINT [PK_TBL_REPORT_DATA] PRIMARY KEY CLUSTERED 
(
	[REPORT_DATA_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_ACTIVITY_CONFIGURABLE]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_ACTIVITY_CONFIGURABLE](
	[ACTIVITY_ID] [int] NOT NULL,
	[STATUS] [int] NOT NULL,
	[VIEW_LOG] [int] NOT NULL,
	[COMMENT] [int] NOT NULL,
	[NOTIFICATION] [int] NOT NULL,
	[TIMEZONE_ID] [varchar](100) NOT NULL,
 CONSTRAINT [PK_TBL_ACTIVITY_CONFIGURABLE] PRIMARY KEY CLUSTERED 
(
	[ACTIVITY_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_ACTIVITY_CONFIGURABLE_COLUMNS]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_ACTIVITY_CONFIGURABLE_COLUMNS](
	[COLUMN_ID] [int] NOT NULL,
	[COLUMN_NAME] [varchar](100) NOT NULL,
	[NATURE] [int] NOT NULL,
	[ACTIVITY_ID] [int] NOT NULL,
	[DATATYPE] [int] NOT NULL,
	[FORMAT] [varchar](100) NULL,
 CONSTRAINT [PK_TBL_ACTIVITY_CONFIGURABLE_COLUMNS] PRIMARY KEY CLUSTERED 
(
	[COLUMN_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_ACTIVITY_SCRIPT]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_ACTIVITY_SCRIPT](
	[ACTIVITY_SCRIPT_ID] [int] NOT NULL,
	[ACTIVITY_SCRIPT_NAME] [varchar](100) NOT NULL,
	[ACTIVITY_ID] [int] NOT NULL,
	[CRON_SCHEDULER] [varchar](100) NOT NULL,
	[RECURSIVE] [int] NOT NULL,
 CONSTRAINT [PK_TBL_ACTIVITY_SCRIPT] PRIMARY KEY CLUSTERED 
(
	[ACTIVITY_SCRIPT_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_ACTIVITY_NON_CONFIGURABLE]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_ACTIVITY_NON_CONFIGURABLE](
	[ACTIVITY_ID] [int] NOT NULL,
	[TYPE] [int] NOT NULL,
	[DB_TYPE] [int] NULL,
	[SERVER] [varchar](100) NOT NULL,
	[USERNAME] [varchar](100) NOT NULL,
	[PASSWORD] [varchar](100) NOT NULL,
	[DB_NAME] [varchar](100) NULL,
	[PORT] [int] NULL,
	[QUERY] [varchar](2000) NULL,
	[WORKING_DIR] [varchar](500) NULL,
	[COMMAND] [varchar](500) NULL,
	[CRON_SCHEDULER] [varchar](100) NOT NULL,
	[RECURSIVE] [int] NOT NULL,
	[HOLIDAY] [varchar](500) NULL,
	[TIMEZONE_ID] [varchar](50) NULL,
 CONSTRAINT [PK_TBL_ACTIVITY_NON_CONFIGURABLE] PRIMARY KEY CLUSTERED 
(
	[ACTIVITY_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_ACTIVITY_SCRIPT_COLUMNS_DATA]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_ACTIVITY_SCRIPT_COLUMNS_DATA](
	[COLUMN_ID] [int] NOT NULL,
	[ACTIVITY_SCRIPT_ID] [int] NOT NULL,
	[COLUMN_VALUE] [varchar](100) NULL,
	[TYPE] [int] NULL,
	[SERVER] [varchar](100) NULL,
	[USERNAME] [varchar](100) NULL,
	[PASSWORD] [varchar](100) NULL,
	[DB_TYPE] [int] NULL,
	[DB_NAME] [varchar](100) NULL,
	[PORT] [int] NULL,
	[QUERY] [varchar](2000) NULL,
	[WORKING_DIR] [varchar](500) NULL,
	[COMMAND] [varchar](500) NULL,
 CONSTRAINT [PK_TBL_ACTIVITY_SCRIPT_COLUMNS_DATA] PRIMARY KEY CLUSTERED 
(
	[COLUMN_ID] ASC,
	[ACTIVITY_SCRIPT_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_LOG_INVESTIGATION]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_LOG_INVESTIGATION](
	[ACTIVITY_SCRIPT_ID] [int] NOT NULL,
	[LOG_TYPE] [int] NOT NULL,
	[SERVER] [varchar](100) NOT NULL,
	[USERNAME] [varchar](100) NOT NULL,
	[PASSWORD] [varchar](100) NOT NULL,
	[DB_TYPE] [int] NULL,
	[PORT] [int] NULL,
	[DB_NAME] [varchar](100) NULL,
	[QUERY] [varchar](2000) NULL,
	[WORKING_DIR] [varchar](500) NULL,
	[COMMAND] [varchar](500) NULL,
 CONSTRAINT [PK_TBL_LOG_INVESTIGATION] PRIMARY KEY CLUSTERED 
(
	[ACTIVITY_SCRIPT_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_ACTIVITY_SCRIPT_HOLIDAY_MAP]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_ACTIVITY_SCRIPT_HOLIDAY_MAP](
	[ACTIVITY_SCRIPT_ID] [int] NOT NULL,
	[HOLIDAY_ID] [int] NOT NULL,
 CONSTRAINT [PK_TBL_ACTIVITY_SCRIPT_HOLIDAY_MAP] PRIMARY KEY CLUSTERED 
(
	[ACTIVITY_SCRIPT_ID] ASC,
	[HOLIDAY_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_ACTIVITY_SCRIPT_NOTIFICATION]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_ACTIVITY_SCRIPT_NOTIFICATION](
	[ACTIVITY_SCRIPT_ID] [int] NOT NULL,
	[MAIL_TO] [varchar](2000) NOT NULL,
	[MAIL_CC] [varchar](2000) NOT NULL,
	[MAIL_BCC] [varchar](2000) NOT NULL,
 CONSTRAINT [PK_TBL_ACTIVITY_SCRIPT_NOTIFICATION] PRIMARY KEY CLUSTERED 
(
	[ACTIVITY_SCRIPT_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_REPORT_DATA_MAIL_COUNT]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_REPORT_DATA_MAIL_COUNT](
	[REPORT_DATA_ID] [int] NOT NULL,
	[MAIL_COUNT] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[PR_CREATE_PROJECT]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[PR_CREATE_PROJECT]
	-- Add the parameters for the stored procedure here
	@projectid varchar(50),
	@projectname varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into dbo.TBL_PROJECT values(rtrim(@projectid),rtrim(@projectname))
END
GO
/****** Object:  StoredProcedure [dbo].[PR_UPDATE_SQLSCRIPT]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<176342,,Name>
-- Create date: <13/07/09>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PR_UPDATE_SQLSCRIPT] 
	-- Add the parameters for the stored procedure here
	
@name varchar(50),
@server varchar(50),
@port int,
@userid varchar(50),
@password varchar(50),
@sql_query varchar(5000),
@modified_date varchar(50),
@database_type varchar(50),
@database_name varchar(50),
@sqlID int,
@defaultParam varchar(5000)

	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	update TBL_SCRIPT_SQL 
	set NAME=rtrim(@name),
		SERVER=rtrim(@server),
		PORT=@port,
		USERID=rtrim(@userid),
		PASSWORD=rtrim(@password),
		SQL_QUERY=rtrim(@sql_query),
		MODIFIED_DATE=rtrim(@modified_date),
		DATABASE_TYPE=rtrim(@database_type),
		DATABASE_NAME=rtrim(@database_name)
	where SQL_ID=@sqlID;
	if((@defaultParam = '' ) or (@defaultParam = null))
		BEGIN
		delete from TBL_SCRIPT_SQL_PARAM where SQL_ID=@sqlID
		END	
	else
		BEGIN
		delete from TBL_SCRIPT_SQL_PARAM where SQL_ID=@sqlID
		insert into TBL_SCRIPT_SQL_PARAM values(@sqlID,rtrim(@defaultParam))
		END	
END
GO
/****** Object:  StoredProcedure [dbo].[PR_CREATE_NEW_SQLSCRIPT]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<176342,,Name>
-- Create date: <13/07/09>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[PR_CREATE_NEW_SQLSCRIPT] 
	-- Add the parameters for the stored procedure here
	
@name varchar(50),
@server varchar(50),
@port int,
@userid varchar(50),
@password varchar(50),
@sql_query varchar(5000),
@created_date varchar(50),
@modified_date varchar(50),
@projectID varchar(50),
@database_type varchar(50),
@database_name varchar(50),
@defaultParam varchar(5000)

	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if((@defaultParam = '' ) or (@defaultParam = null))
		begin
			insert into TBL_SCRIPT_SQL values(rtrim(@name),rtrim(@server),rtrim(@port),rtrim(@userid),rtrim(@password),rtrim(@sql_query),rtrim(@created_date),rtrim(@modified_date),rtrim(@projectID),rtrim(@database_type),rtrim(@database_name));
		end
	else
		BEGIN
            declare @sqlID int;
			insert into TBL_SCRIPT_SQL values(rtrim(@name),rtrim(@server),rtrim(@port),rtrim(@userid),rtrim(@password),rtrim(@sql_query),rtrim(@created_date),rtrim(@modified_date),rtrim(@projectID),rtrim(@database_type),rtrim(@database_name));
			select @sqlID=SQL_ID from TBL_SCRIPT_SQL where NAME=rtrim(@name);
			insert into TBL_SCRIPT_SQL_PARAM values(@sqlID,rtrim(@defaultParam))
		END	
END
GO
/****** Object:  StoredProcedure [dbo].[PR_TEST_CONSOLE]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PR_TEST_CONSOLE] 
	-- Add the parameters for the stored procedure here
	AS
BEGIN
	select * from TBL_USER;
select * from TBL_ACTIVITY;
END
GO
/****** Object:  StoredProcedure [dbo].[PR_CREATE_APPLICATION]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[PR_CREATE_APPLICATION] 
	-- Add the parameters for the stored procedure here
	
	@applicationName varchar(50),
	@project varchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into dbo.TBL_APPLICATION values
(	rtrim(@applicationName),
	rtrim(@project)
)

END
GO
/****** Object:  StoredProcedure [dbo].[PR_REPORT_DATA]    Script Date: 04/27/2010 17:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[PR_REPORT_DATA] 
	-- Add the parameters for the stored procedure here
	@reportID int,	
	@project varchar(50),
	@reportDate varchar(50),
	@reportTime varchar(50),
	@associateID bigint,
	@xmlAsString xml
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    declare @AppId int

select @AppId=APPLICATION_ID from TBL_REPORT where REPORT_ID=@reportID;
    -- Insert statements for procedure here
	insert into dbo.TBL_REPORT_DATA values
(rtrim(@reportID),rtrim(@project),rtrim(@reportDate),rtrim(@reportTime),rtrim(@associateID),@xmlAsString,rtrim(@AppId))

END
GO
/****** Object:  Default [DF_TBL_REPORT_DATA_MAIL_COUNT_REPORT_DATA_ID]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_REPORT_DATA_MAIL_COUNT] ADD  CONSTRAINT [DF_TBL_REPORT_DATA_MAIL_COUNT_REPORT_DATA_ID]  DEFAULT ((0)) FOR [REPORT_DATA_ID]
GO
/****** Object:  ForeignKey [FK_TBL_HOLIDAY_TBL_PROJECT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_HOLIDAY]  WITH CHECK ADD  CONSTRAINT [FK_TBL_HOLIDAY_TBL_PROJECT] FOREIGN KEY([PROJECTID])
REFERENCES [dbo].[TBL_PROJECT] ([PROJECTID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_HOLIDAY] CHECK CONSTRAINT [FK_TBL_HOLIDAY_TBL_PROJECT]
GO
/****** Object:  ForeignKey [FK_TBL_APPLICATION_TBL_PROJECT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_APPLICATION]  WITH NOCHECK ADD  CONSTRAINT [FK_TBL_APPLICATION_TBL_PROJECT] FOREIGN KEY([PROJECTID])
REFERENCES [dbo].[TBL_PROJECT] ([PROJECTID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_APPLICATION] CHECK CONSTRAINT [FK_TBL_APPLICATION_TBL_PROJECT]
GO
/****** Object:  ForeignKey [FK_TBL_ACTIVITY_TYPE_TBL_ACTIVITY_TYPE]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_ACTIVITY]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ACTIVITY_TYPE_TBL_ACTIVITY_TYPE] FOREIGN KEY([PROJECTID])
REFERENCES [dbo].[TBL_PROJECT] ([PROJECTID])
GO
ALTER TABLE [dbo].[TBL_ACTIVITY] CHECK CONSTRAINT [FK_TBL_ACTIVITY_TYPE_TBL_ACTIVITY_TYPE]
GO
/****** Object:  ForeignKey [FK_TBL_ACTIVITY_TYPE_TBL_APPLICATION]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_ACTIVITY]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ACTIVITY_TYPE_TBL_APPLICATION] FOREIGN KEY([APPLICATION_ID])
REFERENCES [dbo].[TBL_APPLICATION] ([APPLICATION_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_ACTIVITY] CHECK CONSTRAINT [FK_TBL_ACTIVITY_TYPE_TBL_APPLICATION]
GO
/****** Object:  ForeignKey [FK_TBL_REPORT_TBL_APPLICATION]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_REPORT]  WITH CHECK ADD  CONSTRAINT [FK_TBL_REPORT_TBL_APPLICATION] FOREIGN KEY([APPLICATION_ID])
REFERENCES [dbo].[TBL_APPLICATION] ([APPLICATION_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_REPORT] CHECK CONSTRAINT [FK_TBL_REPORT_TBL_APPLICATION]
GO
/****** Object:  ForeignKey [FK_TBL_REPORT_TBL_PROJECT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_REPORT]  WITH CHECK ADD  CONSTRAINT [FK_TBL_REPORT_TBL_PROJECT] FOREIGN KEY([PROJECTID])
REFERENCES [dbo].[TBL_PROJECT] ([PROJECTID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[TBL_REPORT] CHECK CONSTRAINT [FK_TBL_REPORT_TBL_PROJECT]
GO
/****** Object:  ForeignKey [FK_TBL_USER_TBL_PROJECT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_USER]  WITH CHECK ADD  CONSTRAINT [FK_TBL_USER_TBL_PROJECT] FOREIGN KEY([PROJECT])
REFERENCES [dbo].[TBL_PROJECT] ([PROJECTID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_USER] CHECK CONSTRAINT [FK_TBL_USER_TBL_PROJECT]
GO
/****** Object:  ForeignKey [FK_TBL_USER_TBL_ROLE]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_USER]  WITH CHECK ADD  CONSTRAINT [FK_TBL_USER_TBL_ROLE] FOREIGN KEY([ROLE])
REFERENCES [dbo].[TBL_ROLE] ([ROLEID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_USER] CHECK CONSTRAINT [FK_TBL_USER_TBL_ROLE]
GO
/****** Object:  ForeignKey [FK_TBL_APPLICATION_RIGHTS_TBL_APPLICATION]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_APPLICATION_RIGHTS]  WITH NOCHECK ADD  CONSTRAINT [FK_TBL_APPLICATION_RIGHTS_TBL_APPLICATION] FOREIGN KEY([APPLICATION_ID])
REFERENCES [dbo].[TBL_APPLICATION] ([APPLICATION_ID])
GO
ALTER TABLE [dbo].[TBL_APPLICATION_RIGHTS] CHECK CONSTRAINT [FK_TBL_APPLICATION_RIGHTS_TBL_APPLICATION]
GO
/****** Object:  ForeignKey [FK_TBL_APPLICATION_RIGHTS_TBL_PROJECT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_APPLICATION_RIGHTS]  WITH NOCHECK ADD  CONSTRAINT [FK_TBL_APPLICATION_RIGHTS_TBL_PROJECT] FOREIGN KEY([PROJECTID])
REFERENCES [dbo].[TBL_PROJECT] ([PROJECTID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[TBL_APPLICATION_RIGHTS] CHECK CONSTRAINT [FK_TBL_APPLICATION_RIGHTS_TBL_PROJECT]
GO
/****** Object:  ForeignKey [FK_TBL_APPLICATION_RIGHTS_TBL_USER]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_APPLICATION_RIGHTS]  WITH NOCHECK ADD  CONSTRAINT [FK_TBL_APPLICATION_RIGHTS_TBL_USER] FOREIGN KEY([ASSOCIATEID])
REFERENCES [dbo].[TBL_USER] ([ASSOCIATEID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_APPLICATION_RIGHTS] CHECK CONSTRAINT [FK_TBL_APPLICATION_RIGHTS_TBL_USER]
GO
/****** Object:  ForeignKey [FK_TBL_SCRIPT_SQL_TBL_PROJECT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_SCRIPT_SQL]  WITH CHECK ADD  CONSTRAINT [FK_TBL_SCRIPT_SQL_TBL_PROJECT] FOREIGN KEY([PROJECTID])
REFERENCES [dbo].[TBL_PROJECT] ([PROJECTID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_SCRIPT_SQL] CHECK CONSTRAINT [FK_TBL_SCRIPT_SQL_TBL_PROJECT]
GO
/****** Object:  ForeignKey [FK_TBL_SCRIPT_SHELLSCRIPT_TBL_PROJECT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_SCRIPT_SHELLSCRIPT]  WITH CHECK ADD  CONSTRAINT [FK_TBL_SCRIPT_SHELLSCRIPT_TBL_PROJECT] FOREIGN KEY([PROJECTID])
REFERENCES [dbo].[TBL_PROJECT] ([PROJECTID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_SCRIPT_SHELLSCRIPT] CHECK CONSTRAINT [FK_TBL_SCRIPT_SHELLSCRIPT_TBL_PROJECT]
GO
/****** Object:  ForeignKey [FK_TBL_SECTION_TBL_PROJECT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_SECTION]  WITH CHECK ADD  CONSTRAINT [FK_TBL_SECTION_TBL_PROJECT] FOREIGN KEY([PROJECTID])
REFERENCES [dbo].[TBL_PROJECT] ([PROJECTID])
GO
ALTER TABLE [dbo].[TBL_SECTION] CHECK CONSTRAINT [FK_TBL_SECTION_TBL_PROJECT]
GO
/****** Object:  ForeignKey [FK_TBL_SCRIPT_XML_TBL_PROJECT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_SCRIPT_XML]  WITH CHECK ADD  CONSTRAINT [FK_TBL_SCRIPT_XML_TBL_PROJECT] FOREIGN KEY([PROJECTID])
REFERENCES [dbo].[TBL_PROJECT] ([PROJECTID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_SCRIPT_XML] CHECK CONSTRAINT [FK_TBL_SCRIPT_XML_TBL_PROJECT]
GO
/****** Object:  ForeignKey [FK_TBL_SUBSECTION_TBL_SUBSECTION]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_SUBSECTION]  WITH CHECK ADD  CONSTRAINT [FK_TBL_SUBSECTION_TBL_SUBSECTION] FOREIGN KEY([PROJECTID])
REFERENCES [dbo].[TBL_PROJECT] ([PROJECTID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_SUBSECTION] CHECK CONSTRAINT [FK_TBL_SUBSECTION_TBL_SUBSECTION]
GO
/****** Object:  ForeignKey [FK_TBL_REPORT_SECTION_MAP_TBL_REPORT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_REPORT_SECTION_MAP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_REPORT_SECTION_MAP_TBL_REPORT] FOREIGN KEY([REPORT_ID])
REFERENCES [dbo].[TBL_REPORT] ([REPORT_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_REPORT_SECTION_MAP] CHECK CONSTRAINT [FK_TBL_REPORT_SECTION_MAP_TBL_REPORT]
GO
/****** Object:  ForeignKey [FK_TBL_REPORT_SECTION_MAP_TBL_SECTION]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_REPORT_SECTION_MAP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_REPORT_SECTION_MAP_TBL_SECTION] FOREIGN KEY([SECTION_ID])
REFERENCES [dbo].[TBL_SECTION] ([SECTION_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_REPORT_SECTION_MAP] CHECK CONSTRAINT [FK_TBL_REPORT_SECTION_MAP_TBL_SECTION]
GO
/****** Object:  ForeignKey [FK_TBL_SECTION_SUBSECTION_MAP_TBL_SECTION]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_SECTION_SUBSECTION_MAP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_SECTION_SUBSECTION_MAP_TBL_SECTION] FOREIGN KEY([SECTION_ID])
REFERENCES [dbo].[TBL_SECTION] ([SECTION_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_SECTION_SUBSECTION_MAP] CHECK CONSTRAINT [FK_TBL_SECTION_SUBSECTION_MAP_TBL_SECTION]
GO
/****** Object:  ForeignKey [FK_TBL_SECTION_SUBSECTION_MAP_TBL_SUBSECTION]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_SECTION_SUBSECTION_MAP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_SECTION_SUBSECTION_MAP_TBL_SUBSECTION] FOREIGN KEY([SUBSECTION_ID])
REFERENCES [dbo].[TBL_SUBSECTION] ([SUBSECTION_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_SECTION_SUBSECTION_MAP] CHECK CONSTRAINT [FK_TBL_SECTION_SUBSECTION_MAP_TBL_SUBSECTION]
GO
/****** Object:  ForeignKey [FK_TBL_SUBSECTION_SQL_SCRIPT_MAP_TBL_SUBSECTION]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_SUBSECTION_SQL_SCRIPT_MAP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_SUBSECTION_SQL_SCRIPT_MAP_TBL_SUBSECTION] FOREIGN KEY([SUBSECTION_ID])
REFERENCES [dbo].[TBL_SUBSECTION] ([SUBSECTION_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_SUBSECTION_SQL_SCRIPT_MAP] CHECK CONSTRAINT [FK_TBL_SUBSECTION_SQL_SCRIPT_MAP_TBL_SUBSECTION]
GO
/****** Object:  ForeignKey [FK_TBL_SUBSECTION_XML_SCRIPT_MAP_TBL_SUBSECTION]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_SUBSECTION_XML_SCRIPT_MAP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_SUBSECTION_XML_SCRIPT_MAP_TBL_SUBSECTION] FOREIGN KEY([SUBSECTION_ID])
REFERENCES [dbo].[TBL_SUBSECTION] ([SUBSECTION_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_SUBSECTION_XML_SCRIPT_MAP] CHECK CONSTRAINT [FK_TBL_SUBSECTION_XML_SCRIPT_MAP_TBL_SUBSECTION]
GO
/****** Object:  ForeignKey [FK_TBL_SUBSECTION_KSH_SCRIPT_MAP_TBL_SUBSECTION]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_SUBSECTION_KSH_SCRIPT_MAP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_SUBSECTION_KSH_SCRIPT_MAP_TBL_SUBSECTION] FOREIGN KEY([SUBSECTION_ID])
REFERENCES [dbo].[TBL_SUBSECTION] ([SUBSECTION_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_SUBSECTION_KSH_SCRIPT_MAP] CHECK CONSTRAINT [FK_TBL_SUBSECTION_KSH_SCRIPT_MAP_TBL_SUBSECTION]
GO
/****** Object:  ForeignKey [FK_TBL_SCRIPT_SQL_PARAM_TBL_SCRIPT_SQL]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_SCRIPT_SQL_PARAM]  WITH CHECK ADD  CONSTRAINT [FK_TBL_SCRIPT_SQL_PARAM_TBL_SCRIPT_SQL] FOREIGN KEY([SQL_ID])
REFERENCES [dbo].[TBL_SCRIPT_SQL] ([SQL_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_SCRIPT_SQL_PARAM] CHECK CONSTRAINT [FK_TBL_SCRIPT_SQL_PARAM_TBL_SCRIPT_SQL]
GO
/****** Object:  ForeignKey [FK_TBL_REPORT_TYPE_TBL_REPORT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_REPORT_TYPE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_REPORT_TYPE_TBL_REPORT] FOREIGN KEY([REPORT_ID])
REFERENCES [dbo].[TBL_REPORT] ([REPORT_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_REPORT_TYPE] CHECK CONSTRAINT [FK_TBL_REPORT_TYPE_TBL_REPORT]
GO
/****** Object:  ForeignKey [FK_TBL_REPORT_DATA_TBL_APPLICATION]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_REPORT_DATA]  WITH CHECK ADD  CONSTRAINT [FK_TBL_REPORT_DATA_TBL_APPLICATION] FOREIGN KEY([APPLICATION_ID])
REFERENCES [dbo].[TBL_APPLICATION] ([APPLICATION_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[TBL_REPORT_DATA] CHECK CONSTRAINT [FK_TBL_REPORT_DATA_TBL_APPLICATION]
GO
/****** Object:  ForeignKey [FK_TBL_REPORT_DATA_TBL_REPORT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_REPORT_DATA]  WITH CHECK ADD  CONSTRAINT [FK_TBL_REPORT_DATA_TBL_REPORT] FOREIGN KEY([REPORT_ID])
REFERENCES [dbo].[TBL_REPORT] ([REPORT_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_REPORT_DATA] CHECK CONSTRAINT [FK_TBL_REPORT_DATA_TBL_REPORT]
GO
/****** Object:  ForeignKey [FK_TBL_ACTIVITY_CONFIGURABLE_TBL_ACTIVITY_TYPE]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_ACTIVITY_CONFIGURABLE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ACTIVITY_CONFIGURABLE_TBL_ACTIVITY_TYPE] FOREIGN KEY([ACTIVITY_ID])
REFERENCES [dbo].[TBL_ACTIVITY] ([ACTIVITY_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_ACTIVITY_CONFIGURABLE] CHECK CONSTRAINT [FK_TBL_ACTIVITY_CONFIGURABLE_TBL_ACTIVITY_TYPE]
GO
/****** Object:  ForeignKey [FK_TBL_ACTIVITY_CONFIGURABLE_COLUMNS_TBL_ACTIVITY_TYPE]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_ACTIVITY_CONFIGURABLE_COLUMNS]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ACTIVITY_CONFIGURABLE_COLUMNS_TBL_ACTIVITY_TYPE] FOREIGN KEY([ACTIVITY_ID])
REFERENCES [dbo].[TBL_ACTIVITY] ([ACTIVITY_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_ACTIVITY_CONFIGURABLE_COLUMNS] CHECK CONSTRAINT [FK_TBL_ACTIVITY_CONFIGURABLE_COLUMNS_TBL_ACTIVITY_TYPE]
GO
/****** Object:  ForeignKey [FK_TBL_ACTIVITY_SCRIPT_TBL_ACTIVITY_TYPE]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_ACTIVITY_SCRIPT]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ACTIVITY_SCRIPT_TBL_ACTIVITY_TYPE] FOREIGN KEY([ACTIVITY_ID])
REFERENCES [dbo].[TBL_ACTIVITY] ([ACTIVITY_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_ACTIVITY_SCRIPT] CHECK CONSTRAINT [FK_TBL_ACTIVITY_SCRIPT_TBL_ACTIVITY_TYPE]
GO
/****** Object:  ForeignKey [FK_TBL_ACTIVITY_NON_CONFIGURABLE_TBL_ACTIVITY_TYPE]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_ACTIVITY_NON_CONFIGURABLE]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ACTIVITY_NON_CONFIGURABLE_TBL_ACTIVITY_TYPE] FOREIGN KEY([ACTIVITY_ID])
REFERENCES [dbo].[TBL_ACTIVITY] ([ACTIVITY_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_ACTIVITY_NON_CONFIGURABLE] CHECK CONSTRAINT [FK_TBL_ACTIVITY_NON_CONFIGURABLE_TBL_ACTIVITY_TYPE]
GO
/****** Object:  ForeignKey [FK_TBL_ACTIVITY_SCRIPT_COLUMNS_DATA_TBL_ACTIVITY_CONFIGURABLE_COLUMNS]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_ACTIVITY_SCRIPT_COLUMNS_DATA]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ACTIVITY_SCRIPT_COLUMNS_DATA_TBL_ACTIVITY_CONFIGURABLE_COLUMNS] FOREIGN KEY([COLUMN_ID])
REFERENCES [dbo].[TBL_ACTIVITY_CONFIGURABLE_COLUMNS] ([COLUMN_ID])
GO
ALTER TABLE [dbo].[TBL_ACTIVITY_SCRIPT_COLUMNS_DATA] CHECK CONSTRAINT [FK_TBL_ACTIVITY_SCRIPT_COLUMNS_DATA_TBL_ACTIVITY_CONFIGURABLE_COLUMNS]
GO
/****** Object:  ForeignKey [FK_TBL_ACTIVITY_SCRIPT_COLUMNS_DATA_TBL_ACTIVITY_SCRIPT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_ACTIVITY_SCRIPT_COLUMNS_DATA]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ACTIVITY_SCRIPT_COLUMNS_DATA_TBL_ACTIVITY_SCRIPT] FOREIGN KEY([ACTIVITY_SCRIPT_ID])
REFERENCES [dbo].[TBL_ACTIVITY_SCRIPT] ([ACTIVITY_SCRIPT_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_ACTIVITY_SCRIPT_COLUMNS_DATA] CHECK CONSTRAINT [FK_TBL_ACTIVITY_SCRIPT_COLUMNS_DATA_TBL_ACTIVITY_SCRIPT]
GO
/****** Object:  ForeignKey [FK_TBL_LOG_INVESTIGATION_TBL_ACTIVITY_SCRIPT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_LOG_INVESTIGATION]  WITH CHECK ADD  CONSTRAINT [FK_TBL_LOG_INVESTIGATION_TBL_ACTIVITY_SCRIPT] FOREIGN KEY([ACTIVITY_SCRIPT_ID])
REFERENCES [dbo].[TBL_ACTIVITY_SCRIPT] ([ACTIVITY_SCRIPT_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_LOG_INVESTIGATION] CHECK CONSTRAINT [FK_TBL_LOG_INVESTIGATION_TBL_ACTIVITY_SCRIPT]
GO
/****** Object:  ForeignKey [FK_TBL_ACTIVITY_SCRIPT_HOLIDAY_MAP_TBL_ACTIVITY_SCRIPT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_ACTIVITY_SCRIPT_HOLIDAY_MAP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ACTIVITY_SCRIPT_HOLIDAY_MAP_TBL_ACTIVITY_SCRIPT] FOREIGN KEY([ACTIVITY_SCRIPT_ID])
REFERENCES [dbo].[TBL_ACTIVITY_SCRIPT] ([ACTIVITY_SCRIPT_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_ACTIVITY_SCRIPT_HOLIDAY_MAP] CHECK CONSTRAINT [FK_TBL_ACTIVITY_SCRIPT_HOLIDAY_MAP_TBL_ACTIVITY_SCRIPT]
GO
/****** Object:  ForeignKey [FK_TBL_ACTIVITY_SCRIPT_HOLIDAY_MAP_TBL_HOLIDAY]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_ACTIVITY_SCRIPT_HOLIDAY_MAP]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ACTIVITY_SCRIPT_HOLIDAY_MAP_TBL_HOLIDAY] FOREIGN KEY([HOLIDAY_ID])
REFERENCES [dbo].[TBL_HOLIDAY] ([HOLIDAY_ID])
GO
ALTER TABLE [dbo].[TBL_ACTIVITY_SCRIPT_HOLIDAY_MAP] CHECK CONSTRAINT [FK_TBL_ACTIVITY_SCRIPT_HOLIDAY_MAP_TBL_HOLIDAY]
GO
/****** Object:  ForeignKey [FK_TBL_ACTIVITY_SCRIPT_NOTIFICATION_TBL_ACTIVITY_SCRIPT]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_ACTIVITY_SCRIPT_NOTIFICATION]  WITH CHECK ADD  CONSTRAINT [FK_TBL_ACTIVITY_SCRIPT_NOTIFICATION_TBL_ACTIVITY_SCRIPT] FOREIGN KEY([ACTIVITY_SCRIPT_ID])
REFERENCES [dbo].[TBL_ACTIVITY_SCRIPT] ([ACTIVITY_SCRIPT_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_ACTIVITY_SCRIPT_NOTIFICATION] CHECK CONSTRAINT [FK_TBL_ACTIVITY_SCRIPT_NOTIFICATION_TBL_ACTIVITY_SCRIPT]
GO
/****** Object:  ForeignKey [FK_TBL_REPORT_DATA_MAIL_COUNT_TBL_REPORT_DATA]    Script Date: 04/27/2010 17:43:06 ******/
ALTER TABLE [dbo].[TBL_REPORT_DATA_MAIL_COUNT]  WITH CHECK ADD  CONSTRAINT [FK_TBL_REPORT_DATA_MAIL_COUNT_TBL_REPORT_DATA] FOREIGN KEY([REPORT_DATA_ID])
REFERENCES [dbo].[TBL_REPORT_DATA] ([REPORT_DATA_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TBL_REPORT_DATA_MAIL_COUNT] CHECK CONSTRAINT [FK_TBL_REPORT_DATA_MAIL_COUNT_TBL_REPORT_DATA]
GO
