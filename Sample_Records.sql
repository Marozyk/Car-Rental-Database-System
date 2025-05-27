USE CarRentalDB;
GO

-- Clear data from tables in the appropriate order
DELETE FROM Payments;
DELETE FROM RentalAgreements;
DELETE FROM RepairHistory;
DELETE FROM Rentals;
DELETE FROM Cars;
DELETE FROM CarModels;
DELETE FROM Clients;
DELETE FROM Services;
DELETE FROM Locations;
DELETE FROM Insurances;
DELETE FROM TechnicalInspections;

-- Reset IDENTITY columns for tables
DBCC CHECKIDENT ('Payments', RESEED, 0);
DBCC CHECKIDENT ('RentalAgreements', RESEED, 0);
DBCC CHECKIDENT ('RepairHistory', RESEED, 0);
DBCC CHECKIDENT ('Rentals', RESEED, 0);
DBCC CHECKIDENT ('Cars', RESEED, 0);
DBCC CHECKIDENT ('CarModels', RESEED, 0);
DBCC CHECKIDENT ('Clients', RESEED, 0);
DBCC CHECKIDENT ('Services', RESEED, 0);
DBCC CHECKIDENT ('Locations', RESEED, 0);
DBCC CHECKIDENT ('Insurances', RESEED, 0);
DBCC CHECKIDENT ('TechnicalInspections', RESEED, 0);

-- Insert data into CarModels table
EXEC sp_InsertCarModel @ModelName = N'Focus',    @Manufacturer = N'Ford',       @Type = N'Hatchback';
EXEC sp_InsertCarModel @ModelName = N'Camry',    @Manufacturer = N'Toyota',     @Type = N'Sedan';
EXEC sp_InsertCarModel @ModelName = N'3 Series', @Manufacturer = N'BMW',        @Type = N'Sedan';
EXEC sp_InsertCarModel @ModelName = N'A4',       @Manufacturer = N'Audi',       @Type = N'Sedan';
EXEC sp_InsertCarModel @ModelName = N'Golf',     @Manufacturer = N'Volkswagen', @Type = N'Hatchback';
EXEC sp_InsertCarModel @ModelName = N'Civic',    @Manufacturer = N'Honda',      @Type = N'Sedan';

-- Insert data into Clients table
EXEC sp_InsertClient @FirstName = N'Jan',   @LastName = N'Kowalski',    @Email = N'jan.kowalski@example.com',    @Phone = N'123456789';
EXEC sp_InsertClient @FirstName = N'Anna',  @LastName = N'Nowak',       @Email = N'anna.nowak@example.com',      @Phone = N'987654321';
EXEC sp_InsertClient @FirstName = N'Piotr', @LastName = N'Wiœniewski',  @Email = N'piotr.wisniewski@example.com',@Phone = N'555444333';
EXEC sp_InsertClient @FirstName = N'Maria', @LastName = N'D¹browska',   @Email = N'maria.dabrowska@example.com', @Phone = N'111222333';
EXEC sp_InsertClient @FirstName = N'Krzysztof', @LastName = N'Lewandowski', @Email = N'krzysztof.lewandowski@example.com', @Phone = N'999888777';

-- Insert data into Locations table
EXEC sp_InsertLocation @Address = N'Serwisowa St. 1', @City = N'Warsaw',   @PostalCode = N'00-001';
EXEC sp_InsertLocation @Address = N'Naprawcza St. 2', @City = N'Krakow',   @PostalCode = N'30-001';
EXEC sp_InsertLocation @Address = N'Main St. 10',     @City = N'Gdansk',   @PostalCode = N'80-001';
EXEC sp_InsertLocation @Address = N'Flower St. 5',    @City = N'Poznan',   @PostalCode = N'60-001';

-- Insert data into Services table
EXEC sp_InsertService @Name = N'Service A', @LocationID = 0, @Contact = N'555-111-222';
EXEC sp_InsertService @Name = N'Service B', @LocationID = 1, @Contact = N'555-333-444';
EXEC sp_InsertService @Name = N'Service C', @LocationID = 2, @Contact = N'555-555-555';
EXEC sp_InsertService @Name = N'Service D', @LocationID = 3, @Contact = N'555-666-666';

-- Insert data into Cars table
EXEC sp_InsertCar @ModelID = 1, @LicensePlate = N'ABC1234', @Year = 2018, @Status = N'Available';
EXEC sp_InsertCar @ModelID = 2, @LicensePlate = N'DEF5678', @Year = 2019, @Status = N'Available';
EXEC sp_InsertCar @ModelID = 3, @LicensePlate = N'GHI9012', @Year = 2020, @Status = N'Available';
EXEC sp_InsertCar @ModelID = 4, @LicensePlate = N'JKL3456', @Year = 2021, @Status = N'Available';
EXEC sp_InsertCar @ModelID = 5, @LicensePlate = N'MNO7890', @Year = 2022, @Status = N'Available';

-- Insert data into Rentals table
EXEC sp_InsertRental @ClientID = 1, @CarID = 1, @RentalDate = '2023-02-01', @ReturnDate = '2023-02-05';
EXEC sp_InsertRental @ClientID = 2, @CarID = 2, @RentalDate = '2023-03-01', @ReturnDate = '2023-03-10';
EXEC sp_InsertRental @ClientID = 3, @CarID = 3, @RentalDate = '2023-04-01', @ReturnDate = '2023-04-15';
EXEC sp_InsertRental @ClientID = 4, @CarID = 4, @RentalDate = '2023-05-01', @ReturnDate = '2023-05-10';

