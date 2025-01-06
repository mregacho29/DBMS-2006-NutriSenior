/***
 *** Course: DBMS-2006 (254354) Database Management Systems 2
 *** Name: Ma Crizza Lynne Regacho
 *** Final Project
 *** Date: 2024-11-20
 ***/

-- ===================================================================
-- Switch to FinalProject
-- ===================================================================

USE FinalProject;
GO


-- ===================================================================
-- Dropped the EnsureStaffRoleForMealDelivery table and trigger if it exist.
-- ===================================================================

DROP TRIGGER IF EXISTS trg_EnsureStaffRoleForMealDelivery;
GO

-- =======================================================================
-- 3.6	Create a minimum of 1 trigger, explain  and demonstrate purpose
-- eg. trigger to enforce RI , error handling, other? (Must not be an audit trigger)
-- 
-- DESCRIPTION:
-- The purpose of the trigger trg_EnsureStaffRoleForMealDelivery is to enforce a 
-- business rule that ensures only staff members with the role of 'Server' can be 
-- assigned to meal deliveries. This trigger helps maintain the integrity of the meal 
-- delivery process by ensuring that only qualified staff members are responsible for 
-- delivering meals to residents.
-- =======================================================================

CREATE OR ALTER TRIGGER trg_EnsureStaffRoleForMealDelivery 
ON MealDeliveryLogs 
AFTER INSERT 
AS
BEGIN
	SET NOCOUNT ON;
    IF EXISTS
    (
        SELECT 1 
        FROM INSERTED i
        INNER JOIN Staff s ON i.StaffID = s.StaffID
        WHERE s.Role NOT IN ('Server') -- Check if the role is not 'Server'
    )
    BEGIN
        RAISERROR('Only staff members with the role of Server can be assigned to meal deliveries.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
GO





-- =============================================
-- Insert Test Data
-- =============================================

-- Insert test data into ResidentProfiles
INSERT INTO ResidentProfiles 
    (ResidentID, FirstName, LastName, RoomNumber, Age, Gender, ContactNumber)
VALUES 
    (501, 'John', 'Doe', 101, 75, 'M', '123-456-7890');
GO

-- Insert test data into MealMenu
INSERT INTO MealMenu 
    (MealID, MealName, Description)
VALUES 
    (501, 'Chicken Sandwich', 'Contains chicken');
GO

-- Insert test data into Staff
INSERT INTO Staff 
    (StaffID, FirstName, LastName, Role)
VALUES 
    (501, 'Jane', 'Smith', 'Server'),
    (502, 'John', 'Doe', 'Nurse');
GO


-- =============================================
-- Verify Test Data
-- =============================================

-- Insert a meal delivery log with a staff member who is a Server
INSERT INTO MealDeliveryLogs 
    (DeliveryID, ResidentID, DeliveryDateTime, MealID, StaffID)
VALUES 
    (501, 501, GETDATE(), 501, 501);
GO


-- Insert a meal delivery log with a staff member who is not a Server
INSERT INTO MealDeliveryLogs 
    (DeliveryID, ResidentID, DeliveryDateTime, MealID, StaffID)
VALUES 
    (502, 501, GETDATE(), 501, 502);
GO




-- =============================================
-- Delete Test Data
-- =============================================

-- Clean up test data from MealDeliveryLogs
DELETE FROM MealDeliveryLogs
WHERE DeliveryID IN (501, 502);
GO

-- Clean up test data from Staff
DELETE FROM Staff
WHERE StaffID IN (501, 502);
GO

-- Clean up test data from MealMenu
DELETE FROM MealMenu
WHERE MealID = 501;
GO

-- Clean up test data from ResidentProfiles
DELETE FROM ResidentProfiles
WHERE ResidentID = 501;
GO