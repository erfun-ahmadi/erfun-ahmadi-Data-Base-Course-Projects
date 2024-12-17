-- 1
SELECT DISTINCT E.FirstName, E.LastName
FROM `Employee` E, `Customer` C, `Order` O
WHERE E.EmployeeID = O.EmployeeID AND C.CustomerID = O.CustomerID AND C.City = E.City;

-- 2
SELECT S.CompanyName, COUNT(O.OrderID) AS OrderCount
FROM `Shipper` S, `Order` O
WHERE O.ShipVia = S.ShipperID
GROUP BY S.ShipperID;

-- 3
SELECT C.CustomerID, C.ContactName, COUNT(O.OrderID) AS OrderCount
FROM `Customer` C, `Order` O
WHERE O.CustomerID = C.CustomerID
GROUP BY C.CustomerID
ORDER BY OrderCount DESC
LIMIT 2;

-- 4
SELECT P.ProductName, P.ProductID, SUM(Od.Quantity) AS OrderCount
FROM `Product` P, `order detail` Od
WHERE Od.ProductID = P.ProductID and P.Discontinued = 0
GROUP BY P.ProductID
ORDER BY OrderCount ASC
LIMIT 1;

-- 5
SELECT C.CustomerID, SUM(Od.Quantity * Od.UnitPrice) AS TotalPrice
FROM `Customer` C, `order detail` Od, `Product` P, `Category` Cat, `Order` O
WHERE C.CustomerID = O.CustomerID and O.OrderID = Od.OrderID and Od.ProductID = P.ProductID and P.CategoryID = Cat.CategoryID and Cat.CategoryName = 'Condiments'
GROUP BY C.CustomerID;

-- 6
SELECT E.EmployeeID, E.FirstName, E.LastName, COUNT(ET.TerritoryID) AS TotalTerritory
FROM `Employee` E, `employeeterritory` ET
WHERE E.EmployeeID = ET.EmployeeID 
GROUP BY E.EmployeeID
HAVING TotalTerritory > 3;

-- 7
SELECT AVG(E1.Salary) AS AvgSalary
FROM `Employee` E1
WHERE E1.EmployeeID IN (
    SELECT DISTINCT E2.ReportsTo 
    FROM `Employee` E2 
    WHERE E2.ReportsTo IS NOT NULL
);


-- 8
SELECT DISTINCT O.CustomerID, Od.UnitPrice AS MostExpensiveProduct, Od.ProductID 
FROM `Order` O, `order detail` Od
WHERE O.OrderID = Od.OrderID and (O.CustomerID, Od.UnitPrice) IN (
    SELECT O.CustomerID, MAX(Od.UnitPrice)
    FROM `Order` O, `order detail` Od
    WHERE O.OrderID = Od.OrderID
    GROUP BY O.CustomerID
);

-- 9
SELECT C.CategoryName, P.ProductID, P.ProductName, P.UnitPrice As MostExpensice
FROM `Product` P, `Category` C
WHERE P.CategoryID = C.CategoryID and (P.CategoryID, P.UnitPrice) IN (
	SELECT CategoryID, MAX(UnitPrice)
    FROM `Product` 
    GROUP BY CategoryID
);

-- 10
SELECT DISTINCT E1.EmployeeID
FROM `Employee` E1, `Employee` E2, `Employee` E3
WHERE E2.ReportsTo = E1.EmployeeID and E3.ReportsTo = E1.EmployeeID and E2.EmployeeID != E3.EmployeeID and E2.Salary BETWEEN 1700 AND 2000;

-- 11
SELECT DISTINCT E1.EmployeeID
FROM `Employee` E1, `Employee` E2
WHERE E2.ReportsTo = E1.EmployeeID and E2.Salary BETWEEN 1700 AND 2000
GROUP BY E1.EmployeeID
HAVING COUNT(E2.EmployeeID) > 1;

-- 12
CREATE VIEW ShipperOrderSentCount(ShipperID, TotalOrders)
	AS SELECT S.ShipperID, COUNT(O.OrderID) 
    FROM `Order` O, `Shipper` S
    WHERE O.ShipVia = S.ShipperID
    GROUP BY S.ShipperID;
    
-- 13
CREATE VIEW CustomersWithMoreThanFiveOrders(CustomerID, ContactName, ToatalOrders)
	AS SELECT C.CustomerID, C.ContactName, COUNT(O.OrderID)
    FROM `Customer` C, `Order` O
    WHERE O.CustomerID = C.CustomerID
    GROUP BY O.CustomerID
    HAVING COUNT(O.OrderID) > 5;
    
-- 14
CREATE VIEW ProductCostMoreTanAvg(ProductID, ProductName, UnitPrice, CategoryName)
	AS SELECT P.ProductID, P.ProductName, P.UnitPrice, C.CategoryName
    FROM `Product` P, `Category` C
	WHERE P.CategoryID = C.CategoryID and P.UnitPrice > (
		SELECT Avg(P2.UnitPrice)
        FROM `Product` P2
        WHERE P2.CategoryID = C.CategoryID);
        
-- 15
DELIMITER //
CREATE TRIGGER IncreaseDrSalary BEFORE UPDATE ON `Employee`
	FOR EACH ROW
	BEGIN 
		IF (NEW.TitleOfCourtesy = 'Dr.' and OLD.TitleOfCourtesy != 'Dr.') THEN
			SET NEW.Salary = OLD.Salary * 1.2;
		END IF;
	END;//
DELIMITER ;
    
-- 16
DELIMITER //
CREATE TRIGGER NotDeleteLastProductOfCategory BEFORE DELETE ON `Product`
	FOR EACH ROW
	BEGIN
		IF (SELECT COUNT(*) FROM `Product` WHERE CategoryID = OLD.CategoryID) <= 1 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Cannot delete last product in a category!';
		END IF;
	END;//
DELIMITER ;

-- 17
DELIMITER //
CREATE TRIGGER EditDiscontinuedProducts BEFORE UPDATE ON `Product`
	FOR EACH ROW
	BEGIN
		CASE
			WHEN (NEW.UnitsInStock = 0) THEN
				SET NEW.Discontinued = 1;
			WHEN (NEW.UnitsInStock > 0) THEN
				SET NEW.Discontinued = 0;
		END CASE;
	END;//
DELIMITER ;


