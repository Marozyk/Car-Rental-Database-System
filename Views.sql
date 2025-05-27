USE CarRentalDB
GO

-- View: Rental Details
CREATE VIEW dbo.v_RentalDetails AS
SELECT 
    R.RentalID,
    C.FirstName,
    C.LastName,
    V.RegistrationNumber,
    M.ModelName,
    M.Manufacturer,
    R.RentalDate,
    R.ReturnDate,
    A.AgreementDate,
    A.RentalPeriod,
    A.Terms,
    P.Amount,
    P.PaymentMethod
FROM Rentals R
INNER JOIN Clients C ON R.ClientID = C.ClientID
INNER JOIN Cars V ON R.CarID = V.CarID
INNER JOIN CarModels M ON V.ModelID = M.ModelID
LEFT JOIN RentalAgreements A ON A.ClientID = C.ClientID AND A.CarID = V.CarID
LEFT JOIN Payments P ON P.RentalAgreementID = A.AgreementID;
GO

-- View: Available Cars
CREATE VIEW dbo.v_AvailableCars AS
SELECT 
    V.CarID,
    V.RegistrationNumber,
    M.ModelName,
    M.Manufacturer,
    V.YearOfProduction,
    V.Status
FROM Cars V
INNER JOIN CarModels M ON V.ModelID = M.ModelID
WHERE V.Status = 'Available';
GO

-- View: Client Rentals
CREATE VIEW dbo.v_ClientRentals AS
SELECT 
    C.ClientID,
    C.FirstName,
    C.LastName,
    R.RentalID,
    V.RegistrationNumber,
    M.ModelName,
    R.RentalDate,
    R.ReturnDate
FROM Rentals R
INNER JOIN Clients C ON R.ClientID = C.ClientID
INNER JOIN Cars V ON R.CarID = V.CarID
INNER JOIN CarModels M ON V.ModelID = M.ModelID;
GO

-- View: Car Repair History
CREATE VIEW dbo.v_CarRepairHistory AS
SELECT 
    V.CarID,
    V.RegistrationNumber,
    H.RepairDate,
    H.Description,
    H.Cost,
    S.Name AS ServiceCenter
FROM RepairHistory H
INNER JOIN Cars V ON H.CarID = V.CarID
INNER JOIN ServiceCenters S ON H.ServiceID = S.ServiceID;
GO

-- Add description: v_RentalDetails
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'View presenting aggregated rental data, combining information from the Clients, Cars, CarModels, RentalAgreements, and Payments tables.', 
    @level0type = N'SCHEMA', @level0name = dbo,
    @level1type = N'VIEW',   @level1name = N'v_RentalDetails';
GO

-- Add description: v_AvailableCars
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'View presenting a list of available cars for rental, combining information from the Cars and CarModels tables.', 
    @level0type = N'SCHEMA', @level0name = dbo,
    @level1type = N'VIEW',   @level1name = N'v_AvailableCars';
GO

-- Add description: v_ClientRentals
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'View presenting client rental data, combining information from the Clients, Rentals, Cars, and CarModels tables.', 
    @level0type = N'SCHEMA', @level0name = dbo,
    @level1type = N'VIEW',   @level1name = N'v_ClientRentals';
GO

-- Add description: v_CarRepairHistory
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'View presenting the repair history of vehicles, combining information from the RepairHistory, Cars, and ServiceCenters tables.', 
    @level0type = N'SCHEMA', @level0name = dbo,
    @level1type = N'VIEW',   @level1name = N'v_CarRepairHistory';
GO
