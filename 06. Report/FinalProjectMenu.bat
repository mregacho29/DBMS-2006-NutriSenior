@ECHO OFF
REM ***************************************************************
REM Author:       Mike Bialowas
REM Date Written: May 31 2022
REM Purpose:      Generate a menu system so users can select what report to run
REM Date Revised: June 14 2023
REM Last Revised by: Mike Poitras
REM Credits: Mike Poitras
REM Revisions:
REM    1. Added MKDIR for output directory
REM    2. Changed output directory to C:\DBMSDBII\A3\Reports
REM    3. Removed 'End Of Report' in footer (since it is end of page)
REM    4. Changed to request that user enters his/her server name and password
REM **************************************************************
REM **************************************************************
REM Display the menu. Validate the item selected and take appropriate action.
REM **************************************************************
:DisplayMenu
CLS
ECHO.
ECHO FinalProject
ECHO.
ECHO 1. Generate Report
ECHO 2. Exit
ECHO.
SET choice=
SET /P choice=Enter your choice: 
IF '%choice%'=='' GOTO NothingSelected
IF '%choice%'=='1' GOTO GenerateReport
IF '%choice%'=='2' GOTO ExitSelected
REM ***************************************************************
REM An invalid menu number was selected. Display an error then redisplay the menu.
REM ***************************************************************
ECHO.
ECHO Error - Invalid choice entered. Please choose a valid option.
ECHO.
PAUSE
GOTO DisplayMenu
REM ****************************************************************
REM The user just pressed enter. Display an error then redisplay the menu.
REM ****************************************************************
:NothingSelected
   ECHO.
   ECHO Error - No choice entered. Please choose an option displayed.
   ECHO.
   PAUSE
   GOTO DisplayMenu
REM *************************************************************
REM The user selected option 1. Generate the report, then redisplay the menu.
REM *************************************************************
:GenerateReport
    CLS
    IF NOT EXIST C:\DBMSDBII\A3\Reports MKDIR C:\DBMSDBII\A3\Reports
       REM SQLPLUS /nolog @Assignmentmp 

       SET /P StaffID=Enter a valid StaffID:	
       ECHO Creating Report

       REM replace the -P switch with your password. replace -S switch with your server name
       sqlcmd -S CRIZZALYNNE\VENUS -i StaffMealDeliveryReport.sql -o StaffMealDeliveryReport.txt -E -v StaffID=%StaffID%

	PAUSE
    GOTO DisplayMenu
REM **************************************************************
REM The user selected termination. End the batch script.
REM **************************************************************
:ExitSelected