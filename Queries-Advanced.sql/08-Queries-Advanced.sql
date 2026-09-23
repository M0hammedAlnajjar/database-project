USE skytrack_airline_db;

SELECT
    F.Flight_Number,
    O.Name AS Origin_Airport,
    D.Name AS Destination_Airport,
    A.Model AS Aircraft_Model,
    COUNT(B.Booking_ID) AS Total_Passengers
FROM FLIGHT F
JOIN AIRPORT O
ON F.Origin_IATA_Code = O.IATA_Code
JOIN AIRPORT D
ON F.Destination_IATA_Code = D.IATA_Code
JOIN AIRCRAFT A
ON F.Registration_Number = A.Registration_Number
LEFT JOIN BOOKING B
ON F.Flight_ID = B.Flight_ID
GROUP BY
    F.Flight_Number,
    O.Name,
    D.Name,
    A.Model;

SELECT
    P.*
FROM PASSENGER P
LEFT JOIN BOOKING B
ON P.National_ID = B.National_ID
WHERE B.Booking_ID IS NULL;

SELECT
    F.Flight_Number,
    SUM(B.Price_Paid) AS Total_Revenue
FROM FLIGHT F
JOIN BOOKING B
ON F.Flight_ID = B.Flight_ID
GROUP BY F.Flight_Number
HAVING SUM(B.Price_Paid) > 500
ORDER BY Total_Revenue DESC;

SELECT
    C.Full_Name,
    COUNT(FC.Flight_ID) AS Total_Flights
FROM CREW_MEMBER C
JOIN FLIGHT_CREW FC
ON C.License_Number = FC.License_Number
GROUP BY C.Full_Name
HAVING COUNT(FC.Flight_ID) > 1;

SELECT
    F.Flight_Number,
    AVG(B.Price_Paid) AS Average_Booking_Price
FROM FLIGHT F
JOIN BOOKING B
ON F.Flight_ID = B.Flight_ID
GROUP BY F.Flight_Number
HAVING AVG(B.Price_Paid) > (
    SELECT AVG(Price_Paid)
    FROM BOOKING
);

SELECT TOP 1
    F.Flight_Number,
    O.Name AS Origin_Airport,
    D.Name AS Destination_Airport,
    COUNT(B.Booking_ID) AS Total_Bookings
FROM FLIGHT F
JOIN AIRPORT O
ON F.Origin_IATA_Code = O.IATA_Code
JOIN AIRPORT D
ON F.Destination_IATA_Code = D.IATA_Code
JOIN BOOKING B
ON F.Flight_ID = B.Flight_ID
GROUP BY
    F.Flight_Number,
    O.Name,
    D.Name
ORDER BY Total_Bookings DESC;

SELECT
    Class,
    SUM(Price_Paid) AS Total_Revenue,
    COUNT(Booking_ID) AS Total_Bookings,
    AVG(Price_Paid) AS Average_Price,
    MAX(Price_Paid) AS Highest_Price,
    MIN(Price_Paid) AS Lowest_Price
FROM BOOKING
GROUP BY Class;

SELECT
    P.Full_Name,
    F.Flight_Number,
    B.Booking_Date
FROM BOOKING B
JOIN PASSENGER P
ON B.National_ID = P.National_ID
JOIN FLIGHT F
ON B.Flight_ID = F.Flight_ID
WHERE F.Status = 'Cancelled';

SELECT
    F.Flight_Number,
    COUNT(FC.License_Number) AS Total_Crew,
    F.Departure_Datetime
FROM FLIGHT F
JOIN FLIGHT_CREW FC
ON F.Flight_ID = FC.Flight_ID
JOIN CREW_MEMBER C
ON FC.License_Number = C.License_Number
GROUP BY
    F.Flight_ID,
    F.Flight_Number,
    F.Departure_Datetime
HAVING
    SUM(CASE WHEN C.Role = 'Pilot' THEN 1 ELSE 0 END) >= 1
AND
    SUM(CASE WHEN C.Role = 'Flight Attendant' THEN 1 ELSE 0 END) >= 1;

SELECT
    F.Flight_Number,
    O.City AS Origin_City,
    D.City AS Destination_City,
    A.Model AS Aircraft_Model,
    A.Manufacturer,
    ISNULL(B.Total_Passengers, 0) AS Total_Passengers,
    ISNULL(C.Total_Crew, 0) AS Total_Crew,
    ISNULL(B.Total_Revenue, 0) AS Total_Revenue
FROM FLIGHT F
JOIN AIRPORT O
ON F.Origin_IATA_Code = O.IATA_Code
JOIN AIRPORT D
ON F.Destination_IATA_Code = D.IATA_Code
JOIN AIRCRAFT A
ON F.Registration_Number = A.Registration_Number
LEFT JOIN (
    SELECT
        Flight_ID,
        COUNT(Booking_ID) AS Total_Passengers,
        SUM(Price_Paid) AS Total_Revenue
    FROM BOOKING
    GROUP BY Flight_ID
) B
ON F.Flight_ID = B.Flight_ID
LEFT JOIN (
    SELECT
        Flight_ID,
        COUNT(License_Number) AS Total_Crew
    FROM FLIGHT_CREW
    GROUP BY Flight_ID
) C
ON F.Flight_ID = C.Flight_ID
ORDER BY Total_Revenue DESC;
