USE SkyTrack;

CREATE TABLE AIRPORT
(
    IATA_Code CHAR(3) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    City NVARCHAR(50) NOT NULL,
    Country NVARCHAR(50) NOT NULL
);

CREATE TABLE AIRCRAFT
(
    Registration_Number VARCHAR(20) PRIMARY KEY,
    Model VARCHAR(50) NOT NULL,
    Manufacturer NVARCHAR(50) NOT NULL,
    Total_Seating_Capacity INT NOT NULL CHECK (Total_Seating_Capacity > 0),
    Year_of_Manufacture INT NOT NULL CHECK (Year_of_Manufacture >= 1900)
);

CREATE TABLE PASSENGER
(
    National_ID VARCHAR(20) PRIMARY KEY,
    Full_Name NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Nationality NVARCHAR(50) NOT NULL,
    Date_of_Birth DATE NOT NULL
);

CREATE TABLE CREW_MEMBER
(
    License_Number VARCHAR(20) PRIMARY KEY,
    Full_Name NVARCHAR(100) NOT NULL,
    Role NVARCHAR(50) NOT NULL
);

CREATE TABLE FLIGHT
(
    Flight_Number VARCHAR(10) PRIMARY KEY,
    Departure_Datetime DATETIME2(0) NOT NULL,
    Arrival_Datetime DATETIME2(0) NOT NULL,
    Status VARCHAR(20) NOT NULL
        CHECK (Status IN ('Scheduled', 'Delayed', 'Departed', 'Arrived', 'Cancelled')),
    Registration_Number VARCHAR(20) NOT NULL,
    Origin_IATA_Code CHAR(3) NOT NULL,
    Destination_IATA_Code CHAR(3) NOT NULL,

    FOREIGN KEY (Registration_Number)
        REFERENCES AIRCRAFT (Registration_Number),
    FOREIGN KEY (Origin_IATA_Code)
        REFERENCES AIRPORT (IATA_Code),
    FOREIGN KEY (Destination_IATA_Code)
        REFERENCES AIRPORT (IATA_Code),

    CHECK (Arrival_Datetime > Departure_Datetime),
    CHECK (Origin_IATA_Code <> Destination_IATA_Code)
);

CREATE TABLE BOOKING
(
    Flight_Number VARCHAR(10) NOT NULL,
    National_ID VARCHAR(20) NOT NULL,
    Seat_Number VARCHAR(5) NOT NULL,
    Class VARCHAR(20) NOT NULL
        CHECK (Class IN ('Economy', 'Business', 'First')),
    Price_Paid DECIMAL(10, 2) NOT NULL CHECK (Price_Paid >= 0),
    Booking_Date DATE NOT NULL,

    -- One booking per passenger on each flight.
    PRIMARY KEY (Flight_Number, National_ID),
    FOREIGN KEY (Flight_Number)
        REFERENCES FLIGHT (Flight_Number),
    FOREIGN KEY (National_ID)
        REFERENCES PASSENGER (National_ID),

    -- Prevent assigning the same seat twice on the same flight.
    UNIQUE (Flight_Number, Seat_Number)
);

CREATE TABLE FLIGHTCREW
(
    Flight_Number VARCHAR(10) NOT NULL,
    License_Number VARCHAR(20) NOT NULL,

    PRIMARY KEY (Flight_Number, License_Number),
    FOREIGN KEY (Flight_Number)
        REFERENCES FLIGHT (Flight_Number),
    FOREIGN KEY (License_Number)
        REFERENCES CREW_MEMBER (License_Number)
);

-- DML: insert five sample records into each table.
INSERT INTO AIRPORT (IATA_Code, Name, City, Country)
VALUES
('MCT', 'Muscat Airport', 'Muscat', 'Oman'),
('DXB', 'Dubai Airport', 'Dubai', 'United Arab Emirates'),
('DOH', 'Doha Airport', 'Doha', 'Qatar'),
('RUH', 'Riyadh Airport', 'Riyadh', 'Saudi Arabia'),
('KWI', 'Kuwait Airport', 'Kuwait City', 'Kuwait');

INSERT INTO AIRCRAFT
(Registration_Number, Model, Manufacturer, Total_Seating_Capacity, Year_of_Manufacture)
VALUES
('ST-A001', 'A320', 'Airbus', 180, 2018),
('ST-A002', '737-800', 'Boeing', 189, 2019),
('ST-A003', 'A321', 'Airbus', 220, 2020),
('ST-A004', '787-9', 'Boeing', 290, 2021),
('ST-A005', 'A330', 'Airbus', 280, 2017);

