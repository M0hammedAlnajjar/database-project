# SkyTrack Airline System

## Project Description

SkyTrack Airline System is a database project for managing the core operations of a regional airline. The system stores airports, aircraft, flights, passengers, bookings, crew members, and flight crew assignments.

The database allows the airline to track where each flight departs from and arrives at, which aircraft is assigned to each flight, which passengers booked each flight, and which crew members are assigned to each flight.

## ERD Summary

The main entities are:

- AIRPORT
- AIRCRAFT
- FLIGHT
- PASSENGER
- BOOKING
- CREW_MEMBER
- FLIGHT_CREW

Important relationships:

- One AIRCRAFT can be assigned to many FLIGHT records.
- One AIRPORT can be the origin airport for many flights.
- One AIRPORT can be the destination airport for many flights.
- One PASSENGER can have many BOOKING records.
- One FLIGHT can have many BOOKING records.
- FLIGHT and CREW_MEMBER have a many-to-many relationship.
- FLIGHT_CREW is used to manage the many-to-many relationship between FLIGHT and CREW_MEMBER.

A design decision was made to keep origin and destination as two separate relationships because every flight has one origin airport and one destination airport.

## Mapping Decisions

The foreign keys were placed as follows:

- FLIGHT.Registration_Number references AIRCRAFT.Registration_Number.
- FLIGHT.Origin_IATA_Code references AIRPORT.IATA_Code.
- FLIGHT.Destination_IATA_Code references AIRPORT.IATA_Code.
- BOOKING.National_ID references PASSENGER.National_ID.
- BOOKING.Flight_ID references FLIGHT.Flight_ID.
- FLIGHT_CREW.Flight_ID references FLIGHT.Flight_ID.
- FLIGHT_CREW.License_Number references CREW_MEMBER.License_Number.

BOOKING stores the relationship between passengers and flights together with booking information such as Seat_Number, Class, Price_Paid, and Booking_Date.

FLIGHT_CREW stores the relationship between flights and crew members.

## Errors Faced and How They Were Resolved

### Multiple Cascade Paths

SQL Server returned a multiple cascade paths error because FLIGHT has two foreign keys that both reference AIRPORT:

- Origin_IATA_Code
- Destination_IATA_Code

Using ON DELETE CASCADE and ON UPDATE CASCADE on both relationships caused SQL Server to reject the second cascade path.

The issue was resolved by keeping CASCADE on the origin relationship and using NO ACTION on the destination relationship.

### Schema and INSERT Mismatch

During testing, some INSERT and DML scripts used column names that did not match the current table structure. This caused errors such as invalid column names and invalid object names.

The issue was resolved by making the CREATE TABLE, INSERT, UPDATE, DELETE, and query files use the same table names and column names.

### DELETE and Cascading Rows

Deleting a flight also removed related booking and flight crew rows when the foreign key used ON DELETE CASCADE.

Deleting a passenger with existing bookings also removed the related bookings automatically because BOOKING is connected to PASSENGER with ON DELETE CASCADE.

This explained why the row counts became lower after running the DELETE tasks.

## WHERE and HAVING

WHERE filters individual rows before grouping happens.

Example:

```sql
SELECT *
FROM FLIGHT
WHERE Status = 'Cancelled';
```

HAVING filters grouped results after GROUP BY has been applied.

Example:

```sql
SELECT Flight_ID, COUNT(*) AS Total_Bookings
FROM BOOKING
GROUP BY Flight_ID
HAVING COUNT(*) > 1;
```

In simple words:

- WHERE = filter rows.
- HAVING = filter groups.

## Most Useful Query

The most useful query in this project is the final advanced flight summary because it combines information from the main parts of the system.

It displays:

- Flight number
- Origin airport city
- Destination airport city
- Aircraft model
- Aircraft manufacturer
- Total passengers booked
- Total crew assigned
- Total revenue

This query is useful because it gives a complete operational and financial summary of each flight in one result.

## BONUS — Indexing Research

### What Is a Database Index?

A database index is a structure that helps SQL Server locate data faster. Without a useful index, SQL Server may need to scan many rows to find the required data.

Indexes are especially useful for columns that are frequently used in:

- WHERE
- JOIN
- ORDER BY
- GROUP BY

### Clustered Index vs Non-Clustered Index

A clustered index controls the physical order of the rows in the table.

A table can have only one clustered index because table rows can only have one physical ordering.

A non-clustered index is stored separately from the table data and contains indexed values with references to the matching rows.

A table can have multiple non-clustered indexes.

### Unique Index

A unique index prevents duplicate values.

Columns naturally suitable for uniqueness in SkyTrack include:

- FLIGHT.Flight_Number
- AIRCRAFT.Registration_Number
- PASSENGER.National_ID
- PASSENGER.Email
- CREW_MEMBER.License_Number

The schema already uses UNIQUE constraints for these values, so creating duplicate unique indexes on the same columns is unnecessary.

### Composite Index

A composite index contains more than one column.

An example in SkyTrack is:

```sql
FLIGHT(Status, Departure_Datetime)
```

This can help when the system filters flights by status and also works with their departure date and time.

### Index Trade-Off

Indexes make many SELECT queries faster, but they also have a cost.

Every INSERT, UPDATE, or DELETE may require SQL Server to update the related indexes.

Therefore:

- More indexes can improve reading.
- Too many indexes can slow data modifications.
- Indexes also use additional storage.

## Indexes Added

### 1. IX_FLIGHT_Status_Departure

Table:

```text
FLIGHT
```

Columns:

```text
Status, Departure_Datetime
```

Type:

```text
Non-Clustered Composite Index
```

Why:

The project filters flights by Status and orders or reports them using Departure_Datetime.

Related queries include Basic Queries 1 and 5 and Advanced Query 8.

### 2. IX_BOOKING_Flight_ID

Table:

```text
BOOKING
```

Column:

```text
Flight_ID
```

Type:

```text
Non-Clustered Index
```

Why:

Flight_ID is used many times when BOOKING is joined with FLIGHT and when booking totals or revenue are calculated per flight.

This index supports several Medium and Advanced queries.

### 3. IX_BOOKING_National_ID

Table:

```text
BOOKING
```

Column:

```text
National_ID
```

Type:

```text
Non-Clustered Index
```

Why:

National_ID is used when BOOKING is joined with PASSENGER and when checking whether a passenger has bookings.

### 4. IX_FLIGHT_CREW_License_Flight

Table:

```text
FLIGHT_CREW
```

Columns:

```text
License_Number, Flight_ID
```

Type:

```text
Non-Clustered Composite Index
```

Why:

This helps queries that find crew assignments and count how many flights each crew member has worked on.

### 5. IX_FLIGHT_Origin_Destination

Table:

```text
FLIGHT
```

Columns:

```text
Origin_IATA_Code, Destination_IATA_Code
```

Type:

```text
Non-Clustered Composite Index
```

Why:

Many queries need to join FLIGHT to AIRPORT twice to display the origin and destination information.

## Column Where an Extra Index Is Not Beneficial

An additional index only on:

```text
CREW_MEMBER.Role
```

is not very useful in this project.

Role only contains a small set of values:

- Pilot
- Co-Pilot
- Flight Attendant
- Engineer

Because there are very few different values, the column has low selectivity. Maintaining another index on this column may add INSERT, UPDATE, and DELETE cost without providing enough performance improvement.

## Two Most Critical Indexes

If SkyTrack processes thousands of bookings and flight status updates every day, the two indexes I consider most critical are:

### IX_BOOKING_Flight_ID

This is important because many reporting queries connect bookings to flights. It helps with passenger counts, revenue calculations, average prices, and flight summaries.

### IX_FLIGHT_Status_Departure

This is important because flight status is frequently checked and updated, and airline operations often need to find flights by status and departure time.

These two indexes support two of the most active areas of the system: booking activity and flight operations.

## Project Structure

```text
database-project/
├── 01-ERD/
├── 02-Mapping/
├── 03-Create-Tables.sql
├── 04-Insert-Data.sql
├── 05-Update-Delete.sql
├── 06-Queries-Basic.sql
├── 07-Queries-Medium.sql
├── 08-Queries-Advanced.sql
├── BONUS/
│   └── indexing.sql
└── README.md
```