-- Insert data into RepairHistory table
EXEC sp_InsertRepairHistory @CarID = 1, @ServiceID = 0, @RepairDate = '2023-01-15', @Description = N'Oil change', @Cost = 150.00;
EXEC sp_InsertRepairHistory @CarID = 2, @ServiceID = 1, @RepairDate = '2023-02-20', @Description = N'Brake replacement', @Cost = 300.00;
EXEC sp_InsertRepairHistory @CarID = 3, @ServiceID = 2, @RepairDate = '2023-03-25', @Description = N'Technical inspection', @Cost = 200.00;
EXEC sp_InsertRepairHistory @CarID = 4, @ServiceID = 3, @RepairDate = '2023-04-30', @Description = N'Tire replacement', @Cost = 400.00;

-- Insert data into RentalAgreements table
EXEC sp_InsertRentalAgreement @ClientID = 1, @CarID = 1, @AgreementDate = '2023-02-01', @RentalPeriod = 5, @Terms = N'No additional fees';
EXEC sp_InsertRentalAgreement @ClientID = 2, @CarID = 2, @AgreementDate = '2023-03-01', @RentalPeriod = 10, @Terms = N'Full insurance';
EXEC sp_InsertRentalAgreement @ClientID = 3, @CarID = 3, @AgreementDate = '2023-04-01', @RentalPeriod = 15, @Terms = N'Mileage limit: 1000 km';
EXEC sp_InsertRentalAgreement @ClientID = 4, @CarID = 4, @AgreementDate = '2023-05-01', @RentalPeriod = 10, @Terms = N'No additional fees';

-- Insert data into Payments table
EXEC sp_InsertPayment @RentalAgreementID = 0, @PaymentDate = '2023-02-01', @Amount = 500.00, @PaymentMethod = N'Card';
EXEC sp_InsertPayment @RentalAgreementID = 1, @PaymentDate = '2023-03-01', @Amount = 1000.00, @PaymentMethod = N'Transfer';
EXEC sp_InsertPayment @RentalAgreementID = 2, @PaymentDate = '2023-04-01', @Amount = 1500.00, @PaymentMethod = N'Cash';
EXEC sp_InsertPayment @RentalAgreementID = 3, @PaymentDate = '2023-05-01', @Amount = 1000.00, @PaymentMethod = N'Card';

-- Insert data into Insurances table
EXEC sp_InsertInsurance @CarID = 1, @PolicyNumber = N'POL123456', @StartDate = '2023-01-01', @EndDate = '2024-01-01', @InsuranceCompany = N'Insurance Company A';
EXEC sp_InsertInsurance @CarID = 2, @PolicyNumber = N'POL654321', @StartDate = '2023-02-01', @EndDate = '2024-02-01', @InsuranceCompany = N'Insurance Company B';
EXEC sp_InsertInsurance @CarID = 3, @PolicyNumber = N'POL987654', @StartDate = '2023-03-01', @EndDate = '2024-03-01', @InsuranceCompany = N'Insurance Company C';
EXEC sp_InsertInsurance @CarID = 4, @PolicyNumber = N'POL456789', @StartDate = '2023-04-01', @EndDate = '2024-04-01', @InsuranceCompany = N'Insurance Company D';

-- Insert data into TechnicalInspections table
EXEC sp_InsertTechnicalInspection @CarID = 1, @InspectionDate = '2023-02-10', @Result = N'Positive', @Notes = N'No remarks';
EXEC sp_InsertTechnicalInspection @CarID = 2, @InspectionDate = '2023-03-15', @Result = N'Positive', @Notes = N'No remarks';
EXEC sp_InsertTechnicalInspection @CarID = 3, @InspectionDate = '2023-04-20', @Result = N'Positive', @Notes = N'No remarks';
EXEC sp_InsertTechnicalInspection @CarID = 4, @InspectionDate = '2023-05-25', @Result = N'Positive', @Notes = N'No remarks';

-- Check the rental view
SELECT * FROM dbo.v_ClientRentals;

-- Generate financial report from 2023-02-01 to 2023-03-01
EXEC sp_GenerateFinancialReport @StartDate = '2023-02-01', @EndDate = '2023-03-01';

-- Check car availability (ID = 1) from 2023-02-01 to 2023-02-05
EXEC sp_CheckCarAvailability @CarID = 1, @RentalDate = '2023-02-01', @ReturnDate = '2023-02-05';

-- Calculate age of car (Year = 2018)
SELECT dbo.fn_CalculateCarAge(2018) AS CarAge;

-- Check insurance validity (ID = 1)
SELECT dbo.fn_IsInsuranceValid(1) AS IsInsuranceValid;

-- Generate repair report for car ID = 1
EXEC sp_GenerateRepairReport @CarID = 1;

-- Update status for car ID = 1
EXEC sp_UpdateCarStatus @CarID = 1;

-- Check validity of technical inspection ID = 1
SELECT dbo.fn_IsTechnicalInspectionValid(1) AS IsValid;

-- Display data from tables
SELECT * FROM CarModels;
SELECT * FROM Cars;
SELECT * FROM Clients;
SELECT * FROM Rentals;
SELECT * FROM Services;
SELECT * FROM RepairHistory;
SELECT * FROM RentalAgreements;
SELECT * FROM Payments;
SELECT * FROM Locations;
SELECT * FROM Insurances;
SELECT * FROM TechnicalInspections;
SELECT * FROM dbo.v_RentalDetails;
SELECT * FROM dbo.v_AvailableCars;
SELECT * FROM dbo.v_ClientRentals;
SELECT * FROM dbo.v_CarRepairHistory;
