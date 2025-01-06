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

-- =================================================================================
-- 3.8 Create 1 function, explain and demonstrate its use
-- =================================================================================

/**
 ** Description:
 ** This function, dbo.GetTotalMealsDelivered, calculates the total number of meals delivered
 ** by a specific staff member based on their StaffID. Optionally, it can filter the results
 ** by a date range if StartDate and EndDate are provided.
 **
 ** Parameters:
 ** @StaffID INT - The ID of the staff member whose meal deliveries are being counted.
 ** @StartDate DATE - The start date of the date range (optional).
 ** @EndDate DATE - The end date of the date range (optional).
 **
 ** Returns:
 ** INT - The total number of meals delivered by the specified staff member.
 **/

CREATE OR ALTER FUNCTION dbo.GetTotalMealsDelivered
(
    @StaffID INT,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL
)
RETURNS INT
AS
BEGIN
    -- Declare a variable to store the total meals
    DECLARE @TotalMeals INT = 0;

    -- Check if a date range is provided and adjust the query logic
    IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL
    BEGIN
        -- Calculate total meals delivered by the staff within the date range
        SELECT @TotalMeals = COUNT(*)
        FROM MealDeliveryLogs
        WHERE StaffID = @StaffID
          AND DeliveryDateTime BETWEEN @StartDate AND @EndDate;
    END
    ELSE
    BEGIN
        -- Calculate total meals delivered by the staff without filtering by date
        SELECT @TotalMeals = COUNT(*)
        FROM MealDeliveryLogs
        WHERE StaffID = @StaffID;
    END;

    RETURN @TotalMeals;
END;
GO

-- =================================================================================
-- Insert Test Data
-- =================================================================================

-- Insert test data into ResidentProfiles
INSERT INTO ResidentProfiles 
    (ResidentID, FirstName, LastName, RoomNumber, Age, Gender, ContactNumber)
VALUES 
    (501, 'John', 'Doe', 501, 75, 'M', '123-456-7890');
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
    (501, 'Leo', 'Smith', 'Server'),
    (502, 'Leo', 'Happy', 'Server'),
    (503, 'Leo', 'Seth', 'Server');
GO

-- Insert test data into MealDeliveryLogs
INSERT INTO MealDeliveryLogs
    (DeliveryID, ResidentID, DeliveryDateTime, MealID, StaffID)
VALUES 
    (501, 501, GETDATE(), 501, 501), -- Valid: StaffID 1 is a Server
    (502, 501, GETDATE(), 501, 501); -- Valid: StaffID 1 is a Server
GO

-- =================================================================================
-- Test the function by running it in an anonymous block that uses a PRINT statement
-- =================================================================================

-- Test the function for StaffID = 1
DECLARE
    @StaffID INT = 501,
    @TotalMeals INT;

-- Assign the output of the function to @TotalMeals
SELECT @TotalMeals = dbo.GetTotalMealsDelivered(
	@StaffID, 
	NULL, 
	NULL
	);

-- Print the result using CONCAT
PRINT CONCAT('Total meals delivered by staff member with StaffID = ', @StaffID, ': ', @TotalMeals);
GO




-- Test the function for StaffID = 2
DECLARE
    @StaffID2 INT = 502,
    @TotalMeals2 INT;

-- Assign the output of the function to @TotalMeals
SELECT @TotalMeals2 = dbo.GetTotalMealsDelivered(
	@StaffID2, 
	NULL, 
	NULL
	);

-- Print the result using CONCAT
PRINT CONCAT('Total meals delivered by staff member with StaffID = ', @StaffID2, ': ', @TotalMeals2);
GO



-- Test the function for StaffID = 501 with a date range
DECLARE
    @StaffID3 INT = 501,
    @TotalMeals3 INT;

-- Assign the output of the function to @TotalMeals
SELECT @TotalMeals3 = dbo.GetTotalMealsDelivered(
	@StaffID3, 
	'2023-01-01', 
	'2023-12-31'
	);

-- Print the result using CONCAT
PRINT CONCAT('Total meals delivered by staff member with StaffID = ', @StaffID3, ' between 2023-01-01 and 2023-12-31: ', @TotalMeals3);
GO

-- =========================================
-- Delete Test Data
-- =========================================
DELETE FROM MealDeliveryLogs
WHERE DeliveryID IN (501, 502);
GO

DELETE FROM Staff
WHERE StaffID IN (501, 502, 503);
GO

DELETE FROM MealMenu
WHERE MealID = 501;
GO

DELETE FROM ResidentProfiles
WHERE ResidentID = 501;
GO
