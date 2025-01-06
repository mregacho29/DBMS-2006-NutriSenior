/***
 *** Course: DBMS-2006 (254354) Database Management Systems 2
 *** Name: Ma Crizza Lynne Regacho
 *** Final Project
 *** Date: 2024-11-20
 *** 
 *** Description:
 *** This stored method modifies a resident's phone number in the ResidentProfiles database.
 *** To make sure the update operation is atomic—that is, either all changes are applied successfully or, 
 *** in the case of an error, no changes are performed at all—it makes use of a transaction.
 *** The process will handle this situation by rolling back the transaction and returning the relevant 
 *** message if the resident with the supplied ResidentID does not exist.
 ***/


-- ======================================================================
-- Switch to FinalProject
-- ======================================================================

USE FinalProject;
GO

-- ======================================================================
-- 3.9.2 Create 1 Stored procedure including the use of a transaction, 
-- explain and demonstrate its use
-- ======================================================================

CREATE OR ALTER PROCEDURE usp_UpdateResidentContactInfo
(
    @ResidentID INT,                   
    @NewContactNumber VARCHAR(15),      
    @ResultMessage VARCHAR(100) OUTPUT 
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Declare a variable to capture the number of rows affected
        DECLARE @RowsAffected INT;

        -- Attempt to update the resident's contact number and 
		-- capture the number of rows affected
        UPDATE ResidentProfiles
        SET ContactNumber = @NewContactNumber
        WHERE ResidentID = @ResidentID;

        -- Capture the number of rows affected
        SET @RowsAffected = (
			SELECT COUNT(*) 
			FROM ResidentProfiles 
			WHERE ResidentID = @ResidentID AND ContactNumber = @NewContactNumber);

        -- Check if any rows were affected like make sure that the ResidentID exists
        IF @RowsAffected = 0
        BEGIN
            -- If no rows were affected, no resident was found with the provided ResidentID
            SET @ResultMessage = 'No resident found with the provided ResidentID.';
            ROLLBACK TRANSACTION;  -- Rollback the transaction
            RETURN;  -- Exit
        END

        -- If the update was successful, set a success message
        SET @ResultMessage = 'Resident contact information updated successfully.';

        -- Commit the transaction if there were no errors
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- If any error occurs, rollback the transaction
        ROLLBACK TRANSACTION;

        -- Set the result message with the error details
        SET @ResultMessage = 'An error occurred while updating the resident contact information.';
    END CATCH
END;
GO




-- ======================================================================
-- Create an anonymous block that will print the outgoing parameter value
-- ======================================================================
BEGIN
    DECLARE
        @TestResidentID INT,
        @NewContactNumber VARCHAR(15),
        @ResultMessage VARCHAR(100);
    
    -- Assign values to the input parameters
    SELECT @TestResidentID = 501, @NewContactNumber = '987-654-3210';

    -- Call the stored procedure
    EXEC usp_UpdateResidentContactInfo @TestResidentID, @NewContactNumber, @ResultMessage OUTPUT;

    -- Display the result message
    PRINT(CONCAT('Result: ', @ResultMessage));
END;
GO



-- ======================================================================
-- Create an anonymous block to test with a non-existent ResidentID
-- ======================================================================
BEGIN
    DECLARE
        @TestResidentID INT,
        @NewContactNumber VARCHAR(15),
        @ResultMessage VARCHAR(100);
    
    -- Assign values to the input parameters
    SELECT @TestResidentID = 999, @NewContactNumber = '555-555-5555';

    -- Call the stored procedure
    EXEC usp_UpdateResidentContactInfo @TestResidentID, @NewContactNumber, @ResultMessage OUTPUT;

    -- Display the result message
    PRINT(CONCAT('Result: ', @ResultMessage));
END;
GO


-- ======================================================================
-- Verify the update
-- ======================================================================

SELECT * FROM ResidentProfiles WHERE ResidentID = 501;
GO



-- ======================================================================
-- Insert Test Data
-- ======================================================================

-- Insert test data into ResidentProfiles
INSERT INTO ResidentProfiles (ResidentID, FirstName, LastName, RoomNumber, Age, Gender, ContactNumber)
VALUES 
    (501, 'John', 'Doe', 501, 75, 'M', '123-456-7890'),
    (502, 'Jane', 'Doe', 502, 70, 'F', '123-456-7891');
GO

-- ======================================================================
-- Delete Test Data
-- ======================================================================

-- Clean up test data
DELETE FROM ResidentDietaryInfo
WHERE ResidentID IN (501, 502);
GO

DELETE FROM ResidentProfiles
WHERE ResidentID IN (501, 502);
GO