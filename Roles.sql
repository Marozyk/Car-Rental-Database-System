USE CarRentalDB;
GO

-- Create roles if they do not exist
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'ClientRole')
    CREATE ROLE ClientRole;

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'EmployeeRole')
    CREATE ROLE EmployeeRole;

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'MechanicRole')
    CREATE ROLE MechanicRole;

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'ManagerRole')
    CREATE ROLE ManagerRole;

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'AdminRole')
    CREATE ROLE AdminRole;

-- Client
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'ClientUser')
    CREATE LOGIN ClientUser WITH PASSWORD = 'ClientPass123!';

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'ClientUser')
    CREATE USER ClientUser FOR LOGIN ClientUser;

EXEC sp_addrolemember 'ClientRole', 'ClientUser';

-- Rental employee
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'EmployeeUser')
    CREATE LOGIN EmployeeUser WITH PASSWORD = 'EmployeePass123!';

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'EmployeeUser')
    CREATE USER EmployeeUser FOR LOGIN EmployeeUser;

EXEC sp_addrolemember 'EmployeeRole', 'EmployeeUser';

-- Mechanic
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'MechanicUser')
    CREATE LOGIN MechanicUser WITH PASSWORD = 'MechanicPass123!';

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'MechanicUser')
    CREATE USER MechanicUser FOR LOGIN MechanicUser;

EXEC sp_addrolemember 'MechanicRole', 'MechanicUser';

-- Branch manager
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'ManagerUser')
    CREATE LOGIN ManagerUser WITH PASSWORD = 'ManagerPass123!';
GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'ManagerUser')
    CREATE USER ManagerUser FOR LOGIN ManagerUser;

EXEC sp_addrolemember 'ManagerRole', 'ManagerUser';

-- System administrator
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'AdminUser')
    CREATE LOGIN AdminUser WITH PASSWORD = 'AdminPass123!';

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'AdminUser')
    CREATE USER AdminUser FOR LOGIN AdminUser;

EXEC sp_addrolemember 'AdminRole', 'AdminUser';

-- Permissions

-- ClientRole: Can add/update their own data in the Clients table and view summaries
GRANT SELECT, INSERT, UPDATE ON Clients TO ClientRole;
GRANT SELECT ON dbo.v_RentalDetails TO ClientRole;
GRANT SELECT ON dbo.v_AvailableCars TO ClientRole;

-- EmployeeRole: Can execute stored procedures (e.g., handling reservations/contracts), no direct table access
GRANT EXECUTE ON SCHEMA::dbo TO EmployeeRole;
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO EmployeeRole;

-- MechanicRole: Access to servicing and repair history
GRANT SELECT, INSERT, UPDATE ON dbo.Services TO MechanicRole;
GRANT SELECT, INSERT, UPDATE ON dbo.RepairHistory TO MechanicRole;
GRANT SELECT ON dbo.v_CarRepairHistory TO MechanicRole;
GRANT SELECT ON dbo.v_AvailableCars TO MechanicRole;

-- ManagerRole: Read-only access to fleet, rentals, and financial data
GRANT SELECT ON Cars TO ManagerRole;
GRANT SELECT ON CarModels TO ManagerRole;
GRANT SELECT ON Rentals TO ManagerRole;
GRANT SELECT ON Payments TO ManagerRole;
GRANT SELECT ON RentalContracts TO ManagerRole;
GRANT SELECT ON dbo.v_RentalDetails TO ManagerRole;
GRANT SELECT ON dbo.v_AvailableCars TO ManagerRole;
GRANT SELECT ON dbo.v_CarRepairHistory TO ManagerRole;

-- AdminRole: Full control over the database, added to db_owner
ALTER ROLE db_owner ADD MEMBER AdminRole;
GRANT SELECT ON dbo.v_RentalDetails TO AdminRole;
GRANT SELECT ON dbo.v_AvailableCars TO AdminRole;
GRANT SELECT ON dbo.v_CarRepairHistory TO AdminRole;

-- List permissions for all roles
SELECT 
    dp.name AS RoleName,
    dp.type_desc AS RoleType,
    p.permission_name,
    p.state_desc AS PermissionState,
    OBJECT_NAME(p.major_id) AS ObjectName
FROM sys.database_principals dp
LEFT JOIN sys.database_permissions p 
    ON dp.principal_id = p.grantee_principal_id
WHERE dp.type = 'R'
ORDER BY dp.name, p.permission_name;
