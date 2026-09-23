USE SkyTrack;

CREATE TABLE AIRPORT
(
    IATA_Code CHAR(10) NOT NULL PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    City NVARCHAR(50) NOT NULL,
    Country NVARCHAR(50) NOT NULL
);

CREATE TABLE AIRCRAFT
(
    Registration_Number VARCHAR(50) NOT NULL PRIMARY KEY,
    Model VARCHAR(50) NOT NULL,
    Manufacturer NVARCHAR(50) NOT NULL,
    Total_Seating_Capacity INT NOT NULL CHECK (Total_Seating_Capacity > 0),
    Year_of_Manufacture INT NOT NULL CHECK (Year_of_Manufacture >= 1900)
);

CREATE TABLE PASSENGER
(
    National_ID VARCHAR(20) NOT NULL PRIMARY KEY,
    Full_Name NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20) NOT NULL,
    Nationality NVARCHAR(50) NOT NULL,
    Date_of_Birth DATE NOT NULL
);

CREATE TABLE CREW_MEMBER
(
    License_Number VARCHAR(20)  NOT NULl UNIQUE ,
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




-- Display the final data: four records remain in each table.
SELECT * FROM AIRPORT;
SELECT * FROM AIRCRAFT;
SELECT * FROM PASSENGER;
SELECT * FROM CREW_MEMBER;
SELECT * FROM FLIGHT;
SELECT * FROM BOOKING;
SELECT * FROM FLIGHTCREW;
