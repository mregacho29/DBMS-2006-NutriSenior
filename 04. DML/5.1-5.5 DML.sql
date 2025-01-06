/***
 *** Course: DBMS-2006 (254354) Database Management Systems 2
 *** Name: Ma Crizza Lynne Regacho
 *** Final Project
 *** Date: 2024-11-20
 ***/

 -- =========================================
-- Switch to FinalProject
-- =========================================

USE FinalProject;
GO



-- =============================================
-- 5.1.2 Write a query (inner) to retrieve data from 3 or more tables
-- Purpose: Get detailed info about meal deliveries made by
-- Staff Members. With this query it will make sure that only
-- records with matching entry in all 3 tables (MealDeliveryLogs, 
-- MealMenu and Staff) will appear in the result set.
-- =============================================

SELECT
	-- shorten MealDeliveryLogs to mdl
	-- shorten MealMenu to mm
	-- shorten Staff to s
	mdl.DeliveryID AS 'Delivery ID',
	mm.MealName AS 'Meal Name',
	mdl.DeliveryDateTime AS 'Delivery Date and Time',
	CONCAT(s.FirstName, ' ', s.LastName) AS 'Staff Name',
	s.Role AS 'Staff Role'
FROM
	MealDeliveryLogs mdl
INNER JOIN -- Join MealMenu and MealDeliveryLog bases on the MealID
	MealMenu mm 
	ON mdl.MealID = mm.MealID
INNER JOIN -- Join Staff and MealDeliveryLog bases on the StaffID
	Staff s 
	ON mdl.StaffID = s.StaffID




-- =============================================
-- 5.2.2 Write a query (outer join) to retrieve data from 3 or more tables
-- 
-- We combine ResidentProfile, ResidentDietaryInfo and MealDietCompatibility, MealMenu
-- It makes sure we have ALL residents included in the result set
-- even if there is no matching entries (NULL) in the 
-- ResidentDietaryInfo and MealDietCompatibility, MealMenu
--
-- PURPOSE:
-- Goal is to have the complete information of all residents even if they do not
-- have dietary information. Make sure as well to identify residents that
-- have no dietary
-- =============================================

SELECT 
    rp.ResidentID AS 'Resident ID',
    CONCAT(rp.FirstName, ' ', rp.LastName) AS 'Resident Name',
    rdi.DietaryType AS 'Dietary Type',
    rdi.InfoDetail AS 'Diet Info Details',
    mm.MealName AS 'Meal Name'
FROM 
    ResidentProfiles rp
LEFT JOIN -- all resident profile included even if theres no matching record on RDI
    ResidentDietaryInfo rdi 
	ON rp.ResidentID = rdi.ResidentID
LEFT JOIN -- all ResidentDietaryInfo included even if theres no matching record on MDC
    MealDietCompatibility mdc 
	ON rdi.DietaryID = mdc.DietaryID
LEFT JOIN --  all records from MealDietCompatibility are included even if there is no matching record in MM.
    MealMenu mm 
	ON mdc.MealID = mm.MealID;




	
-- =============================================
-- 5.3.1 Write a non-correlated subquery
--
-- PURPOSE:
-- query retrieves all meal delivery logs for the 'Roasted Vegetables' meal. 
-- This could be useful for a chef or kitchen staff member who wants to see 
-- which residents have been served this meal and when
-- =============================================

SELECT *
FROM MealDeliveryLogs
WHERE MealID IN (
	-- this is non-correlated subquery as it not
	-- need reference to the outer query
	SELECT MealID 
	FROM MealMenu 
	WHERE MealName = ' Roasted Vegetables');


-- =============================================
-- 5.4.1 Write a correlated subquery
-- PURPOSE:
-- Filter residents who have dietary information and check if 
-- they have received a specific meal, such as ' Roasted Vegetables'
-- =============================================

SELECT R.ResidentID, 
       R.FirstName, 
       R.LastName, 
       R.RoomNumber,
	   -- this is correlated subquery
	   -- as it references outer query
       (SELECT COUNT(*) 
        FROM MealDeliveryLogs M 
        WHERE M.ResidentID = R.ResidentID) AS TotalDeliveries
FROM ResidentProfiles R;

-- =============================================
-- 5.5.2 Aggregate the data in some way
-- count the total number of meal deliveries made by each staff member
-- =============================================

SELECT	S.StaffID, 
		S.FirstName, 
		S.LastName, 
COUNT(*) AS TotalDeliveries
FROM Staff S
JOIN MealDeliveryLogs M 
	ON S.StaffID = M.StaffID
GROUP BY	S.StaffID, 
			S.FirstName, 
			S.LastName
ORDER BY	TotalDeliveries DESC;