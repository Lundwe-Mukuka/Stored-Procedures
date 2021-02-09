USE [OctodutyDatabase]
GO
/****** Object:  StoredProcedure [dbo].[spTimeTable_Create&Edit]    Script Date: 2/9/2021 11:37:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spTimeTable_Create&Edit]
	@GradeId int=-1,
	@TeacherId int=-1,
	 @SubjectId int=-1,
	 @DayId int=-1,
	 @TimeId int=-1, 
	 @Id int=-1,
	@Src nvarchar(50)

AS
begin
	set nocount on;

	IF (@Src = 'Create')
	BEGIN
		Insert into dbo.TimeTable(TeacherId,SubjectId,DayId,TimeId,GradeId)
		Values (@TeacherId,@SubjectId,@DayId,@TimeId,@GradeId);
	END 

	ELSE IF (@Src = 'Edit')
	BEGIN 
	    update dbo.TimeTable
		set SubjectId=@SubjectId,TeacherId=@TeacherId 
		where Id=@Id; 
	END    

	ELSE IF (@Src = 'Delete')
	BEGIN  
		 Delete from dbo.TimeTable
		Where Id=@Id 
	END  

end