INSERT INTO PASSENGER
(National_ID, Full_Name, Email, Phone, Nationality, Date_of_Birth)
VALUES
('10000001', 'Ahmed Ali', 'ahmed@example.com', '90000001', 'Omani', '1998-05-12'),
('10000002', 'Sara Salim', 'sara@example.com', '90000002', 'Omani', '2000-03-20'),
('10000003', 'Khalid Hassan', 'khalid@example.com', '90000003', 'Omani', '1995-07-15'),
('10000004', 'Mariam Said', 'mariam@example.com', '90000004', 'Omani', '1999-11-08'),
('10000005', 'Yousuf Nasser', 'yousuf@example.com', '90000005', 'Omani', '1997-09-25');

INSERT INTO CREW_MEMBER (License_Number, Full_Name, Role)
VALUES
('LIC001', 'Salim Ahmed', 'Pilot'),
('LIC002', 'Fahad Ali', 'Co-Pilot'),
('LIC003', 'Noor Said', 'Flight Attendant'),
('LIC004', 'Hamed Khalid', 'Pilot'),
('LIC005', 'Aisha Hassan', 'Flight Attendant');

-- All flight times in this example use the same time basis (UTC).
INSERT INTO FLIGHT
(Flight_Number, Departure_Datetime, Arrival_Datetime, Status,
 Registration_Number, Origin_IATA_Code, Destination_IATA_Code)
VALUES
('ST101', '2026-10-01T08:00:00', '2026-10-01T09:15:00', 'Scheduled', 'ST-A001', 'MCT', 'DXB'),
('ST102', '2026-10-02T10:00:00', '2026-10-02T11:30:00', 'Scheduled', 'ST-A002', 'MCT', 'DOH'),
('ST103', '2026-10-03T12:00:00', '2026-10-03T14:00:00', 'Scheduled', 'ST-A003', 'MCT', 'RUH'),
('ST104', '2026-10-04T14:00:00', '2026-10-04T15:15:00', 'Scheduled', 'ST-A004', 'DXB', 'MCT'),
('ST105', '2026-10-05T16:00:00', '2026-10-05T18:00:00', 'Scheduled', 'ST-A005', 'MCT', 'KWI');

INSERT INTO BOOKING
(Flight_Number, National_ID, Seat_Number, Class, Price_Paid, Booking_Date)
VALUES
('ST101', '10000001', '12A', 'Economy', 65.00, '2026-09-20'),
('ST102', '10000002', '2B', 'Business', 180.00, '2026-09-21'),
('ST103', '10000003', '15C', 'Economy', 90.00, '2026-09-22'),
('ST104', '10000004', '1A', 'First', 250.00, '2026-09-23'),
('ST105', '10000005', '18D', 'Economy', 85.00, '2026-09-24');

INSERT INTO FLIGHTCREW (Flight_Number, License_Number)
VALUES
('ST101', 'LIC001'),
('ST102', 'LIC002'),
('ST103', 'LIC003'),
('ST104', 'LIC004'),
('ST105', 'LIC005');

-- Display all tables before updates and deletions.
SELECT * FROM AIRPORT;
SELECT * FROM AIRCRAFT;
SELECT * FROM PASSENGER;
SELECT * FROM CREW_MEMBER;
SELECT * FROM FLIGHT;
SELECT * FROM BOOKING;
SELECT * FROM FLIGHTCREW;

-- Update one record in each table.
UPDATE AIRPORT
SET Name = 'Muscat International Airport'
WHERE IATA_Code = 'MCT';

UPDATE AIRCRAFT
SET Total_Seating_Capacity = 186
WHERE Registration_Number = 'ST-A001';

UPDATE PASSENGER
SET Phone = '90000011'
WHERE National_ID = '10000001';

UPDATE CREW_MEMBER
SET Role = 'Senior Pilot'
WHERE License_Number = 'LIC001';

UPDATE FLIGHT
SET Status = 'Delayed'
WHERE Flight_Number = 'ST101';

UPDATE BOOKING
SET Price_Paid = 75.00
WHERE Flight_Number = 'ST101'
AND National_ID = '10000001';

UPDATE FLIGHTCREW
SET License_Number = 'LIC001'
WHERE Flight_Number = 'ST102'
AND License_Number = 'LIC002';

-- Delete related child records before their parent records.
DELETE FROM BOOKING
WHERE Flight_Number = 'ST105'
AND National_ID = '10000005';

DELETE FROM FLIGHTCREW
WHERE Flight_Number = 'ST105'
AND License_Number = 'LIC005';

DELETE FROM FLIGHT
WHERE Flight_Number = 'ST105';

DELETE FROM PASSENGER
WHERE National_ID = '10000005';

DELETE FROM CREW_MEMBER
WHERE License_Number = 'LIC005';

DELETE FROM AIRCRAFT
WHERE Registration_Number = 'ST-A005';

DELETE FROM AIRPORT
WHERE IATA_Code = 'KWI';

-- Display the final data: four records remain in each table.
SELECT * FROM AIRPORT;
SELECT * FROM AIRCRAFT;
SELECT * FROM PASSENGER;
SELECT * FROM CREW_MEMBER;
SELECT * FROM FLIGHT;
SELECT * FROM BOOKING;
SELECT * FROM FLIGHTCREW;
