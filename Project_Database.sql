IF DB_ID('CarRentalDB') IS NULL
BEGIN
    CREATE DATABASE CarRentalDB
	COLLATE Polish_CS_AS
END

ALTER DATABASE CarRentalDB SET RECOVERY FULL

USE CarRentalDB

-- Car Models
CREATE TABLE CarModels (
    ModelID INT IDENTITY(1,1) PRIMARY KEY,
    ModelName NVARCHAR(50) NOT NULL,
    Manufacturer NVARCHAR(50) NOT NULL,
    Type NVARCHAR(50) NOT NULL,
    ModifiedDate DATETIME NOT NULL CONSTRAINT DF_CarModels_ModifiedDate DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_CarModels_rowguid DEFAULT NEWID(),
    CONSTRAINT UQ_CarModels_Model_Manufacturer UNIQUE (ModelName, Manufacturer)
);

-- Cars
CREATE TABLE Cars (
    CarID INT IDENTITY(1,1) PRIMARY KEY,
    ModelID INT NOT NULL,
    LicensePlate NVARCHAR(20) NOT NULL,
    ProductionYear INT,
    Status NVARCHAR(20) NOT NULL,
    ModifiedDate DATETIME NOT NULL CONSTRAINT DF_Cars_ModifiedDate DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Cars_rowguid DEFAULT NEWID(),
    CONSTRAINT UQ_Cars_LicensePlate UNIQUE (LicensePlate),
    CONSTRAINT CHK_Cars_Status CHECK (Status IN ('Available','Rented','In Service')),
    CONSTRAINT FK_Cars_ModelID FOREIGN KEY (ModelID) REFERENCES CarModels(ModelID)
);

-- Customers
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    ModifiedDate DATETIME NOT NULL CONSTRAINT DF_Customers_ModifiedDate DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Customers_rowguid DEFAULT NEWID(),
    CONSTRAINT UQ_Customers_Email UNIQUE (Email)
);

-- Rentals
CREATE TABLE Rentals (
    RentalID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    CarID INT NOT NULL,
    RentalDate DATETIME NOT NULL,
    ReturnDate DATETIME NOT NULL,
    ModifiedDate DATETIME NOT NULL CONSTRAINT DF_Rentals_ModifiedDate DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Rentals_rowguid DEFAULT NEWID(),
    CONSTRAINT FK_Rentals_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Rentals_CarID FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    CONSTRAINT CHK_Rentals_Date CHECK (ReturnDate >= RentalDate)
);

-- Locations
CREATE TABLE Locations (
    LocationID INT IDENTITY(1,1) PRIMARY KEY,
    Address NVARCHAR(200) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    PostalCode NVARCHAR(10) NOT NULL,
    ModifiedDate DATETIME NOT NULL CONSTRAINT DF_Locations_ModifiedDate DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Locations_rowguid DEFAULT NEWID(),
    CONSTRAINT UQ_Locations_AddressCityCode UNIQUE (Address, City, PostalCode),
    CONSTRAINT CHK_Locations_PostalCode CHECK (PostalCode LIKE '[0-9][0-9]-[0-9][0-9][0-9]')
);

-- Services
CREATE TABLE Services (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Contact NVARCHAR(50),
    LocationID INT NOT NULL,
    ModifiedDate DATETIME NOT NULL CONSTRAINT DF_Services_ModifiedDate DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Services_rowguid DEFAULT NEWID(),
    CONSTRAINT FK_Services_LocationID FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);

-- Repair History
CREATE TABLE RepairHistory (
    RepairID INT IDENTITY(1,1) PRIMARY KEY,
    CarID INT NOT NULL,
    ServiceID INT NOT NULL,
    RepairDate DATETIME NOT NULL,
    Description NVARCHAR(MAX),
    Cost DECIMAL(10,2) NOT NULL,
    ModifiedDate DATETIME NOT NULL CONSTRAINT DF_RepairHistory_ModifiedDate DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_RepairHistory_rowguid DEFAULT NEWID(),
    CONSTRAINT FK_RepairHistory_CarID FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    CONSTRAINT FK_RepairHistory_ServiceID FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
    CONSTRAINT CHK_RepairHistory_Cost CHECK (Cost >= 0)
);

-- Rental Agreements
CREATE TABLE RentalAgreements (
    AgreementID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    CarID INT NOT NULL,
    AgreementDate DATETIME NOT NULL,
    RentalPeriod INT NOT NULL,  -- number of days
    Terms NVARCHAR(MAX),
    ModifiedDate DATETIME NOT NULL CONSTRAINT DF_RentalAgreements_ModifiedDate DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_RentalAgreements_rowguid DEFAULT NEWID(),
    CONSTRAINT FK_RentalAgreements_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_RentalAgreements_CarID FOREIGN KEY (CarID) REFERENCES Cars(CarID)
);

