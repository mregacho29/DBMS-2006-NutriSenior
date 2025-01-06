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
-- Drop any pre-made logins, users and roles.
-- =============================================

DROP USER IF EXISTS MRegacho;
DROP USER IF EXISTS SSmith;
DROP USER IF EXISTS JBrown;
DROP USER IF EXISTS EPoor;


IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'MaRegacho')
BEGIN
	DROP LOGIN MaRegacho;
END;


IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'SamuelSmith')
BEGIN
	DROP LOGIN SamuelSmith;
END;


IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'JadenBrown')
BEGIN
	DROP LOGIN JadenBrown;
END;


IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'EllaPoor')
BEGIN
	DROP LOGIN EllaPoor;
END;


DROP ROLE IF EXISTS server_role;
DROP ROLE IF EXISTS manager_role;
DROP ROLE IF EXISTS building_assistant_role;
DROP ROLE IF EXISTS dietitian_role;




-- =============================================
-- 6.1.3 Create and demonstrate more than 2 
-- Roles/Users interacting with database objects
-- =============================================


/******** Create logins account ********/
 CREATE LOGIN MaRegacho WITH PASSWORD = 'Seni0r!',
 DEFAULT_DATABASE = FinalProject, CHECK_POLICY = ON;
 GO


 CREATE LOGIN SamuelSmith WITH PASSWORD = 'Seni0r!',
 DEFAULT_DATABASE = FinalProject, CHECK_POLICY = ON;
 GO


 CREATE LOGIN JadenBrown WITH PASSWORD = 'Seni0r!',
 DEFAULT_DATABASE = FinalProject, CHECK_POLICY = ON;
 GO

 
 CREATE LOGIN EllaPoor WITH PASSWORD = 'Seni0r!',
 DEFAULT_DATABASE = FinalProject, CHECK_POLICY = ON;
 GO


/******** Create user account ********/
CREATE USER MRegacho 
FOR LOGIN MaRegacho 
WITH Default_Schema = [DBO]
GO


CREATE USER SSmith 
FOR LOGIN SamuelSmith 
WITH Default_Schema = [DBO]
GO


CREATE USER JBrown 
FOR LOGIN JadenBrown 
WITH Default_Schema = [DBO]
GO


CREATE USER EPoor 
FOR LOGIN EllaPoor 
WITH Default_Schema = [DBO]
GO

/******** Create roles ********/
CREATE ROLE server_role;
CREATE ROLE manager_role;
CREATE ROLE building_assistant_role;
CREATE ROLE dietitian_role;

GO



/******** Assign Permissions ********/


-- Server role
GRANT SELECT, INSERT ON dbo.MealDeliveryLogs TO server_role;
GRANT SELECT ON dbo.MealMenu TO server_role;
GRANT SELECT ON dbo.Staff TO server_role;



-- Dietitian role
GRANT SELECT ON dbo.ResidentProfiles TO dietitian_role;
GRANT SELECT ON dbo.Staff TO dietitian_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.ResidentDietaryInfo TO dietitian_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.MealDietCompatibility TO dietitian_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.MealMenu TO dietitian_role;



-- Building_assistant role
GRANT SELECT ON dbo.MealDeliveryLogs TO building_assistant_role;
GRANT SELECT, INSERT ON dbo.ResidentProfiles TO building_assistant_role;
GRANT SELECT, INSERT ON dbo.Staff TO building_assistant_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.ResidentDietaryInfo TO building_assistant_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.MealMenu TO building_assistant_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.MealDietCompatibility TO building_assistant_role;


-- Manager_role
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.ResidentProfiles TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Staff TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.ResidentDietaryInfo TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.MealDietCompatibility TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.MealMenu TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.MealDeliveryLogs TO manager_role;





/******** Assign Users to Roles ********/


-- Assign Server role 
EXEC sp_addrolemember 'server_role', 'JBrown';

-- Assign Manager role
EXEC sp_addrolemember 'manager_role', 'SSmith';

-- Assign Building_assistant role
EXEC sp_addrolemember 'building_assistant_role', 'MRegacho';

-- Assign Dietitian role
EXEC sp_addrolemember 'dietitian_role', 'EPoor';



-- =============================================
-- Test Permission
-- =============================================

/******** Impersonate Janet Brown as server_role ********/
SELECT USER;
EXECUTE AS USER = 'JBrown';
GO

-- SELECT FAILED
SELECT * FROM dbo.ResidentProfiles;
SELECT * FROM dbo.ResidentDietaryInfo;
SELECT * FROM dbo.MealDietCompatibility;


-- SELECT SUCCESS!
SELECT * FROM dbo.Staff;
SELECT * FROM dbo.MealMenu;
SELECT * FROM dbo.MealDeliveryLogs;




-- INSERT SUCCESS!!
INSERT INTO MealDeliveryLogs (DeliveryID, ResidentID, DeliveryDateTime, MealID, StaffID) 
VALUES (501, 220, '2024-09-21 20:29', 133, 1181);

-- INSERT FAILED
INSERT INTO Staff (StaffID, FirstName, LastName, Role) VALUES
(1202, 'Bea', 'Jackson', 'Chef');


