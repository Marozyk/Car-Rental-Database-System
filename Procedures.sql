USE CarRentalDB
GO

-- Procedure for the CarModels table
CREATE PROCEDURE sp_InsertCarModel
    @ModelName NVARCHAR(50),
    @Manufacturer NVARCHAR(50),
    @Type NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO CarModels (ModelName, Manufacturer, Type)
        VALUES (@ModelName, @Manufacturer, @Type);
        SELECT SCOPE_IDENTITY() AS NewModelID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), 
               @ErrSeverity = ERROR_SEVERITY(), 
               @ErrState = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

-- Procedure for the Cars table
CREATE PROCEDURE sp_InsertCar
    @ModelID INT,
    @RegistrationNumber NVARCHAR(20),
    @YearOfProduction INT,
    @Status NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Cars (ModelID, RegistrationNumber, YearOfProduction, Status)
        VALUES (@ModelID, @RegistrationNumber, @YearOfProduction, @Status);
        SELECT SCOPE_IDENTITY() AS NewCarID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), 
               @ErrSeverity = ERROR_SEVERITY(), 
               @ErrState = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

-- Procedure for the Customers table
CREATE PROCEDURE sp_InsertCustomer
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Customers (FirstName, LastName, Email, Phone)
        VALUES (@FirstName, @LastName, @Email, @Phone);
        SELECT SCOPE_IDENTITY() AS NewCustomerID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), 
               @ErrSeverity = ERROR_SEVERITY(), 
               @ErrState = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

-- Procedure for the Rentals table
CREATE PROCEDURE sp_InsertRental
    @CustomerID INT,
    @CarID INT,
    @RentalDate DATETIME,
    @ReturnDate DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @ReturnDate < @RentalDate
        BEGIN
            RAISERROR(N'ReturnDate must be greater than or equal to RentalDate.', 16, 1);
            RETURN;
        END

        INSERT INTO Rentals (CustomerID, CarID, RentalDate, ReturnDate)
        VALUES (@CustomerID, @CarID, @RentalDate, @ReturnDate);
        SELECT SCOPE_IDENTITY() AS NewRentalID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), 
               @ErrSeverity = ERROR_SEVERITY(), 
               @ErrState = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

-- Procedure for the ServiceCenters table
CREATE PROCEDURE sp_InsertServiceCenter
    @Name NVARCHAR(100),
    @LocationID INT,
    @Contact NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @Name IS NULL OR LTRIM(RTRIM(@Name)) = ''
        BEGIN
            RAISERROR(N'Service center name cannot be empty.', 16, 1);
            RETURN;
        END

        IF @LocationID IS NULL OR NOT EXISTS (SELECT 1 FROM Locations WHERE LocationID = @LocationID)
        BEGIN
            RAISERROR(N'The specified location does not exist.', 16, 1);
            RETURN;
        END

        INSERT INTO ServiceCenters (Name, LocationID, Contact)
        VALUES (@Name, @LocationID, @Contact);
        SELECT SCOPE_IDENTITY() AS NewServiceCenterID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), 
               @ErrSeverity = ERROR_SEVERITY(), 
               @ErrState = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

-- Procedure for the RepairHistory table
CREATE PROCEDURE sp_InsertRepairHistory
    @CarID INT,
    @ServiceCenterID INT,
    @RepairDate DATETIME,
    @Description NVARCHAR(MAX),
    @Cost DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @Cost < 0
        BEGIN
            RAISERROR(N'Cost must be greater than or equal to 0.', 16, 1);
            RETURN;
        END

        INSERT INTO RepairHistory (CarID, ServiceCenterID, RepairDate, Description, Cost)
        VALUES (@CarID, @ServiceCenterID, @RepairDate, @Description, @Cost);
        SELECT SCOPE_IDENTITY() AS NewRepairID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), 
               @ErrSeverity = ERROR_SEVERITY(), 
               @ErrState = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

-- Procedure for the RentalAgreements table
CREATE PROCEDURE sp_InsertRentalAgreement
    @CustomerID INT,
    @CarID INT,
    @AgreementDate DATETIME,
    @RentalPeriod INT,
    @Terms NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO RentalAgreements (CustomerID, CarID, AgreementDate, RentalPeriod, Terms)
        VALUES (@CustomerID, @CarID, @AgreementDate, @RentalPeriod, @Terms);
        SELECT SCOPE_IDENTITY() AS NewAgreementID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), 
               @ErrSeverity = ERROR_SEVERITY(), 
               @ErrState = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

