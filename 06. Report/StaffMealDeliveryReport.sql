/***
 *** Course: DBMS-2006 (254354) Database Management Systems 2
 *** Name: Ma Crizza Lynne Regacho
 *** Final Project
 *** Date: 2024-11-20
 ***/

-- =========================================
-- Switch to FinalProject
-- 7.1 Use a batch file to retrieve data from database to produce a text report
-- =========================================


USE FinalProject;

SET NOCOUNT ON;

DECLARE @StaffID INT;
SET @StaffID = $(StaffID);

PRINT @StaffID;

SELECT 
    mdl.DeliveryID, 
    rp.FirstName AS "Resident First Name", 
    rp.LastName AS "Resident Last Name", 
    mdl.DeliveryDateTime AS "Delivery Date", 
    mm.MealName AS "Meal Name", 
    s.FirstName AS "Staff First Name", 
    s.LastName AS "Staff Last Name"
FROM 
    ResidentProfiles rp 
    JOIN MealDeliveryLogs mdl ON rp.ResidentID = mdl.ResidentID
    JOIN MealMenu mm ON mm.MealID = mdl.MealID
    JOIN Staff s ON s.StaffID = mdl.StaffID
WHERE 
    s.StaffID = @StaffID
GROUP BY 
    mdl.DeliveryID, 
    rp.FirstName, 
    rp.LastName, 
    mdl.DeliveryDateTime, 
    mm.MealName, 
    s.FirstName, 
    s.LastName
ORDER BY 
    mdl.DeliveryID;