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


-- =========================================
-- Drop the View
-- =========================================
DROP VIEW IF EXISTS vw_ResidentsWithDietaryRestrictions;
GO
DROP VIEW IF EXISTS vw_MealsWithDietaryRestrictions;
GO


-- =========================================
-- 3.7 Create two views that operate and restrict data in some way
-- =========================================

-- 1st View
-- Combine ResidentProfiles and ResidentDietaryInfo 
-- to know the list of dietary restriction
CREATE OR ALTER VIEW vw_ResidentsWithDietaryRestrictions
AS
SELECT 
    rp.ResidentID, 
    rp.FirstName, 
    rp.LastName, 
    rp.RoomNumber, 
    rp.Age, 
    rp.Gender, 
    rp.ContactNumber,
    rdi.DietaryType,
    rdi.InfoDetail
FROM 
    ResidentProfiles rp
INNER JOIN 
    ResidentDietaryInfo rdi ON rp.ResidentID = rdi.ResidentID;
GO



-- 2nd View
-- combines data from the MealMenu, MealDietCompatibility, 
-- and ResidentDietaryInfo
CREATE OR ALTER VIEW vw_MealsWithDietaryRestrictions
AS
SELECT 
    mm.MealID, 
    mm.MealName, 
    mm.Description,
    rdi.DietaryType,
    rdi.InfoDetail
FROM 
    MealMenu mm
INNER JOIN 
    MealDietCompatibility mdc ON mm.MealID = mdc.MealID
INNER JOIN 
    ResidentDietaryInfo rdi ON mdc.DietaryID = rdi.DietaryID;
GO




-- =========================================
-- Insert Test Data
-- =========================================

-- Insert test data into ResidentProfiles
INSERT INTO ResidentProfiles 
    (ResidentID, FirstName, LastName, RoomNumber, Age, Gender, ContactNumber)
VALUES 
    (501, 'John', 'Doe', 501, 75, 'M', '123-456-7890'),
    (502, 'Jane', 'Doe', 502, 70, 'F', '123-456-7891');
GO

-- Insert test data into MealMenu
INSERT INTO MealMenu 
    (MealID, MealName, Description)
VALUES 
    (501, 'Chicken Sandwich', 'Contains chicken'),
    (502, 'Vegetarian Salad', 'Contains vegetables');
GO

-- Insert test data into Staff
INSERT INTO Staff 
    (StaffID, FirstName, LastName, Role)
VALUES 
    (501, 'Jane', 'Smith', 'Server'),
    (502, 'John', 'Doe', 'Nurse');
GO

-- Insert test data into ResidentDietaryInfo
INSERT INTO ResidentDietaryInfo 
    (DietaryID, ResidentID, DietaryType, InfoDetail)
VALUES 
    (501, 501, 'Allergy', 'Peanuts'),
    (502, 502, 'Preference', 'Vegetarian');
GO

-- Insert test data into MealDietCompatibility
INSERT INTO MealDietCompatibility 
    (MealID, DietaryID)
VALUES 
    (502, 502); -- Vegetarian Salad is compatible with Vegetarian preference
GO





-- =========================================
-- Verify Test Data
-- =========================================

SELECT * FROM vw_ResidentsWithDietaryRestrictions;
GO

SELECT * FROM vw_MealsWithDietaryRestrictions;
GO





-- =========================================
-- Clean Test Data
-- =========================================

-- Clean up test data
DELETE FROM MealDietCompatibility
WHERE DietaryID IN (501, 502) AND MealID IN (501, 502);
GO

DELETE FROM ResidentDietaryInfo
WHERE DietaryID IN (501, 502);
GO

DELETE FROM Staff
WHERE StaffID IN (501, 502);
GO

DELETE FROM MealMenu
WHERE MealID IN (501, 502);
GO

DELETE FROM ResidentProfiles
WHERE ResidentID IN (501, 502);
GO