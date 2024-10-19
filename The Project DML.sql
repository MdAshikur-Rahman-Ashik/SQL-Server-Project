 --ID-1280982_(Ashik) DML

 --2. Insert Records into tables using Script

INSERT INTO Customer_T(CustomerID ,CustomerFName ,CustomerLName  ,CustomerPhone)
VALUES 
	(101, 'Jhon', 'Deo','5551234'),
	(102, 'Jane', 'Smith','5551235'),
	(103, 'Frank', 'Lee','5551236')
GO

INSERT INTO Car_T (CarID ,CarModelName ,CarModelYear ,CarManufaturer)
VALUES 
	(201,'Fusion', 2015, 'Ford'),
	(202,'Impale', 2015, 'Charry'),
	(203,'Accord', 2014, 'Honda'),
	(204,'Accord', 2015, 'Honda')
GO

INSERT INTO Purchase_T(CustomerID ,CarID ,PurchaseDate, Price ,CarLoan ,DeliveryDate )
VALUES 
	(101,201,'2023-01-01', 5000000, 5000000*.5, DATEADD(Month, 2,'2023-01-01') ),
	(102,202,'2023-01-03', 5400000, 5400000*.6, DATEADD(Month, 2,'2023-01-03') ),
	(103,203,'2023-02-01', 6000000, 6000000*.6, DATEADD(Month, 2,'2023-02-01') ),
	(101,204,'2023-03-01', 7000000, 7000000*.7, DATEADD(Month, 2,'2023-03-01') )
GO

--3.Write a delete query for any one table of your project.

DELETE FROM Purchase_T
	WHERE Price=5000000
GO


--4. Write an update query for any one table of your project.


UPDATE Purchase_T
SET PurchaseDate='2023-02-01' , DeliveryDate=DATEADD(Month, 2,'2023-02-01')
WHERE Price=5000000
GO

--7. Write a join query to show Manufacturer wise car information using Group By and Having Clause
USE PurchaseDB
GO
SELECT   CarModelName,  CarManufaturer, COUNT(P.CustomerID) AS TotalCustomer
FROM Purchase_T AS P JOIN Customer_T AS C 
ON P.CustomerID=C.CustomerID
JOIN Car_T AS Ca 
ON Ca.CarID=P.CarID
GROUP BY CarModelName, CarManufaturer
GO


--8. Write a sub-query to show all the information of Supplier Model- Accord
USE PurchaseDB
GO
SELECT  P.CustomerID, CustomerFName+' '+CustomerLName AS Customer, CarModelName, CustomerPhone, 
Price, CarModelYear, PurchaseDate, CarManufaturer,CarLoan, DeliveryDate
FROM Purchase_T AS P JOIN Customer_T AS C 
ON P.CustomerID=C.CustomerID
JOIN Car_T AS Ca 
ON Ca.CarID=P.CarID
WHERE Ca.CarID IN
(SELECT CarID FROM Car_T WHERE CarModelName='Accord')
GO



--16. Show process of handling error in question number

BEGIN TRY 
	INSERT INTO Customer_T(CustomerID ,CustomerFName ,CustomerLName  ,CustomerPhone)
	VALUES (108, 'shefine', 'bro','5551288')
	PRINT 'Execueed Successfully'
END TRY 
BEGIN CATCH 
	SELECT ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage,
		ERROR_SEVERITY() ErrorSeverity
END CATCH
GO

--17. Create a CTE.


WITH MrJhon AS
(
	SELECT  P.CustomerID, CustomerFName+' '+CustomerLName AS Customer, CarModelName, CustomerPhone, Price, CarModelYear, PurchaseDate, CarManufaturer,CarLoan, DeliveryDate
	FROM Purchase_T AS P JOIN Customer_T AS C 
	ON P.CustomerID=C.CustomerID
	JOIN Car_T AS Ca 
	ON Ca.CarID=P.CarID
	WHERE C.CustomerID IN
	(SELECT CustomerID FROM Customer_T WHERE CustomerFName='Jhon')
)

