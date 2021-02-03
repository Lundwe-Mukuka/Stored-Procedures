 
/****** Object:  StoredProcedure [dbo].[spAssignment_Create]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAssignment_Create]
	@subjectId int,
	@gradeId int ,
	@TeacherId int,
	@Title nvarchar(500),
	@Deadline datetime2,
	@FilePath nvarchar(500)

AS
BEGIN
	SET NOCOUNT ON;

	Insert into dbo.Assignment
	(SubjectId,TeacherId,GradeID,Title,Deadline,FilePath)
	values (@subjectId,@TeacherId,@gradeId,@Title,@Deadline,@FilePath)

END
GO
/****** Object:  StoredProcedure [dbo].[spAssignment_Get]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAssignment_Get]
	@subjectId int= -1,
	@gradeId int= -1 ,
	@AssignmentId int= -1
AS 
begin
	set nocount on;

	IF (@AssignmentId > 0)
	BEGIN
		select a.Id,a.Title , s.Title,t.LastName,g.Title,a.Deadline,a.FilePath
		from dbo.Assignment a
		INNER JOIN dbo.Subject s
		on s.Id = a.SubjectId
		INNER JOIN dbo.Users t
		on t.Id = a.TeacherId
		INNER JOIN dbo.Grade g
		on g.Id = a.GradeID
		where a.Id = @AssignmentId
	END

	ELSE  
	BEGIN
		select a.Id,a.Title , s.Title as Subject,t.LastName as Teacher,g.Title as Grade,a.Deadline,a.FilePath
		from dbo.Assignment a
		INNER JOIN dbo.Subject s
		on s.Id = a.SubjectId
		INNER JOIN dbo.Users t
		on t.Id = a.TeacherId
		INNER JOIN dbo.Grade g
		on g.Id = a.GradeID
	END   

end
GO
/****** Object:  StoredProcedure [dbo].[spAssignment_GetSubmission]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAssignment_GetSubmission]
	@StudentId int=-1,
	@AssignmentId int=-1 ,
	@SubmissionId int =-1
AS 
begin
	set nocount on;

	IF (@SubmissionId > 0)
	BEGIN
		select * from dbo.AssignmentSubmission
		where id=@SubmissionId
	END

	ELSE  
	BEGIN
		select * from dbo.AssignmentSubmission
		where StudentId=@StudentId and AssignmentId=@AssignmentId
	END   

	select * from dbo.AssignmentSubmission
	where StudentId=@StudentId and AssignmentId=@AssignmentId

end
GO
/****** Object:  StoredProcedure [dbo].[spAssignment_GetUploads]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAssignment_GetUploads]
	@assignmentID int 
AS 
begin
	set nocount on;

	select * from dbo.Assignment
	where id=@assignmentID  

end
GO
/****** Object:  StoredProcedure [dbo].[spAttendance_Get]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAttendance_Get]  
	@StudentId int  = -1,
	@SubjectId int= -1,
	@gradeId int= -1

AS 
begin
	set nocount on;

		IF (@StudentId > 0)
		BEGIN
			select * from dbo.Attendance
			where StudentId = @StudentId; 
		END

		ELSE  
		BEGIN
			select * from dbo.Attendance
			where SubjectId=@subjectId and GradeId=@gradeId
		END   
end
GO
/****** Object:  StoredProcedure [dbo].[spGrade_Create]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGrade_Create]
  @Title nvarchar(100)

AS
begin
	set nocount on;

	Insert into dbo.Grade(Title)
	Values (@Title); 

end
GO
/****** Object:  StoredProcedure [dbo].[spGrade_Get]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGrade_Get] 
	@GradeId int = -1

AS 
begin
	set nocount on;

	IF (@GradeId > 0)
	BEGIN
	   select * from dbo.Grade where Id = @GradeId;
	END

	ELSE
	BEGIN
	   select * from dbo.Grade
	END

end
GO
/****** Object:  StoredProcedure [dbo].[spGrade_Teacher]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGrade_Teacher]
	@TeacherId int  
AS 
begin
	set nocount on;

	  select g.* 
	  from dbo.Grade  g
	  INNER JOIN dbo.TeacherSubjects ts
	  on g.Id = ts.GradeId
	  where ts.TeacherId = @TeacherId;  

end
GO
/****** Object:  StoredProcedure [dbo].[spStudent_Create&Edit]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spStudent_Create&Edit]
	@UserId int,
	@ExpectedAmount int,
	@ActualAmount int,
	@GradeId int,
	@Src nvarchar(50)

AS
begin
	set nocount on;

	IF (@Src = 'Create')
	BEGIN
		Insert into dbo.Student(StudentId,ExpectedAmount,ActualAmount,GradeId)
		Values (@UserId,@ExpectedAmount,@ActualAmount,@GradeId);
	END  

	ELSE IF (@Src = 'Edit')
	BEGIN 
	    update dbo.Student
		set ExpectedAmount=@ExpectedAmount,ActualAmount=@ActualAmount,GradeId=@GradeId 
		where StudentId=@UserId; 
	END  

	ELSE IF (@Src = 'Delete')
	BEGIN 
	    Delete from dbo.Student
		Where StudentId=@UserId 
	END  
end
GO
/****** Object:  StoredProcedure [dbo].[spStudent_Get]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spStudent_Get]
	@StudentId int = -1

AS 
begin
	set nocount on;

	IF (@StudentId > 0)
	BEGIN
	   select s.StudentId,s.GradeId,s.ExpectedAmount,s.ActualAmount,g.Title as GradeTitle
	   from dbo.Student s  
	   Inner Join dbo.Grade g
	   on g.Id = s.GradeId
	   where StudentId = @StudentId;
	END

	ELSE
	BEGIN
	   select s.StudentId,s.GradeId,s.ExpectedAmount,s.ActualAmount,g.Title as GradeTitle
	   from dbo.Student s  
	   Inner Join dbo.Grade g
	   on g.Id = s.GradeId
	END

end
GO
/****** Object:  StoredProcedure [dbo].[spStudent_GetAttendance]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spStudent_GetAttendance]
	@StudentId int 
AS 
begin
	set nocount on;

	select * from dbo.Attendance
	where Studentid =@StudentId 

end
GO
/****** Object:  StoredProcedure [dbo].[spSubject_Create]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSubject_Create]
	  @Title nvarchar(100)

AS
begin
	set nocount on;

	Insert into dbo.Subject(Title)
	Values (@Title); 

end
GO
/****** Object:  StoredProcedure [dbo].[spSubject_Edit]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSubject_Edit]
	@SubjectId int,
	@Title nvarchar(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Update dbo.Subject 
	set Title = @Title
	where Id=@SubjectId;

END
GO
/****** Object:  StoredProcedure [dbo].[spSubject_Get]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSubject_Get]
	@SubjectId int = -1

AS 
begin
	set nocount on;

	IF (@SubjectId > 0)
	BEGIN
	   select * from dbo.Subject where Id = @SubjectId;
	END

	ELSE
	BEGIN
	   select * from dbo.Subject
	END

end
GO
/****** Object:  StoredProcedure [dbo].[spSubject_Teacher]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSubject_Teacher]
	@TeacherId int  = -1,
	@SubjectId int = -1
AS 
begin
	set nocount on;

		IF (@TeacherId > 0)
		BEGIN
			select s.* 
			from dbo.Subject  s
			INNER JOIN dbo.TeacherSubjects ts
			on s.Id = ts.SubjectId
			where ts.TeacherId = @TeacherId; 
		END

		ELSE IF (@SubjectId > 0)
		BEGIN
			select u.* 
			from dbo.Users  u
			INNER JOIN dbo.TeacherSubjects ts
			on u.Id = ts.TeacherId
			where ts.SubjectId = @SubjectId; 
		END  

end
GO
/****** Object:  StoredProcedure [dbo].[spTeacher_Create&Edit]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTeacher_Create&Edit]
	@UserId int,
	@Salary int,
	@Qualification  nvarchar(300),
	@Src nvarchar(50)

AS
begin
	set nocount on;

	IF (@Src = 'Create')
	BEGIN
		Insert into dbo.Teacher(TeacherId,Salary,Qualification)
		Values (@UserId,@Salary,@Qualification);
	END 

	ELSE IF (@Src = 'Edit')
	BEGIN 
	    update dbo.Teacher
		set Salary=@Salary,Qualification=@Qualification 
		where TeacherId=@UserId; 
	END    

	ELSE IF (@Src = 'Delete')
	BEGIN 
	    Delete from dbo.Teacher
		Where TeacherId=@UserId 
	END  

end
GO
/****** Object:  StoredProcedure [dbo].[spTeacher_Get]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTeacher_Get]
	@TeacherId int = -1

AS 
begin
	set nocount on;

	IF (@TeacherId > 0)
	BEGIN
	   select * from dbo.Teacher where TeacherId = @TeacherId;
	END

	ELSE
	BEGIN
	   select * from dbo.Teacher 
	END

end
GO
/****** Object:  StoredProcedure [dbo].[spTeacherSubject_Create&Edit]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[spTeacherSubject_Create&Edit]
	@TeacherId int,
	@GradeId int,
	@SubjectId int,
	@Src nvarchar(50)

AS
begin
	set nocount on;

	IF (@Src = 'Create')
	BEGIN
		Insert into dbo.TeacherSubjects(TeacherId,GradeId,SubjectId)
		Values (@TeacherId,@GradeId,@SubjectId);
	END 

	ELSE IF (@Src = 'Edit')
	BEGIN 
	    update dbo.TeacherSubjects
		set TeacherId=@TeacherId,GradeId=@GradeId 
		where TeacherId=@TeacherId; 
	END 
	
	ELSE IF (@Src = 'Delete')
	BEGIN 
	    Delete from dbo.TeacherSubjects
		Where TeacherId=@TeacherId AND GradeId=@GradeId
	END  

end
GO
/****** Object:  StoredProcedure [dbo].[spUser_Create&Edit]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUser_Create&Edit]
	@FirstName nvarchar(100),
	@LastName nvarchar(100),
	@EmailAddress nvarchar(100),
	@Gender nvarchar(100),
	@NRC nvarchar(100),
	@phoneNumber nvarchar(100),
	@HomeAddress nvarchar(100),
	@Id int = -1

AS
begin
	set nocount on;

	--Edit User
	IF (@Id > 0)
	BEGIN
	    update dbo.Users
		set FirstName=@FirstName,LastName=@LastName,Email=@EmailAddress,
		Gender=@Gender,NRC=@NRC,PhoneNumber=@phoneNumber,HomeAddress=@HomeAddress
		where Id=@Id; 
	END

	--create user
	ELSE
	BEGIN
		Insert into dbo.Users(FirstName,LastName,Email,Gender,NRC,PhoneNumber,
		HomeAddress)
		OUTPUT INSERTED.ID
		values (@FirstName,@LastName,@EmailAddress,
		@Gender,@NRC,@phoneNumber,@HomeAddress);
	END 

end
GO
/****** Object:  StoredProcedure [dbo].[spUser_Get]    Script Date: 2/3/2021 10:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUser_Get]
	@UserId int = -1

AS 
begin
	set nocount on;

	IF (@UserId > 0)
	BEGIN
	   select * from dbo.Users where Id = @UserId;
	END

	ELSE
	BEGIN
	   select * from dbo.Users  
	END

end
GO
USE [master]
GO
ALTER DATABASE [OctodutyDatabase] SET  READ_WRITE 
GO
