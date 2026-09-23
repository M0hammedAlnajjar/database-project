USE skytrack_airline_db;

-- PART 1: RESEARCH
--
-- 1. Database Index
-- An index is a database structure that helps SQL Server find rows faster
-- without scanning every row in a table. It is useful when a column is used
-- frequently in WHERE, JOIN, ORDER BY, or GROUP BY operations.
--
-- 2. Clustered Index and Non-Clustered Index
-- A clustered index controls the physical order of the table data.
-- A table can have only one clustered index because the rows can only be
-- physically ordered in one way.
--
-- A non-clustered index is a separate structure that stores indexed values
-- and pointers to the table rows. A table can have multiple non-clustered indexes.
--
-- 3. Unique Index
-- A unique index does not allow duplicate values in the indexed column.
-- In SkyTrack, Flight_Number and Registration_Number are naturally suitable
-- for unique indexes. National_ID, Email, and License_Number are also unique
-- in the schema.
--
-- The UNIQUE constraints already defined in the CREATE TABLE script cause
-- SQL Server to maintain uniqueness for these columns, so another duplicate
-- unique index is not needed.
--
-- 4. Composite Index
-- A composite index uses more than one column.
-- In SkyTrack, combining Status and Departure_Datetime can help queries that
-- filter flights by status and then work with their departure date/time.
--
-- 5. Index Trade-Off
-- Indexes improve read performance, but they use additional storage.
-- INSERT, UPDATE, and DELETE operations can become slower because SQL Server
-- must also update the related indexes whenever table data changes.


-- INDEX 1
-- Table and columns: FLIGHT(Status, Departure_Datetime)
-- Type: Non-Clustered Composite Index
-- Benefits:
--   06-Queries-Basic.sql Query 1
--   06-Queries-Basic.sql Query 5
--   08-Queries-Advanced.sql Query 8
-- Reason:
-- Status is used for filtering and Departure_Datetime is used for ordering
-- and flight reporting.

CREATE INDEX IX_FLIGHT_Status_Departure
ON FLIGHT (Status, Departure_Datetime);


-- INDEX 2
-- Table and column: BOOKING(Flight_ID)
-- Type: Non-Clustered Index
-- Benefits:
--   07-Queries-Medium.sql Queries 2, 8, 9
--   08-Queries-Advanced.sql Queries 1, 3, 5, 6, 10
-- Reason:
-- Flight_ID is used repeatedly to join BOOKING with FLIGHT and to group
-- booking information by flight.

CREATE INDEX IX_BOOKING_Flight_ID
ON BOOKING (Flight_ID);


-- INDEX 3
-- Table and column: BOOKING(National_ID)
-- Type: Non-Clustered Index
-- Benefits:
--   07-Queries-Medium.sql Queries 2 and 5
--   08-Queries-Advanced.sql Queries 2 and 8
-- Reason:
-- National_ID is frequently used to join BOOKING with PASSENGER and to
-- determine which passengers have or have not made bookings.

CREATE INDEX IX_BOOKING_National_ID
ON BOOKING (National_ID);


-- INDEX 4
-- Table and columns: FLIGHT_CREW(License_Number, Flight_ID)
-- Type: Non-Clustered Composite Index
-- Benefits:
--   07-Queries-Medium.sql Query 3
--   08-Queries-Advanced.sql Queries 4, 9, 10
-- Reason:
-- License_Number is used to join FLIGHT_CREW with CREW_MEMBER, while
-- Flight_ID identifies the flights assigned to each crew member.

CREATE INDEX IX_FLIGHT_CREW_License_Flight
ON FLIGHT_CREW (License_Number, Flight_ID);


-- INDEX 5
-- Table and columns: FLIGHT(Origin_IATA_Code, Destination_IATA_Code)
-- Type: Non-Clustered Composite Index
-- Benefits:
--   07-Queries-Medium.sql Queries 1 and 9
--   08-Queries-Advanced.sql Queries 1, 6, and 10
-- Reason:
-- Origin_IATA_Code and Destination_IATA_Code are repeatedly used to join
-- FLIGHT with AIRPORT for origin and destination information.

CREATE INDEX IX_FLIGHT_Origin_Destination
ON FLIGHT (Origin_IATA_Code, Destination_IATA_Code);


-- COLUMN WHERE AN ADDITIONAL INDEX IS NOT VERY USEFUL
--
-- CREW_MEMBER.Role has only a small number of allowed values:
-- Pilot, Co-Pilot, Flight Attendant, and Engineer.
-- Because the number of different values is very small, an index only on
-- Role may have low selectivity and may not provide enough benefit to justify
-- the extra storage and maintenance cost for INSERT, UPDATE, and DELETE.
