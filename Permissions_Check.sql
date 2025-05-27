USE CarRentalDB;

-- As ClientUser: try to select from view and delete a client (should fail if permission denied)
EXECUTE AS LOGIN = 'ClientUser';
SELECT * FROM dbo.v_RentalDetails;

BEGIN TRY
    DELETE FROM dbo.Clients WHERE ClientID = 1;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage; 
END CATCH;
REVERT;


-- As EmployeeUser: try to execute a stored procedure and select from Clients (should fail if no select permission)
EXECUTE AS LOGIN = 'EmployeeUser';
EXEC sp_InsertClient 
    @FirstName = 'Jan',  
    @LastName = 'Kowalski', 
    @Email = 'jan.kowalski@wp.com', 
    @Phone = '123456789';

BEGIN TRY
    SELECT * FROM Clients;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
REVERT;


-- As MechanicUser: try to select repair history and delete a service (should fail if delete not granted)
EXECUTE AS LOGIN = 'MechanicUser';
SELECT * FROM dbo.v_CarRepairHistory;

BEGIN TRY
    DELETE FROM dbo.Services WHERE ServiceID = 1;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
REVERT;


-- As ManagerUser: try to select and insert car (should fail insert if only select permission granted)
EXECUTE AS LOGIN = 'ManagerUser';
SELECT * FROM dbo.Cars;

BEGIN TRY
    INSERT INTO dbo.Cars (ModelID, RegistrationNumber, ProductionYear, Status)
    VALUES (1, N'XYZ9876', 2020, N'Available');
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
REVERT;


-- As AdminUser: simple select
EXECUTE AS LOGIN = 'AdminUser';
SELECT * FROM dbo.v_RentalDetails;
REVERT;
