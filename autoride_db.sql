CREATE DATABASE autoride_db;
GO

USE autoride_db;
GO




CREATE TABLE Cars (
    car_id INT IDENTITY(1,1) PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
);
GO




CREATE TABLE Rentals (
    rental_id INT IDENTITY(1,1) PRIMARY KEY,
    car_id INT,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME,

    status VARCHAR(50) DEFAULT 'BOOKED',

    FOREIGN KEY (car_id) REFERENCES Cars(car_id)
);
GO




SELECT * FROM Cars;
SELECT * FROM Rentals;




SELECT
    dc.name AS ConstraintName
FROM sys.default_constraints dc
JOIN sys.columns c
    ON dc.parent_object_id = c.object_id
    AND dc.parent_column_id = c.column_id
WHERE OBJECT_NAME(dc.parent_object_id) = 'Rentals'
AND c.name = 'status';






USE autoride_db;
GO

SELECT
    dc.name AS ConstraintName
FROM sys.default_constraints dc
JOIN sys.columns c
    ON dc.parent_object_id = c.object_id
    AND dc.parent_column_id = c.column_id
WHERE OBJECT_NAME(dc.parent_object_id) = 'Rentals'
AND c.name = 'status';




ALTER TABLE Rentals
DROP CONSTRAINT DF__Rentals__status__3A81B327;
GO




ALTER TABLE Rentals
DROP COLUMN status;
GO
ALTER TABLE Rentals
DROP CONSTRAINT CK_Rentals_Status;
GO
ALTER TABLE Rentals
DROP COLUMN status;
GO
ALTER TABLE Rentals
ADD status VARCHAR(20) NOT NULL
    CONSTRAINT DF_Rentals_Status DEFAULT 'BOOKED';
ALTER TABLE Rentals
ADD CONSTRAINT CK_Rentals_Status
CHECK (status IN ('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED'));
GO
SELECT *
FROM Rentals;
ALTER TABLE Rentals
ADD security_deposit DECIMAL(10,2) NOT NULL DEFAULT 0,
    late_fee DECIMAL(10,2) NOT NULL DEFAULT 0,
    damage_fee DECIMAL(10,2) NOT NULL DEFAULT 0;
GO
CREATE TABLE Inspections (
    inspection_id INT IDENTITY(1,1) PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT GETDATE(),
    damage_description VARCHAR(MAX),
    inspector_name VARCHAR(100) NOT NULL,

    CONSTRAINT FK_Inspections_Rentals
        FOREIGN KEY (rental_id)
        REFERENCES Rentals(rental_id)
        ON DELETE NO ACTION
);
GO
INSERT INTO Cars (model_name, license_plate)
VALUES ('Toyota Camry', '30A-12345');
GO
SELECT * FROM Cars;
INSERT INTO Rentals
(
    car_id,
    customer_name,
    rent_date,
    return_date,
    status,
    security_deposit,
    late_fee,
    damage_fee
)
VALUES
(
    1,
    'Nguyen Van A',
    '2026-09-25 08:00:00',
    '2026-09-27 08:00:00',
    'ACTIVE',
    10000000,
    0,
    0
);
GO
SELECT * FROM Rentals;
INSERT INTO Inspections
(
    rental_id,
    inspection_date,
    damage_description,
    inspector_name
)
VALUES
(
    1,
    GETDATE(),
    N'Vỡ đèn pha trái',
    N'Nguyen Van B'
);
GO
SELECT * FROM Inspections;
UPDATE Rentals
SET status = 'COMPLETED',
    late_fee = 0,
    damage_fee = 2000000
WHERE rental_id = 1;
GO
SELECT
    rental_id,
    customer_name,
    security_deposit,
    late_fee,
    damage_fee,
    security_deposit - late_fee - damage_fee AS refund_amount
FROM Rentals
WHERE rental_id = 1;
SELECT * FROM Cars;
SELECT * FROM Rentals;
SELECT * FROM Inspections;