CREATE TABLE [Employees] (
[ID] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50),
[Position] NVARCHAR(50),
[Department] NVARCHAR(50)
);
CREATE TABLE [EmployeeDetails] (
[ID] INT PRIMARY KEY IDENTITY,
[EmployeeID] INT FOREIGN KEY REFERENCES [Employees] ([ID]),
[Email] NVARCHAR(50),
[PhoneNumber] NVARCHAR(15)
);

--1 
Create procedure AddEmployee
	@Name NVARCHAR(50),
	@Position NVARCHAR(50),
	@Department NVARCHAR(50),
	@Email NVARCHAR(50),
	@PhoneNumber NVARCHAR(15)
	as
	begin
	INSERT INTO [Employees] ([Name], [Position], [Department])
		VALUES (@Name, @Position, @Department);
		DECLARE @EmployeeID INT = SCOPE_IDENTITY();
		INSERT INTO [EmployeeDetails] ([EmployeeID], [Email], [PhoneNumber])
		VALUES (@EmployeeID, @Email, @PhoneNumber);
	end;
	go
exec 
AddEmployee 'John Doe', 'Software Engineer', 'IT', 'john@gmail.com' '0991234567'

--2
Create procedure GetEmployee
as 
begin
	SELECT e.[ID], e.[Name], e.[Position], e.[Department], d.[Email], d.[PhoneNumber]
	FROM [Employees] e
	inner JOIN [EmployeeDetails] d ON e.[ID] = d.[EmployeeID];
end;
GO
exec GetEmployee;

--3
Create procedure UpdateEmployee
	@ID INT,
	@Name NVARCHAR(50),
	@Position NVARCHAR(50),
	@Department NVARCHAR(50),
	@Email NVARCHAR(50),
	@PhoneNumber NVARCHAR(15)
	as
	begin
	UPDATE [Employees]
	SET [Name] = @Name, [Position] = @Position, [Department] = @Department
	WHERE [ID] = @ID;
	UPDATE [EmployeeDetails]
	SET [Email] = @Email, [PhoneNumber] = @PhoneNumber
	WHERE [EmployeeID] = @ID;
	end;
	go
	exec UpdateEmployee 1, 'Jane Doe', 'Senior Software Engineer', 'IT'

--4
Create procedure DeleteEmployee
	@ID INT
	as
	begin
	DELETE FROM [EmployeeDetails] WHERE [EmployeeID] = @ID;
	DELETE FROM [Employees] WHERE [ID] = @ID;
	end;
	go
	exec DeleteEmployee 1;

--5
Create procedure SearchEmployee
@Department NVARCHAR(50) = Null
@Position NVARCHAR(50) = Null
as
begin
Select * from [Employees] WHERE (@Department IS NULL OR Department = @Department) AND (@Position IS NULL OR Position = @Position)
end;
go
exec SearchEmployee 
@Department = 'IT'
@Position = 'Software Engineer'

--6
Create procedure GetContactInfo
@EmployeeID INT,
@Email NVARCHAR(50) OUTPUT,
@PhoneNumber NVARCHAR(15) OUTPUT
AS 
BEGIN
	SELECT @Email = [Email], @PhoneNumber = [PhoneNumber]
	FROM [EmployeeDetails]
	WHERE [EmployeeID] = @EmployeeID;
END;
Go
Declare @Email NVARCHAR(50), @PhoneNumber NVARCHAR(15);
Exec GetContactInfo 1 , @Email = @Email OUTPUT,@PhoneNumber = @PhoneNumber OUTPUT;
Select @Email as Email, @PhoneNumber as PhoneNumber;