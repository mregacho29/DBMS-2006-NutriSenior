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
-- Create Indexes to Improve Query Performance
-- =============================================

-- Create an index on RoomNumber in ResidentProfiles
CREATE INDEX IDX_ResidentProfiles_RoomNumber
ON ResidentProfiles (RoomNumber);
GO

-- Create an index on DeliveryDateTime in MealDeliveryLogs
CREATE INDEX IDX_MealDeliveryLogs_DeliveryDateTime
ON MealDeliveryLogs (DeliveryDateTime);
GO



-- =============================================
-- Run the query to make data retrival faster
-- =============================================

-- Run a query to search for residents by their room number, 
-- such as finding which resident is in a specific room
SELECT * 
FROM ResidentProfiles 
WHERE RoomNumber = 101;

-- Run a query that filter or sort meal delivery logs by delivery date and time
SELECT * 
FROM MealDeliveryLogs 
WHERE DeliveryDateTime BETWEEN '2024-01-01' AND '2024-01-31';