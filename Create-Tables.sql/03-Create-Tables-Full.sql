CREATE DATABASE skytrack_airline_db;
GO

USE skytrack_airline_db;
GO

CREATE TABLE AIRPORT (
    Airport_ID INT IDENTITY(1,1) PRIMARY KEY,
    IATA_Code  VARCHAR(10) NOT NULL UNIQUE,
    Name       VARCHAR(150) NOT NULL,
    City       VARCHAR(100) NOT NULL,
    Country    VARCHAR(100) NOT NULL
);

CREATE TABLE AIRCRAFT (
    Aircraft_ID         INT IDENTITY(1,1) PRIMARY KEY,
    Registration_Number VARCHAR(50) NOT NULL UNIQUE,
    Model               VARCHAR(100) NOT NULL,
    Manufacturer        VARCHAR(100) NOT NULL,
    Capacity            INT NOT NULL,
    Year_Of_Manufacture INT,
    CHECK (Capacity > 0)
);

CREATE TABLE PASSENGER (
    Passenger_ID  INT IDENTITY(1,1) PRIMARY KEY,
    National_ID   VARCHAR(50) NOT NULL UNIQUE,
    Full_Name     VARCHAR(150) NOT NULL,
    Email         VARCHAR(150) NOT NULL UNIQUE,
    Phone         VARCHAR(30),
    Nationality   VARCHAR(100) NOT NULL,
    Date_Of_Birth DATE NOT NULL
);

CREATE TABLE CREW_MEMBER (
    Crew_ID        INT IDENTITY(1,1) PRIMARY KEY,
    Full_Name      VARCHAR(150) NOT NULL,
    Role           VARCHAR(50) NOT NULL,
    License_Number VARCHAR(50) NOT NULL UNIQUE,
    CHECK (
        Role IN (
            'Pilot',
            'Co-Pilot',
            'Flight Attendant',
            'Engineer'
        )
    )
);

CREATE TABLE FLIGHT (
    Flight_ID              INT IDENTITY(1,1) PRIMARY KEY,
    Flight_Number          VARCHAR(30) NOT NULL UNIQUE,
    Departure_Datetime     DATETIME2 NOT NULL,
    Arrival_Datetime       DATETIME2 NOT NULL,
    Status                 VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    Aircraft_ID            INT NOT NULL,
    Origin_Airport_ID      INT NOT NULL,
    Destination_Airport_ID INT NOT NULL,

    FOREIGN KEY (Aircraft_ID)
        REFERENCES AIRCRAFT(Aircraft_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (Origin_Airport_ID)
        REFERENCES AIRPORT(Airport_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (Destination_Airport_ID)
        REFERENCES AIRPORT(Airport_ID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    CHECK (
        Status IN (
            'Scheduled',
            'Delayed',
            'Cancelled',
            'Completed'
        )
    ),

    CHECK (Arrival_Datetime > Departure_Datetime)
);

CREATE TABLE BOOKING (
    Booking_ID   INT IDENTITY(1,1) PRIMARY KEY,
    Passenger_ID INT NOT NULL,
    Flight_ID    INT NOT NULL,
    Seat_Number  VARCHAR(20) NOT NULL,
    Class        VARCHAR(20) NOT NULL,
    Price_Paid   DECIMAL(10,2) NOT NULL,
    Booking_Date DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),

    FOREIGN KEY (Passenger_ID)
        REFERENCES PASSENGER(Passenger_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (Flight_ID)
        REFERENCES FLIGHT(Flight_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CHECK (
        Class IN (
            'Economy',
            'Business',
            'First'
        )
    ),

    CHECK (Price_Paid > 0)
);

CREATE TABLE FLIGHT_CREW (
    Flight_ID INT NOT NULL,
    Crew_ID   INT NOT NULL,

    PRIMARY KEY (Flight_ID, Crew_ID),

    FOREIGN KEY (Flight_ID)
        REFERENCES FLIGHT(Flight_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (Crew_ID)
        REFERENCES CREW_MEMBER(Crew_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
