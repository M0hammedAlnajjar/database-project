USE skytrack_airline_db;

INSERT INTO AIRPORT (IATA_Code, Name, City, Country)
VALUES
('LHR', 'Heathrow Airport', 'London', 'United Kingdom'),
('CDG', 'Charles de Gaulle Airport', 'Paris', 'France'),
('FRA', 'Frankfurt Airport', 'Frankfurt', 'Germany'),
('FCO', 'Leonardo da Vinci Fiumicino Airport', 'Rome', 'Italy'),
('MAD', 'Adolfo Suarez Madrid-Barajas Airport', 'Madrid', 'Spain');

INSERT INTO AIRCRAFT
(Registration_Number, Model, Manufacturer, Capacity, Year_Of_Manufacture)
VALUES
('G-SK01', '737-800', 'Boeing', 162, 2018),
('F-SK02', 'A320neo', 'Airbus', 180, 2020),
('D-SK03', 'E190-E2', 'Embraer', 114, 2021),
('I-SK04', 'ATR 72-600', 'ATR', 72, 2019),
('EC-SK05', 'CRJ900', 'Bombardier', 90, 2017),
('PH-SK06', 'A220-300', 'Airbus', 145, 2022),
('SE-SK07', '737 MAX 8', 'Boeing', 178, 2023),
('CS-SK08', 'E195-E2', 'Embraer', 132, 2021);

INSERT INTO PASSENGER
(National_ID, Full_Name, Email, Phone, Nationality, Date_Of_Birth)
VALUES
('OM10001', 'Ahmed Al Balushi', 'ahmed.balushi@example.com', '+96892110001', 'Omani', '1995-04-12'),
('UK10002', 'Oliver Smith', 'oliver.smith@example.com', '+447700900002', 'British', '1992-07-21'),
('FR10003', 'Camille Martin', 'camille.martin@example.com', '+33612000003', 'French', '1998-11-08'),
('DE10004', 'Lukas Schneider', 'lukas.schneider@example.com', '+491512000004', 'German', '1990-02-18'),
('IT10005', 'Giulia Rossi', 'giulia.rossi@example.com', '+393401000005', 'Italian', '1996-06-30'),
('ES10006', 'Carlos Garcia', 'carlos.garcia@example.com', '+34600100006', 'Spanish', '1994-09-14'),
('NL10007', 'Emma De Vries', 'emma.devries@example.com', '+31610000007', 'Dutch', '1989-12-03'),
('SE10008', 'Erik Johansson', 'erik.johansson@example.com', '+46701000008', 'Swedish', '1997-03-25');

INSERT INTO CREW_MEMBER
(Full_Name, Role, License_Number)
VALUES
('James Wilson', 'Pilot', 'LIC-P1001'),
('Pierre Dubois', 'Pilot', 'LIC-P1002'),
('Daniel Muller', 'Co-Pilot', 'LIC-C1003'),
('Sofia Romano', 'Flight Attendant', 'LIC-F1004'),
('Elena Garcia', 'Flight Attendant', 'LIC-F1005'),
('Thomas Becker', 'Engineer', 'LIC-E1006');

INSERT INTO FLIGHT
(Flight_Number, Departure_Datetime, Arrival_Datetime, Status, Registration_Number, Origin_IATA_Code, Destination_IATA_Code)
VALUES
('SK101', '2026-10-01 08:00:00', '2026-10-01 10:15:00', 'Scheduled', 'G-SK01', 'LHR', 'CDG'),
('SK102', '2026-10-02 10:00:00', '2026-10-02 11:20:00', 'Delayed', 'F-SK02', 'CDG', 'FRA'),
('SK103', '2026-10-03 12:00:00', '2026-10-03 14:00:00', 'Cancelled', 'D-SK03', 'FRA', 'FCO'),
('SK104', '2026-10-04 07:30:00', '2026-10-04 10:00:00', 'Completed', 'I-SK04', 'FCO', 'MAD'),
('SK105', '2026-10-05 15:00:00', '2026-10-05 17:30:00', 'Scheduled', 'EC-SK05', 'MAD', 'LHR'),
('SK106', '2026-10-06 18:00:00', '2026-10-06 20:15:00', 'Delayed', 'PH-SK06', 'LHR', 'FRA'),
('SK107', '2026-10-07 09:00:00', '2026-10-07 11:10:00', 'Completed', 'SE-SK07', 'CDG', 'FCO'),
('SK108', '2026-10-08 13:30:00', '2026-10-08 15:50:00', 'Scheduled', 'CS-SK08', 'FRA', 'MAD');

INSERT INTO BOOKING
(National_ID, Flight_ID, Seat_Number, Class, Price_Paid, Booking_Date)
VALUES
('OM10001', 1, '12A', 'Economy', 120.00, '2026-09-20'),
('UK10002', 1, '3B', 'Business', 280.00, '2026-09-20'),
('FR10003', 1, '1A', 'First', 450.00, '2026-09-20'),
('DE10004', 2, '14C', 'Economy', 135.00, '2026-09-21'),
('IT10005', 2, '5A', 'Business', 310.00, '2026-09-21'),
('ES10006', 3, '16D', 'Economy', 150.00, '2026-09-21'),
('NL10007', 4, '2C', 'First', 520.00, '2026-09-22'),
('OM10001', 5, '8B', 'Business', 295.00, '2026-09-22'),
('UK10002', 6, '18A', 'Economy', 140.00, '2026-09-23'),
('FR10003', 7, '4D', 'Business', 325.00, '2026-09-23');

INSERT INTO FLIGHT_CREW
(Flight_ID, License_Number)
VALUES
(1, 'LIC-P1001'),
(1, 'LIC-F1004'),
(1, 'LIC-C1003'),
(2, 'LIC-P1002'),
(2, 'LIC-F1005'),
(2, 'LIC-E1006'),
(3, 'LIC-P1001'),
(3, 'LIC-F1004'),
(4, 'LIC-P1002'),
(4, 'LIC-F1005'),
(5, 'LIC-P1001'),
(5, 'LIC-F1004'),
(6, 'LIC-P1002'),
(6, 'LIC-F1005'),
(7, 'LIC-P1001'),
(7, 'LIC-F1005'),
(7, 'LIC-E1006'),
(8, 'LIC-P1002'),
(8, 'LIC-F1004'),
(8, 'LIC-C1003');

SELECT * FROM AIRPORT;
SELECT * FROM AIRCRAFT;
SELECT * FROM PASSENGER;
SELECT * FROM CREW_MEMBER;
SELECT * FROM FLIGHT;
SELECT * FROM BOOKING;
SELECT * FROM FLIGHT_CREW;