-- UPDATE FAILED
INSERT INTO ResidentDietaryInfo(DietaryID, ResidentID, DietaryType, InfoDetail) VALUES
(1, 2, 'Preference', 'Vegetarian');


-- DELETE FAILED
INSERT INTO MealMenu(MealID, MealName, Description) VALUES
(200, ' Tofu Salad', ' Salad made with tofu and vegetables');

REVERT;



/******** Impersonate Samuel Smith as Manager_role ********/

SELECT USER;
EXECUTE AS USER = 'SSmith';
GO

-- SELECT SUCCESS!
SELECT * FROM dbo.ResidentProfiles;
SELECT * FROM dbo.ResidentDietaryInfo;
SELECT * FROM dbo.MealDietCompatibility;
SELECT * FROM dbo.Staff;
SELECT * FROM dbo.MealMenu;
SELECT * FROM dbo.MealDeliveryLogs;


-- INSERT SUCCESS!!

--** ResidentProfiles Table**--
INSERT INTO ResidentProfiles (ResidentID, FirstName, LastName, RoomNumber, Age, Gender, ContactNumber) VALUES
(261, 'Merri', 'Waelchi', 101, 65, 'f', '1-229-325-2871');

--** MealDeliveryLogs Table**--
INSERT INTO MealDeliveryLogs (DeliveryID, ResidentID, DeliveryDateTime, MealID, StaffID) 
VALUES (501, 261, '2024-09-21 20:29', 133, 1181);

--** ResidentDietaryInfo Table**--
INSERT INTO ResidentDietaryInfo (DietaryID, ResidentID, DietaryType, InfoDetail) VALUES
(301, 1, 'Preference', 'Vegetarian');

--** MealMenu Table**--
INSERT INTO MealMenu(MealID, MealName, Description) VALUES
(301, 'Grilled Veggie Chicken Wrap', 'A chicken wrap filled with grilled vegetables and hummus');

--** MealDietCompatibility Table**--
 INSERT INTO MealDietCompatibility (MealID, DietaryID) VALUES
 (301, 301);

--** Staff Table**--
INSERT INTO Staff (StaffID, FirstName, LastName, Role) VALUES
(1301, 'Sara', 'Doe', 'Chef');


-- UPDATE SUCCESS!!

UPDATE dbo.ResidentProfiles 
	SET FirstName = 'Cara' 
	WHERE ResidentID = 261;

UPDATE dbo.MealDeliveryLogs 
	SET DeliveryDateTime = '2024-10-21 20:29' 
	WHERE DeliveryID = 501;

UPDATE dbo.ResidentDietaryInfo
	SET DietaryType = 'Allergy' 
	WHERE DietaryID = 301;

UPDATE dbo.MealMenu
	SET MealName = 'Grilled Veggie Chicken Wrap'
	WHERE MealID = 301;

UPDATE dbo.MealDietCompatibility
	SET DietaryID = 200
	WHERE MealID = 301;

UPDATE dbo.Staff
	SET Role = 'Assistant'
	WHERE StaffID = 1301; 


-- DELETE SUCCESS
DELETE FROM dbo.MealDeliveryLogs WHERE DeliveryID = 501;
DELETE FROM dbo.ResidentProfiles WHERE ResidentID = 261;
DELETE FROM dbo.ResidentDietaryInfo WHERE DietaryID = 301;
DELETE FROM dbo.MealDietCompatibility WHERE MealID = 301;
DELETE FROM dbo.Staff WHERE StaffID = 1301;
DELETE FROM dbo.MealMenu WHERE MealID = 301;

REVERT;





/******** Impersonate Ma Regacho as building_assistant_role ********/


SELECT USER;
EXECUTE AS USER = 'MRegacho';
GO

-- SELECT SUCCESS!
SELECT * FROM dbo.ResidentProfiles;
SELECT * FROM dbo.ResidentDietaryInfo;
SELECT * FROM dbo.MealDietCompatibility;
SELECT * FROM dbo.Staff;
SELECT * FROM dbo.MealMenu;
SELECT * FROM dbo.MealDeliveryLogs;




-- INSERT SUCCESS!!

--** ResidentProfiles Table**--
INSERT INTO ResidentProfiles (ResidentID, FirstName, LastName, RoomNumber, Age, Gender, ContactNumber) VALUES
(261, 'Merri', 'Waelchi', 101, 65, 'f', '1-229-325-2871');

--** ResidentDietaryInfo Table**--
INSERT INTO ResidentDietaryInfo (DietaryID, ResidentID, DietaryType, InfoDetail) VALUES
(301, 1, 'Preference', 'Vegetarian');

--** MealMenu Table**--
INSERT INTO MealMenu(MealID, MealName, Description) VALUES
(301, 'Grilled Veggie Chicken Wrap', 'A chicken wrap filled with grilled vegetables and hummus');

--** MealDietCompatibility Table**--
 INSERT INTO MealDietCompatibility (MealID, DietaryID) VALUES
 (301, 301);

