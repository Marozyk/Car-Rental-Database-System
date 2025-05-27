USE CarRentalDB
GO

-- For the Cars table
CREATE TRIGGER trg_Cars_UpdateModifiedDate
ON Cars
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE C
    SET ModifiedDate = GETDATE()
    FROM Cars C
    INNER JOIN inserted i ON C.CarID = i.CarID;
END;
GO

-- For the Clients table
CREATE TRIGGER trg_Clients_UpdateModifiedDate
ON Clients
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE C
    SET ModifiedDate = GETDATE()
    FROM Clients C
    INNER JOIN inserted i ON C.ClientID = i.ClientID;
END;
GO

-- For the CarModels table
CREATE TRIGGER trg_CarModels_UpdateModifiedDate
ON CarModels
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE M
    SET ModifiedDate = GETDATE()
    FROM CarModels M
    INNER JOIN inserted i ON M.ModelID = i.ModelID;
END;
GO

-- For the Rentals table
CREATE TRIGGER trg_Rentals_UpdateModifiedDate
ON Rentals
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE R
    SET ModifiedDate = GETDATE()
    FROM Rentals R
    INNER JOIN inserted i ON R.RentalID = i.RentalID;
END;
GO

-- For the ServiceCenters table
CREATE TRIGGER trg_ServiceCenters_UpdateModifiedDate
ON ServiceCenters
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE S
    SET ModifiedDate = GETDATE()
    FROM ServiceCenters S
    INNER JOIN inserted i ON S.ServiceID = i.ServiceID;
END;
GO

-- For the RepairHistory table
CREATE TRIGGER trg_RepairHistory_UpdateModifiedDate
ON RepairHistory
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE R
    SET ModifiedDate = GETDATE()
    FROM RepairHistory R
    INNER JOIN inserted i ON R.RepairID = i.RepairID;
END;
GO

-- For the RentalAgreements table
CREATE TRIGGER trg_RentalAgreements_UpdateModifiedDate
ON RentalAgreements
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE A
    SET ModifiedDate = GETDATE()
    FROM RentalAgreements A
    INNER JOIN inserted i ON A.AgreementID = i.AgreementID;
END;
GO

-- For the Payments table
CREATE TRIGGER trg_Payments_UpdateModifiedDate
ON Payments
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE P
    SET ModifiedDate = GETDATE()
    FROM Payments P
    INNER JOIN inserted i ON P.PaymentID = i.PaymentID;
END;
GO

-- For the Locations table
CREATE TRIGGER trg_Locations_UpdateModifiedDate
ON Locations
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE L
    SET ModifiedDate = GETDATE()
    FROM Locations L
    INNER JOIN inserted i ON L.LocationID = i.LocationID;
END;
GO

-- For the Insurance table
CREATE TRIGGER trg_Insurance_UpdateModifiedDate
ON Insurance
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE I
    SET ModifiedDate = GETDATE()
    FROM Insurance I
    INNER JOIN inserted i ON I.InsuranceID = i.InsuranceID;
END;
GO

-- For the TechnicalInspections table
CREATE TRIGGER trg_TechnicalInspections_UpdateModifiedDate
ON TechnicalInspections
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE T
    SET ModifiedDate = GETDATE()
    FROM TechnicalInspections T
    INNER JOIN inserted i ON T.InspectionID = i.InspectionID;
END;