SELECT * FROM MrJhon
GO

--18.Create a simple Case and a Search Case
select purchaseID,carID,
case
when price>5400000 then 'good price'
when price>6000000 then 'well price'
end as ashik
from Purchase_T
go

--19. Create a Cursor to insert data into any one table of you database.


DECLARE @CusID int, 
@CusFName varchar(20),
@CusLName varchar(20),
@CusPhone varchar(11),
@ShowCount int;

SET @ShowCount=0

DECLARE MyProcedure CURSOR 
FOR 
	SELECT * FROM Customer_T

OPEN MyProcedure
	FETCH NEXT FROM MyProcedure INTO @CusID, @CusFName, @CusLName, @CusPhone
	WHILE @@FETCH_STATUS<> -1
BEGIN 
IF @CusFName LIKE 'J%'
	BEGIN 
PRINT @CusID
SET @ShowCount=@ShowCount+1
END
	FETCH NEXT FROM MyProcedure INTO @CusID, @CusFName, @CusLName, @CusPhone
	END 	
CLOSE MyProcedure
DEALLOCATE MyProcedure

PRINT '';
PRINT convert(varchar, @ShowCount)+ ' Row(s) Created'
GO

--20. Create a new table and set Merge for any one table of you project.

CREATE TABLE Car11_T
(
	CarID int NOT NULL UNIQUE,
	CarModelName varchar(20) NOT NULL ,
	CarModelYear int NOT NULL,
	CarManufaturer varchar(20) NOT NULL
	PRIMARY KEY(CarID,CarModelName,CarModelYear)
)

insert into Car11_T values
(522,'honda',2003,'bmw'),
(566,'tvs',2005,'mg'),
(570,'shefine',2020,'uuu')
go

--drop table Car11_T

MERGE Car_T AS t
USING Car11_T AS s
ON t.CarID=s.CarID
WHEN MATCHED AND t.CarModelName<>s.CarModelName
OR t.CarModelYear<>s.CarModelYear
THEN UPDATE SET t.CarModelName=s.CarModelName,
 t.CarModelYear=s.CarModelYear
 WHEN NOT MATCHED 
 THEN INSERT (CarID,CarModelName,CarModelYear,CarManufaturer) VALUES
 (s.CarID,s.CarModelName,s.CarModelYear,s.CarManufaturer);
 go

 --10. Create stored procedures to insert, update, delete data for any one of the table of your database and show use of output parameter. 

 EXEC spInsertUpdateDeleteAndOutput 'SELECT','','','','';
EXEC spInsertUpdateDeleteAndOutput 'INSERT','104','MD','SHEFAIN','5551237';
EXEC spInsertUpdateDeleteAndOutput 'INSERT','105','Samia','Akter','019074413101';
EXEC spInsertUpdateDeleteAndOutput 'Delete','104','','','';
EXEC spInsertUpdateDeleteAndOutput 'UPDATE','105','','','019074413102';

GO

 --write a query to retrieve Purchase_T from 2023-01-03 to 2023-03-01

 USE PurchaseDB
 GO
 SELECT PurchaseID,PurchaseDate,Price FROM Purchase_T
 WHERE PurchaseDate BETWEEN '2023-01-03' AND '2023-03-01'
 GO
 --write a query to retrieve Customer_T Whose CustomerFName starts with 'j'
 use PurchaseDB
 go
 select CustomerID,CustomerFName from Customer_T
 where CustomerFName like 'J%'
 GO

 --write a query to retrieve Customer_T Whose Contact name has one of the following characters: j,f,d,s,l.
