USE CarRentalDB;
GO

-- Calculates the total rental cost as the product of the number of days (difference between dates + 1) and the daily rate.
CREATE FUNCTION dbo.fn_CalcRentalCost
(
    @RentalDate DATETIME,
    @ReturnDate DATETIME,
    @DailyRate DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Days INT;
    DECLARE @TotalCost DECIMAL(10,2);
    
    SET @Days = DATEDIFF(DAY, @RentalDate, @ReturnDate) + 1;
    
    SET @TotalCost = @Days * @DailyRate;
    
    RETURN @TotalCost;
END;
GO

-- Checks car availability for a given period
CREATE FUNCTION dbo.fn_CheckCarAvailability
(
    @CarID INT,
    @RentalDate DATETIME,
    @ReturnDate DATETIME
)
RETURNS BIT
AS
BEGIN
    DECLARE @IsAvailable BIT = 1;

    IF EXISTS (
        SELECT 1
        FROM Rentals
        WHERE CarID = @CarID
          AND ((RentalDate BETWEEN @RentalDate AND @ReturnDate)
          OR (ReturnDate BETWEEN @RentalDate AND @ReturnDate))
    )
    BEGIN
        SET @IsAvailable = 0;
    END

    RETURN @IsAvailable;
END;
GO

-- Calculates the age of a car
CREATE FUNCTION dbo.fn_CalculateCarAge
(
    @ProductionYear INT
)
RETURNS INT
AS
BEGIN
    DECLARE @CurrentYear INT = YEAR(GETDATE());
    RETURN @CurrentYear - @ProductionYear;
END;
GO

-- Checks if the insurance is currently valid
CREATE FUNCTION dbo.fn_IsInsuranceValid
(
    @InsuranceID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM Insurances
        WHERE InsuranceID = @InsuranceID
          AND GETDATE() BETWEEN StartDate AND EndDate)
    BEGIN
        SET @IsValid = 1;
    END

    RETURN @IsValid;
END;
GO

-- Checks if the technical inspection is still valid
CREATE FUNCTION dbo.fn_IsTechnicalInspectionValid
(
    @InspectionID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM TechnicalInspections
        WHERE InspectionID = @InspectionID
          AND InspectionResult = 'Positive'
          AND InspectionDate >= DATEADD(YEAR, -1, GETDATE())
    )
    BEGIN
        SET @IsValid = 1;
    END

    RETURN @IsValid;
END;
GO