-- Payments
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    RentalAgreementID INT NOT NULL,
    PaymentDate DATETIME NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod NVARCHAR(50),
    ModifiedDate DATETIME NOT NULL CONSTRAINT DF_Payments_ModifiedDate DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Payments_rowguid DEFAULT NEWID(),
    CONSTRAINT FK_Payments_RentalAgreementID FOREIGN KEY (RentalAgreementID) REFERENCES RentalAgreements(AgreementID),
    CONSTRAINT CHK_Payments_Amount CHECK (Amount > 0)
);

-- Insurance
CREATE TABLE Insurances (
    InsuranceID INT IDENTITY(1,1) PRIMARY KEY,
    CarID INT NOT NULL,
    PolicyNumber NVARCHAR(50) NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    InsuranceCompany NVARCHAR(100),
    ModifiedDate DATETIME NOT NULL CONSTRAINT DF_Insurances_ModifiedDate DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Insurances_rowguid DEFAULT NEWID(),
    CONSTRAINT FK_Insurances_CarID FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    CONSTRAINT UQ_Insurances_PolicyNumber UNIQUE (PolicyNumber)
);

-- Technical Inspections
CREATE TABLE TechnicalInspections (
    InspectionID INT IDENTITY(1,1) PRIMARY KEY,
    CarID INT NOT NULL,
    InspectionDate DATETIME NOT NULL,
    InspectionResult NVARCHAR(20) NOT NULL,
    Notes NVARCHAR(MAX),
    ModifiedDate DATETIME NOT NULL CONSTRAINT DF_TechnicalInspections_ModifiedDate DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_TechnicalInspections_rowguid DEFAULT NEWID(),
    CONSTRAINT FK_TechnicalInspections_CarID FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    CONSTRAINT CHK_TechnicalInspections_Result CHECK (InspectionResult IN ('Positive','Negative'))
);

-- Extended properties (table descriptions)
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Insurance policy info for each car.', @level0type = N'SCHEMA', @level0name = dbo, @level1type = N'TABLE', @level1name = N'Insurances';

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Operational locations for service centers.', @level0type = N'SCHEMA', @level0name = dbo, @level1type = N'TABLE', @level1name = N'Locations';

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Customer rental payments data.', @level0type = N'SCHEMA', @level0name = dbo, @level1type = N'TABLE', @level1name = N'Payments';

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Rental agreement details, conditions, and durations.', @level0type = N'SCHEMA', @level0name = dbo, @level1type = N'TABLE', @level1name = N'RentalAgreements';

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Repair records and the service provider info.', @level0type = N'SCHEMA', @level0name = dbo, @level1type = N'TABLE', @level1name = N'RepairHistory';

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Service centers responsible for repairs and inspections.', @level0type = N'SCHEMA', @level0name = dbo, @level1type = N'TABLE', @level1name = N'Services';

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Vehicle rental logs and rental durations.', @level0type = N'SCHEMA', @level0name = dbo, @level1type = N'TABLE', @level1name = N'Rentals';

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Customer personal and contact information.', @level0type = N'SCHEMA', @level0name = dbo, @level1type = N'TABLE', @level1name = N'Customers';

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Rentable cars with assigned model references.', @level0type = N'SCHEMA', @level0name = dbo, @level1type = N'TABLE', @level1name = N'Cars';

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Information on car models used to assign to vehicles.', @level0type = N'SCHEMA', @level0name = dbo, @level1type = N'TABLE', @level1name = N'CarModels';

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Record of technical inspection results for vehicles.', @level0type = N'SCHEMA', @level0name = dbo, @level1type = N'TABLE', @level1name = N'TechnicalInspections';

-- Backup and restore procedure
USE master;

BACKUP DATABASE CarRentalDB
TO DISK = N'D:\Microsoft SQL Server\MSSQL15.MSQLSERVER\MSSQL\Backup\CarRentalDB_Full.bak'
WITH FORMAT, INIT, NAME = N'CarRentalDB Full Backup';

ALTER DATABASE CarRentalDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

RESTORE FILELISTONLY FROM DISK = N'D:\Microsoft SQL Server\MSSQL15.MSQLSERVER\MSSQL\Backup\CarRentalDB_Full.bak';

RESTORE DATABASE CarRentalDB
FROM DISK = N'D:\Microsoft SQL Server\MSSQL15.MSQLSERVER\MSSQL\Backup\CarRentalDB_Full.bak'
WITH MOVE 'CarRentalDB' TO N'D:\Microsoft SQL Server\MSSQL15.MSQLSERVER\MSSQL\Data\CarRentalDB.mdf',
     MOVE 'CarRentalDB_log'  TO N'D:\Microsoft SQL Server\MSSQL15.MSQLSERVER\MSSQL\Data\CarRentalDB_log.ldf',
     REPLACE;

ALTER DATABASE CarRentalDB SET MULTI_USER;
