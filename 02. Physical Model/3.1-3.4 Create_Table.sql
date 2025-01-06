/***
 *** Course: DBMS-2006 (254354) Database Management Systems 2
 *** Name: Ma Crizza Lynne Regacho
 *** Final Project
 *** Date: 2024-11-20
 ***/

-- =============================================
-- 3.1 Create database
-- =============================================

CREATE DATABASE FinalProject;
GO

-- =========================================
-- Switch to FinalProject
-- =========================================

USE FinalProject;
GO


-- =========================================
-- Drop the Table if it exist
-- =========================================


DROP TABLE IF EXISTS ResidentProfiles;
DROP TABLE IF EXISTS MealMenu;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS MealDeliveryLogs;
DROP TABLE IF EXISTS ResidentDietaryInfo;
DROP TABLE IF EXISTS MealDietCompatibility;
GO


-- =============================================
-- 3.2 Create all Tables in the Database (mapped to ERD) 
-- 3.3 Create all relationship constraints
-- =============================================

/******** ResidentProfiles ********/
CREATE TABLE ResidentProfiles
(
	ResidentID		INT			NOT NULL,
	FirstName		VARCHAR(50)	NOT NULL,
	LastName		VARCHAR(50)	NOT NULL,
	RoomNumber		INT			NOT NULL,
	Age				INT			NOT NULL,
	Gender			CHAR(1)     NOT NULL,
	ContactNumber	VARCHAR(15) NOT NULL,
	CONSTRAINT	PK_ResidentProfiles
		PRIMARY KEY	(ResidentID)
);
GO


/******** MealMenu ********/
CREATE TABLE MealMenu
(
	MealID			INT			NOT NULL,
	MealName		VARCHAR(50) NOT NULL,
	Description		VARCHAR(80) NULL,
	CONSTRAINT	PK_MealMenu
		PRIMARY KEY	(MealID)
);
GO


/******** Staff ********/
CREATE TABLE Staff
(
	StaffID			INT			NOT NULL,
	FirstName		VARCHAR(50) NOT NULL,
	LastName		VARCHAR(50) NOT NULL,
	Role			VARCHAR(50) NOT NULL,
	CONSTRAINT	PK_Staff
		PRIMARY KEY (StaffID)
);


/******** MealDeliveryLogs ********/
CREATE TABLE MealDeliveryLogs
(
	DeliveryID			INT			NOT NULL,
	ResidentID			INT			NOT NULL,
	DeliveryDateTime	DATETIME	NULL,
	MealID				INT			NOT NULL,
	StaffID				INT			NOT NULL,
	CONSTRAINT	PK_MealDeliveryLogs
		PRIMARY KEY	(DeliveryID),
	CONSTRAINT	FK_MealDeliveryLogs_ResidentProfiles
		FOREIGN KEY	(ResidentID)
		REFERENCES	ResidentProfiles (ResidentID),
	CONSTRAINT	FK_MealDeliveryLogs_MealMenu
		FOREIGN KEY	(MealID)
		REFERENCES	MealMenu (MealID),
	CONSTRAINT	FK_MealDeliveryLogs_Staff
		FOREIGN KEY	(StaffID)
		REFERENCES	Staff (StaffID)
);


/******** ResidentDietaryInfo ********/
CREATE TABLE ResidentDietaryInfo
(
	
	DietaryID			INT			NOT NULL,
	ResidentID			INT			NOT NULL,
	DietaryType			VARCHAR(50)	NULL,
	InfoDetail			VARCHAR(50)	NULL,
	CONSTRAINT	PK_ResidentDietaryInfo
		PRIMARY KEY	(DietaryID),
	CONSTRAINT	FK_ResidentDietaryInfo_ResidentProfiles
		FOREIGN KEY (ResidentID) 
		REFERENCES	ResidentProfiles (ResidentID)
);


/******** MealDietCompatibility ********/
CREATE TABLE MealDietCompatibility
(
	MealID INT NOT NULL,
	DietaryID INT NOT NULL,
	CONSTRAINT PK_MealDietCompatibility
		PRIMARY KEY (MealID, DietaryID),
	CONSTRAINT FK_MealDietCompatibility_MealMenu
        FOREIGN KEY (MealID) 
		REFERENCES MealMenu (MealID),
	CONSTRAINT FK_MealDietCompatibility_ResidentDietaryInfo
        FOREIGN KEY (DietaryID) 
		REFERENCES ResidentDietaryInfo (DietaryID)
);





-- =============================================
-- 3.4 Create one other type of constraint included e.g. check constraint
-- Add CHECK constraint to enforce minimum age for seniors
-- =============================================

ALTER TABLE ResidentProfiles
ADD CONSTRAINT CHK_ResidentProfiles_Age
CHECK (Age >= 60);
GO