use PurchaseDB
 go
 select CustomerID,CustomerFName,CustomerLName from Customer_T
 where CustomerFName like '[JFDSL]%'
 GO

 --write a query to find all Car_t whose first letter of CarModelName starts with A and the next letter is one of A through J.

 USE PurchaseDB
 GO
 SELECT CarID,CarModelName,CarModelYear FROM Car_T
 WHERE CarModelName LIKE 'A[a-j]%'
 GO

 --write a query to find all Car_t whose first letter of CarModelName starts with A and the next letter is not in  O through R.

  USE PurchaseDB
 GO
 SELECT CarID,CarModelName,CarModelYear FROM Car_T
 WHERE CarModelName LIKE 'A[^O-R]%'
 GO

 --write a query to retrieve  2 through 3 records of Purchase_T

 use PurchaseDB
 go
 select PurchaseDate,price 
 from Purchase_T
 ORDER BY PurchaseID
 OFFSET 2 ROWS
 FETCH NEXT 3 ROWS ONLY 
GO

--CUBE Operator

SELECT CarModelName,CarManufaturer,COUNT(CarID) CarCount 
FROM Car_T
WHERE CarManufaturer IN ('Ford','Honda')
GROUP BY CUBE(CarModelName,CarManufaturer)
ORDER BY CarModelName DESC, CarManufaturer DESC
go

--RollUp operator

SELECT CarModelName,CarManufaturer,COUNT(CarID) CarCount 
FROM Car_T
WHERE CarManufaturer IN ('Ford','Honda')
GROUP BY ROLLUP(CarModelName,CarManufaturer)
ORDER BY CarModelName DESC, CarManufaturer DESC
go

--Grouping sets operator

SELECT CarModelName,CarManufaturer,COUNT(CarID) as CarCount 
FROM Car_T
WHERE CarManufaturer IN ('Ford','Honda')
GROUP BY GROUPING SETS(CarModelName,CarManufaturer)
ORDER BY CarModelName DESC, CarManufaturer DESC
go

--ANY
USE PurchaseDB
go
SELECT c.CustomerFName, PurchaseDate,Price
FROM Purchase_T p join Customer_T c 
ON p.CustomerID=c.CustomerID
AND p.Price<ANY
(SELECT Price FROM Purchase_T WHERE CustomerID=101)
go

--All

USE PurchaseDB
go
SELECT c.CustomerFName, PurchaseDate,Price
FROM Purchase_T p join Customer_T c 
ON p.CustomerID=c.CustomerID
AND p.Price<ALL
(SELECT Price FROM Purchase_T WHERE CustomerID=101)
go

--SOME
USE PurchaseDB
go
SELECT c.CustomerFName, PurchaseDate,Price
FROM Purchase_T p join Customer_T c 
ON p.CustomerID=c.CustomerID
AND p.Price<some
(SELECT Price FROM Purchase_T WHERE CustomerID=101)
go


---Over clause
USE PurchaseDB
go
SELECT PurchaseID,PurchaseDate,Price,
SUM(Price) OVER(order by PurchaseDate) AS DatePrice,
AVG(Price) OVER(order by PurchaseDate) AS DateAvgPrice
FROM Purchase_T
go


--write a subquary to retrieve Customar_t who have Purchase_T
USE PurchaseDB
go
SELECT CustomerFName,CustomerLName,CustomerPhone 
FROM Customer_T WHERE CustomerID NOT IN 
(SELECT CustomerID FROM Purchase_T)
go


--Correlated Subquery
use PurchaseDB
go
SELECT PurchaseID,PurchaseDate,Price 
FROM Purchase_T AS Pur_MAIN
WHERE Price>
(SELECT AVG(Price) FROM Purchase_T Pur_Sub
WHERE Pur_MAIN.CustomerID=Pur_Sub.CustomerID
)
go


--EXISTS Operator
USE PurchaseDB
GO
SELECT CustomerID,CustomerFName,CustomerLName,CustomerPhone 
FROM Customer_T WHERE EXISTS 
(SELECT * FROM Purchase_T WHERE Purchase_T.CustomerID=Customer_T.CustomerID)
go

--write a group query to retrieve Purchase_T those average of price is more than 5400000
USE PurchaseDB
go
SELECT CustomerID,AVG(Price) AS AvgPrice 
FROM Purchase_T
GROUP BY CustomerID
HAVING AVG(Price)>5400000
ORDER BY AVG(Price) DESC
go