--** Staff Table**--
INSERT INTO Staff (StaffID, FirstName, LastName, Role) VALUES
(1301, 'Sara', 'Doe', 'Chef');


-- INSERT FAILED!
--** MealDeliveryLogs Table**--
INSERT INTO MealDeliveryLogs (DeliveryID, ResidentID, DeliveryDateTime, MealID, StaffID) 
VALUES (501, 261, '2024-09-21 20:29', 133, 1181);



-- UPDATE SUCCESS!!
UPDATE dbo.ResidentDietaryInfo
	SET DietaryType = 'Allergy' 
	WHERE DietaryID = 301;

UPDATE dbo.MealMenu
	SET MealName = 'Grilled Veggie Chicken Wrap'
	WHERE MealID = 301;

UPDATE dbo.MealDietCompatibility
	SET DietaryID = 200
	WHERE MealID = 301;



-- UPDATE FAILED!
UPDATE dbo.ResidentProfiles 
	SET FirstName = 'Cara' 
	WHERE ResidentID = 261;

UPDATE dbo.MealDeliveryLogs 
	SET DeliveryDateTime = '2024-10-21 20:29' 
	WHERE DeliveryID = 501;

UPDATE dbo.Staff
	SET Role = 'Assistant'
	WHERE StaffID = 1301; 


-- DELETE SUCCESS
DELETE FROM dbo.ResidentDietaryInfo WHERE DietaryID = 301;
DELETE FROM dbo.MealDietCompatibility WHERE MealID = 301;
DELETE FROM dbo.MealMenu WHERE MealID = 301;

-- DELETE FAILED!
DELETE FROM dbo.MealDeliveryLogs WHERE DeliveryID = 501;
DELETE FROM dbo.ResidentProfiles WHERE ResidentID = 261;
DELETE FROM dbo.Staff WHERE StaffID = 1301;


REVERT;




/******** Impersonate Ella Poor as dietitian _role ********/

SELECT USER;
EXECUTE AS USER = 'EPoor';
GO

-- SELECT SUCCESS!
SELECT * FROM dbo.ResidentProfiles;
SELECT * FROM dbo.ResidentDietaryInfo;
SELECT * FROM dbo.MealDietCompatibility;
SELECT * FROM dbo.Staff;
SELECT * FROM dbo.MealMenu;

-- SELECT FAILED!
SELECT * FROM dbo.MealDeliveryLogs;





-- INSERT SUCCESS!!
--** ResidentDietaryInfo Table**--
INSERT INTO ResidentDietaryInfo (DietaryID, ResidentID, DietaryType, InfoDetail) VALUES
(301, 1, 'Preference', 'Vegetarian');

--** MealMenu Table**--
INSERT INTO MealMenu(MealID, MealName, Description) VALUES
(301, 'Grilled Veggie Chicken Wrap', 'A chicken wrap filled with grilled vegetables and hummus');

--** MealDietCompatibility Table**--
 INSERT INTO MealDietCompatibility (MealID, DietaryID) VALUES
 (301, 301);



-- INSERT FAILED!
--** MealDeliveryLogs Table**--
INSERT INTO MealDeliveryLogs (DeliveryID, ResidentID, DeliveryDateTime, MealID, StaffID) 
VALUES (501, 261, '2024-09-21 20:29', 133, 1181);

--** ResidentProfiles Table**--
INSERT INTO ResidentProfiles (ResidentID, FirstName, LastName, RoomNumber, Age, Gender, ContactNumber) VALUES
(261, 'Merri', 'Waelchi', 101, 65, 'f', '1-229-325-2871');

--** Staff Table**--
INSERT INTO Staff (StaffID, FirstName, LastName, Role) VALUES
(1301, 'Sara', 'Doe', 'Chef');




-- UPDATE SUCCESS!!
UPDATE dbo.ResidentDietaryInfo
	SET DietaryType = 'Allergy' 
	WHERE DietaryID = 301;

UPDATE dbo.MealMenu
	SET MealName = 'Grilled Veggie Chicken Wrap'
	WHERE MealID = 301;

UPDATE dbo.MealDietCompatibility
	SET DietaryID = 200
	WHERE MealID = 301;



-- UPDATE FAILED!
UPDATE dbo.ResidentProfiles 
	SET FirstName = 'Cara' 
	WHERE ResidentID = 261;

UPDATE dbo.MealDeliveryLogs 
	SET DeliveryDateTime = '2024-10-21 20:29' 
	WHERE DeliveryID = 501;

UPDATE dbo.Staff
	SET Role = 'Assistant'
	WHERE StaffID = 1301; 


	
-- DELETE SUCCESS
DELETE FROM dbo.ResidentDietaryInfo WHERE DietaryID = 301;
DELETE FROM dbo.MealDietCompatibility WHERE MealID = 301;
DELETE FROM dbo.MealMenu WHERE MealID = 301;

-- DELETE FAILED!
DELETE FROM dbo.MealDeliveryLogs WHERE DeliveryID = 501;
DELETE FROM dbo.ResidentProfiles WHERE ResidentID = 261;
DELETE FROM dbo.Staff WHERE StaffID = 1301;