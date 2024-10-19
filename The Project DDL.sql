 --ID-1280982_(Ashik) DDL

 --QUESTION NO 1
CREATE DATABASE PurchaseDB
ON (
	Name= 'PurchaseDB_Data_1',
	FileName='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\PurchaseDB_Data_1.mdf',
	Size= 25MB,
	MaxSize= 100MB,
	FileGrowth= 5%
)
LOG ON (
	Name= 'PurchaseDB_Log_1',
	FileName='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\PurchaseDB_Log_1.ldf',
	Size= 2MB,
	MaxSize= 25MB,
	FileGrowth= 1%
)
GO


USE PurchaseDB
GO

CREATE TABLE Customer_T
(
	CustomerID int PRIMARY KEY NONCLUSTERED, 	CustomerFName  varchar(20) NOT NULL ,
	CustomerLName varchar(20) NOT NULL ,
	CustomerPhone varchar(11) NOT NULL UNIQUE
)
GO

CREATE TABLE Car_T
(
	CarID int NOT NULL UNIQUE,
	CarModelName varchar(20) NOT NULL ,
	CarModelYear int NOT NULL,
	CarManufaturer varchar(20) NOT NULL,
	PRIMARY KEY(CarID,CarModelName,CarModelYear)
)
GO

CREATE TABLE Purchase_T
(
	PurchaseID int PRIMARY KEY IDENTITY (1001,1),
	CustomerID int REFERENCES Customer_T(CustomerID),
	CarID int REFERENCES Car_T(CarID),
	PurchaseDate date NOT NULL ,
	Price money NOT NULL ,
	CarLoan money NOT NULL ,
	DeliveryDate date NOT NULL
)
GO 

--5. Write a script to delete a table.

DROP TABLE Purchase_T
GO


--6. Write a script to delete a column.   

ALTER TABLE Purchase_T
DROP COLUMN Price
GO


--9. Create a view to show all the information in a meaning full order where the customer is Jhon Doe. 

CREATE VIEW JhonDoe
AS
SELECT  P.CustomerID, CustomerFName+' '+CustomerLName AS Customer, CarModelName, CustomerPhone,
Price, CarModelYear, PurchaseDate, CarManufaturer,CarLoan, DeliveryDate
FROM Purchase_T AS P JOIN Customer_T AS C 
ON P.CustomerID=C.CustomerID
JOIN Car_T AS Ca 
ON Ca.CarID=P.CarID
WHERE C.CustomerID IN
(SELECT CustomerID FROM Customer_T WHERE CustomerFName='Jhon')

SELECT * FROM JhonDoe
GO


--10. Create stored procedures to insert, update, delete data for any one of the table of your database and show use of output parameter.  

CREATE PROC spInsertUpdateDeleteAndOutput
	@Functionality varchar(20)='',
	@CustomerID int ,
	@CustomerFName varchar(20),
	@CustomerLName varchar(20),
	@CustomerPhone varchar(11)
AS 
	IF @Functionality='SELECT'
	BEGIN 
SELECT * FROM Customer_T
		END
IF @Functionality='INSERT'
BEGIN TRY
INSERT INTO Customer_T VALUES (@CustomerID,	@CustomerFName,@CustomerLName,@CustomerPhone)
	END TRY
	BEGIN CATCH 
	SELECT ERROR_LINE() AS ErrorLine,
	ERROR_MESSAGE() AS ErrorMessage,
	ERROR_SEVERITY() AS ErrorSeverity
		END CATCH
	IF @Functionality='UPDATE'
		BEGIN TRY
	UPDATE  Customer_T SET CustomerPhone=@CustomerPhone
	WHERE CustomerID=@CustomerID
	END TRY
		BEGIN CATCH 
	SELECT ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage,
		ERROR_SEVERITY() AS ErrorSeverity
		END CATCH
	IF @Functionality='DELETE'
		BEGIN
		DELETE Customer_T 
		WHERE CustomerID=@CustomerID
		END 
GO




---11. Create a Clustered Index in any one of the table.

CREATE CLUSTERED INDEX ix_Customer_T
	ON Customer_T(CustomerFName)
GO 
EXEC sp_helpindex Customer_T
go

--12. Create a Scalar Function to get the Date difference from sale date to current date. 

create function MyFunction(@ashik int)
Returns int 
begin
return
(select DATEDIFF(MONTH,PurchaseDate,getdate()) from Purchase_T
where PurchaseID=@ashik)
end

print dbo.MyFunction(101)
go

 --13. Create trigger on Insert, update, delete of any one table of you database.
CREATE TABLE Purchase_T_trigger
(
	PurchaseID int ,
	CustomerID int ,
	CarID int ,
	PurchaseDate date NOT NULL ,
	Price money NOT NULL ,
	CarLoan money NOT NULL ,
	DeliveryDate date NOT NULL
)
GO 


create trigger tgMyTrigger
on Purchase_T
after delete 
as 
begin 
	Insert into Purchase_T_trigger(PurchaseID  ,CustomerID  ,CarID  ,PurchaseDate ,Price  ,CarLoan,DeliveryDate)
	Select PurchaseID  ,CustomerID  ,CarID  ,PurchaseDate ,Price ,CarLoan,DeliveryDate from deleted
end

Delete from Purchase_T
where PurchaseID=1001
go


--15. Create a Table valued Function to get Customer wise detail information.
 USE PurchaseDB
 GO
Create function fnTable()
Returns table
as
return
 (SELECT CustomerID,CustomerFName,count(CustomerID) as countCustomer
 FROM Customer_T 
 group by CustomerID,CustomerFName)
 go

 select * from fnTable()