-- Procedure for the Payments table
CREATE PROCEDURE sp_InsertPayment
    @RentalAgreementID INT,
    @PaymentDate DATETIME,
    @Amount DECIMAL(10,2),
    @PaymentMethod NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @Amount <= 0
        BEGIN
            RAISERROR(N'Amount must be greater than 0.', 16, 1);
            RETURN;
        END

        INSERT INTO Payments (RentalAgreementID, PaymentDate, Amount, PaymentMethod)
        VALUES (@RentalAgreementID, @PaymentDate, @Amount, @PaymentMethod);
        SELECT SCOPE_IDENTITY() AS NewPaymentID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), 
               @ErrSeverity = ERROR_SEVERITY(), 
               @ErrState = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

-- Procedure for the Locations table
CREATE PROCEDURE sp_InsertLocation
    @Address NVARCHAR(200),
    @City NVARCHAR(100),
    @PostalCode NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Locations (Address, City, PostalCode)
        VALUES (@Address, @City, @PostalCode);
        SELECT SCOPE_IDENTITY() AS NewLocationID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), 
               @ErrSeverity = ERROR_SEVERITY(), 
               @ErrState = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

-- Procedure for the Insurances table
CREATE PROCEDURE sp_InsertInsurance
    @CarID INT,
    @PolicyNumber NVARCHAR(50),
    @StartDate DATETIME,
    @EndDate DATETIME,
    @InsuranceCompany NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Insurances (CarID, PolicyNumber, StartDate, EndDate, InsuranceCompany)
        VALUES (@CarID, @PolicyNumber, @StartDate, @EndDate, @InsuranceCompany);
        SELECT SCOPE_IDENTITY() AS NewInsuranceID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), 
               @ErrSeverity = ERROR_SEVERITY(), 
               @ErrState = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

-- Procedure for the TechnicalInspections table
CREATE PROCEDURE sp_InsertTechnicalInspection
    @CarID INT,
    @InspectionDate DATETIME,
    @InspectionResult NVARCHAR(20),
    @Remarks NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO TechnicalInspections (CarID, InspectionDate, InspectionResult, Remarks)
        VALUES (@CarID, @InspectionDate, @InspectionResult, @Remarks);
        SELECT SCOPE_IDENTITY() AS NewInspectionID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), 
               @ErrSeverity = ERROR_SEVERITY(), 
               @ErrState = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

-- Financial report procedure
CREATE PROCEDURE sp_GenerateFinancialReport
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT 
            SUM(P.Amount) AS TotalRevenue,
            COUNT(P.PaymentID) AS TotalTransactions
        FROM Payments P
        INNER JOIN RentalAgreements R ON P.RentalAgreementID = R.AgreementID
        WHERE P.PaymentDate BETWEEN @StartDate AND @EndDate;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), 
               @ErrSeverity = ERROR_SEVERITY(), 
               @ErrState = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

-- Check car availability
CREATE PROCEDURE sp_CheckCarAvailability
    @CarID INT,
    @RentalDate DATETIME,
    @ReturnDate DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (
            SELECT 1
            FROM Rentals
            WHERE CarID = @CarID
              AND ((RentalDate BETWEEN @RentalDate AND @ReturnDate)
              OR (ReturnDate BETWEEN @RentalDate AND @ReturnDate))
        )
        BEGIN
            SELECT 0 AS IsAvailable; -- Car is not available
        END
        ELSE
        BEGIN
            SELECT 1 AS IsAvailable; -- Car is available
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), 
               @ErrSeverity = ERROR_SEVERITY(), 
               @ErrState = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

-- Generate repair report
CREATE PROCEDURE sp_GenerateRepairReport
    @CarID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT 
            SUM(Cost) AS TotalRepairCost,
            COUNT(RepairID) AS TotalRepairs
        FROM RepairHistory
        WHERE CarID = @CarID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), 
               @ErrSeverity = ERROR_SEVERITY(), 
               @ErrState = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

-- Update car status based on availability
CREATE PROCEDURE sp_UpdateCarStatus
    @CarID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @Status NVARCHAR(20);

        IF EXISTS (
            SELECT 1
            FROM Rentals
            WHERE CarID = @CarID
              AND ReturnDate >= GETDATE()
        )
        BEGIN
            SET @Status = 'Rented';
        END
        ELSE
        BEGIN
            SET @Status = 'Available';
        END

        UPDATE Cars
        SET Status = @Status
        WHERE CarID = @CarID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), 
               @ErrSeverity = ERROR_SEVERITY(), 
               @ErrState = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO
