-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database
-- Queries helping in building the database for row insertion:

-- INSERTS
-------------------------------------------------------------------------------------------------
-- Populate the tables

INSERT INTO "customers" ("first_name", "last_name", "email", "phone_number", "account_created", "account_active")
VALUES
('Alice', 'Johnson', 'alice.johnson@example.com', '041-123-456', '01-15-2023', 1),
('Björn', 'Andersson', 'bjorn.andersson@example.se', '041-234-567', '02-22-2023', 1),
('Charlie', 'Davis', 'charlie.davis@example.com', '041-345-678', '03-10-2023', 1),
('Diana', 'Miller', 'diana.miller@example.com', '041-456-789', '04-05-2023', 1),
('Élodie', 'Dubois', 'elodie.dubois@example.fr', '041-567-890', '05-18-2023', 1),
('Fiona', 'Brown', 'fiona.brown@example.com', '041-678-901', '06-25-2023', 1),
('George', 'Taylor', 'george.taylor@example.com', '041-789-012', '07-30-2023', 1),
('Hannah', 'Anderson', 'hannah.anderson@example.com', '041-890-123', '08-14-2023', 1),
('Isaac', 'Martinez', 'isaac.martinez@example.com', '041-901-234', '09-27-2023', 1),
('Jürgen', 'Schmidt', 'jurgen.schmidt@example.de', '041-012-345', '10-31-2023', 1),
('Katarina', 'Novak', 'katarina.novak@example.hr', '041-123-678', '11-20-2023', 1),
('Luca', 'Rossi', 'luca.rossi@example.it', '041-234-789', '12-08-2023', 1),
('Mikael', 'Lindberg', 'mikael.lindberg@example.se', '041-345-890', '01-12-2024', 1),
('Nina', 'Lewis', 'nina.lewis@example.com', '041-456-012', '02-25-2024', 1),
('Olivier', 'Moreau', 'olivier.moreau@example.fr', '041-567-123', '03-14-2024', 1),
('Paula', 'Hall', 'paula.hall@example.com', '041-678-234', '04-19-2024', 1),
('Quentin', 'King', 'quentin.king@example.com', '041-789-345', '05-05-2024', 1),
('Rasmus', 'Jørgensen', 'rasmus.jorgensen@example.dk', '041-890-456', '06-22-2024', 1),
('Sven', 'Müller', 'sven.mueller@example.de', '041-901-567', '07-08-2024', 1),
('Tatiana', 'Ivanova', 'tatiana.ivanova@example.ru', '041-012-678', '08-30-2024', 1);

INSERT INTO "rental_locations" ("street", "city", "postal_code")
VALUES
('Pilatusstrasse 15', 'Luzern', '6003'),
('Hirschmattstrasse 7', 'Luzern', '6003'),
('Bundesplatz 3', 'Luzern', '6003'),
('Museggstrasse 12', 'Luzern', '6004'),
('Seeburgstrasse 45', 'Luzern', '6006');

INSERT INTO "maintenance_locations" ("street", "city", "postal_code", "phone_number")
VALUES
('Industriestrasse 20', 'Luzern', '6005', '041-123-4567'),
('Werkhofstrasse 8', 'Luzern', '6002', '041-987-6543');

INSERT INTO "charging_stations" ("id", "street", "city", "postal_code", "total_chargers")
VALUES
(1, 'Bergstrasse 8', 'Luzern', '6004', 25),
(2, 'Bahnhofplatz 1', 'Luzern', '6003', 35);


INSERT INTO "batteries" ("charge_level")
VALUES
(60),
(88),
(45),
(93),
(20),
(75),
(50),
(30),
(70),
(10),
(25),
(65),
(52),
(89),
(45),
(11),
(25),
(65),
(55),
(86),
(41),
(28),
(93),
(65),
(35),
(100),
(5),
(92),
(76),
(47),
(82);

INSERT INTO "e_bikes" ("latest_location_history_id", "battery_id")
VALUES
(NULL, 1),
(NULL, 5),
(NULL, 6),
(NULL, 8),
(NULL, 9),
(NULL, 10),
(NULL, 12),
(NULL, 13),
(NULL, 14),
(NULL, 16),
(NULL, 17),
(NULL, 18),
(NULL, 19),
(NULL, 22),
(NULL, 24),
(NULL, 27),
(NULL, 30);


--  Add charging sessions for all batteries not in a bike~~
INSERT INTO "charging_sessions" ("battery_id", "charging_station_id", "time_charge_start", "time_charge_end")
VALUES
(2, 1, '2024-03-05 11:13:10', '2024-03-05 17:15:10'),
(3, 2, '2024-03-12 14:45:30', '2024-03-12 21:22:50'),
(4, 1, '2024-03-28 09:30:00', '2024-03-28 16:10:15'),
(7, 2, '2024-04-04 12:05:20', '2024-04-04 18:33:55'),
(11, 1, '2024-04-15 08:50:45', '2024-04-15 14:35:30'),
(15, 2, '2024-04-27 17:12:00', '2024-04-27 23:18:10'),
(20, 1, '2024-05-08 06:40:25', '2024-05-08 13:22:00'),
(21, 2, '2024-05-21 15:55:00', '2024-05-21 21:37:45'),
(23, 1, '2024-06-02 10:20:15', '2024-06-02 16:49:30'),
(25, 2, '2024-06-13 19:10:30', '2024-06-14 01:55:40'),
(26, 1, '2024-06-25 04:55:50', '2024-06-25 11:35:00'),
(28, 2, '2024-07-03 09:45:25', '2024-07-03 15:50:10'),
(29, 1, '2024-07-10 13:35:40', '2024-07-10 20:22:15'),
(30, 2, '2024-07-17 07:55:50', '2024-07-17 13:40:35');


-- Add rental slips for the rented bikes that are completed
INSERT INTO "rentals" ("start_location_id","end_location_id","e_bike_id","customer_id",
    "fare_amount","rental_distance_km","start_time","end_time","charge_consumption")
VALUES
(2,2,1,19,"4.75",3,"2024-03-5 11:13:10","2024-03-5 13:14:09",12),
(1,5,2,5,"17.31",8,"2024-03-17 08:19:03","2024-03-17 15:19:41",54),
(4,1,3,13,"11.90",5,"2024-05-21 10:19:42","2024-05-21 14:19:28",34),
(4,1,4,2,"11.90",5,"2024-05-21 10:19:53","2024-05-21 14:19:21",35),
(3,4,5,11,"2.45",1,"2024-07-31 09:19:24","2024-07-31 09:29:34",3),
(4,3,5,11,"3.95",2,"2024-08-01 09:21:33","2024-08-01 10:31:32",7);

INSERT INTO "rentals" ("start_location_id","end_location_id","e_bike_id","customer_id",
    "fare_amount","rental_distance_km","start_time","end_time","charge_consumption")
VALUES(4,3,5,11,"3.95",2,"2024-08-01 09:21:33","2024-08-01 10:31:32",7);

--  Add rental slips for the rented bikes in progress
INSERT INTO "rentals" ("start_location_id","e_bike_id","customer_id")
VALUES
(2,1,17),
(1,2,6),
(4,7,11),
(4,12,18),
(3,13,1);

--  Add locations histories for the rented bikes...
INSERT INTO "e_bike_location_history" ("e_bike_id","rental_id","latitude","longitude")
VALUES
(1, 1, "47.050257","8.309755"),
(2, 2, "47.051867","8.302921"),
(7, 3, "47.052676","8.304137"),
(12, 4, "47.048533","8.303985"),
(13, 5, "46.955874","8.277111");

-- Update the last known location for the rented bikes.
UPDATE "e_bikes" SET "latest_location_history_id" = 1 WHERE "id" = 1;
UPDATE "e_bikes" SET "latest_location_history_id" = 2 WHERE "id" = 2;
UPDATE "e_bikes" SET "latest_location_history_id" = 3 WHERE "id" = 7;
UPDATE "e_bikes" SET "latest_location_history_id" = 4 WHERE "id" = 12;
UPDATE "e_bikes" SET "latest_location_history_id" = 5 WHERE "id" = 13;

--  has_bikes for all the available slots
INSERT INTO "has_bikes" ("e_bike_id", "rental_location_id")
VALUES
(3,1),
(4,3),
(5,2),
(6,3),
(8,4),
(9,1),
(10,1),
(14,5),
(15,3),
(16,2),
(17,5);

--  Put one bike on a maintenance ticket...
INSERT INTO "maintenance_tickets" ("maintenance_location_id","e_bike_id","issue_type","description","cost","time_start","time_end")
VALUES (1, 8, 'FRAME','Replaced middle frame', "290.50","2024-06-21 11:19:43","2024-06-22 09:33:20");

INSERT INTO "maintenance_tickets" ("maintenance_location_id","e_bike_id","issue_type")
VALUES (2, 11, 'WHEEL');


-- QUERIES
-------------------------------------------------------------------------------------------------
-- These are the types of queries that will be used.

-- Find how many times a particular bike has been rented
SELECT COUNT("id") FROM "rentals"
WHERE "e_bike_id" = 5;


-- Find out how far a particular has travelled in km.
SELECT SUM("rental_distance_km") FROM "rentals"
WHERE "e_bike_id" = 5;

-------------------------------------------------------------------------------------------------

-- Find all currently rented bikes:
SELECT * FROM "e_bikes"
WHERE "id" NOT IN (
    SELECT "e_bike_id"
    FROM "has_bikes"
);
-- OR more granularly, with locations
SELECT "e_bikes"."id" AS "e_bike id", "longitude", "latitude", "start_time"
FROM "e_bikes"
INNER JOIN "rentals" ON "rentals"."e_bike_id" = "e_bikes"."id"
LEFT JOIN "e_bike_location_history" ON "e_bikes"."latest_location_history_id" = "e_bike_location_history"."id"
WHERE "rentals"."end_time" IS NULL;
--OR
-- Find all ongoing rentals by customers
SELECT "rentals"."id" AS "rental id", "street" AS "start_location",
    "e_bike_id", "first_name", "last_name", "start_time"
FROM "rentals"
INNER JOIN "rental_locations" ON "rentals"."start_location_id" = "rental_locations"."id"
INNER JOIN "customers" ON "rentals"."customer_id" = "customers"."id"
WHERE "end_location_id" IS NULL;

-------------------------------------------------------------------------------------------------

-- Find all bikes past rented, with the information of customer, ordered by date...
-- Note that the subqueries need to go in the selects because of the double "street" column!
SELECT "rentals"."id" AS "rental id",
    (SELECT "street" FROM "rental_locations" WHERE "id" = "start_location_id") AS "start_location",
    (SELECT "street" FROM "rental_locations" WHERE "id" = "end_location_id")AS "end_location",
    "e_bike_id", "first_name", "last_name", "start_time", "end_time"
FROM "rentals"
INNER JOIN "customers" ON "rentals"."customer_id" = "customers"."id"
WHERE "end_location_id" IS NOT NULL
ORDER BY "end_time" DESC;


-- Find all the e-bikes that need to be charged; specified by having a percentage lower than 30%
-- Note that in this case, it gets all bikes not currently being charged,
-- a bike may still be rented out and not at a rental location!
-- The view "must_charge" below fixes this
SELECT "id" AS "battery_id", "charge_level" AS "Total Charge (%)"
FROM "batteries"
WHERE "charge_level" < 30
AND "id" NOT IN (
    SELECT "battery_id"
    FROM "charging_sessions"
);

-------------------------------------------------------------------------------------------------

-- Find all available bikes:
SELECT * FROM "has_bikes";

-- Find all bikes available at the different stations
SELECT * FROM "e_bikes"
INNER JOIN "has_bikes" ON "e_bikes"."id" = "has_bikes"."e_bike_id"
INNER JOIN "rental_locations" ON "has_bikes"."rental_location_id" = "rental_locations"."id"
ORDER BY "street";

-- Find all available bikes - A more concise table
SELECT "e_bikes"."id" AS "e-bike id", "battery_id", "street"
FROM "e_bikes"
INNER JOIN "has_bikes"
ON "e_bikes"."id" = "has_bikes"."e_bike_id"
INNER JOIN "rental_locations" 
ON "has_bikes"."rental_location_id" = "rental_locations"."id"
ORDER BY "street";

-------------------------------------------------------------------------------------------------

-- List e-bikes and their charges
-- This may become a view (see below)~
-- Lets also order them by charge levels
SELECT "e_bikes"."id" AS "e-bike id", "charge_level" AS "Total Charge (%)", "battery_id", "street"
FROM "e_bikes"
INNER JOIN "has_bikes" ON "e_bikes"."id" = "has_bikes"."e_bike_id"
INNER JOIN "rental_locations" ON "has_bikes"."rental_location_id" = "rental_locations"."id"
INNER JOIN "batteries" ON "e_bikes"."battery_id" = "batteries"."id"
ORDER BY "charge_level" DESC;

-------------------------------------------------------------------------------------------------
-- This view gives information on available e-bikes
-- CREATE VIEW "available_e_bikes" AS
--     SELECT "e_bikes"."id" AS "e-bike id", "charge_level" AS "Total Charge (%)", "battery_id", "street"
--     FROM "e_bikes"
--     INNER JOIN "has_bikes" ON "e_bikes"."id" = "has_bikes"."e_bike_id"
--     INNER JOIN "rental_locations" ON "has_bikes"."rental_location_id" = "rental_locations"."id"
--     INNER JOIN "batteries" ON "e_bikes"."battery_id" = "batteries"."id"
--     ORDER BY "charge_level" DESC;

-- -- This view gives details and locations to e-bikes currently rented out
-- CREATE VIEW "current_rentals_detailed" AS
--     SELECT "rentals"."id" AS "rental id", "street" AS "start_location",
--     "e_bike_id", "first_name", "last_name", "start_time"
--     FROM "rentals"
--     INNER JOIN "rental_locations" ON "rentals"."start_location_id" = "rental_locations"."id"
--     INNER JOIN "customers" ON "rentals"."customer_id" = "customers"."id"
--     WHERE "end_location_id" IS NULL;

-- -- This view allows e-bikes at rental locations to be charged
-- CREATE VIEW "must_charge" AS
--     SELECT "batteries"."id" AS "battery_id", "charge_level" AS "Total Charge (%)", "rental_locations"."street"
--     FROM "batteries"
--     INNER JOIN "e_bikes" ON "e_bikes"."battery_id" = "batteries"."id"
--     INNER JOIN "has_bikes" ON "e_bikes"."id" = "has_bikes"."e_bike_id"
--     INNER JOIN "rental_locations" ON "has_bikes"."rental_location_id" = "rental_locations"."id"
--     WHERE "charge_level" < 30
--     AND "batteries"."id" NOT IN (
--         SELECT "battery_id"
--         FROM "charging_sessions"
--     )
--     ORDER BY "charge_level" ASC;

-------------------------------------------------------------------------------------------------

-- For fun, lets check if a bike goes beyond city bounds
-- Roughly checked against a large buffer of max/mins of a city's longitude and latitude.
-- This may protect against theft, or be a warning system that can alert customers

-- For the city of Luzern, as per the data in our db, the MAX and MIN lat and longs are as follows:
-- LONGITUDE
    -- North (MAX): 8.357405
    -- South (MIN): 8.233749
-- LATITUDE:
    -- East (MAX): 47.087481
    -- West (MIN): 47.015668

SELECT * FROM "e_bike_location_history"
WHERE ("latitude" > 47.087481 OR "latitude" < 47.015668)
OR ("longitude" > 8.357405 OR "longitude" < 8.233749);

-- Or done with a union~
SELECT * FROM "e_bike_location_history"
WHERE "latitude" > 47.087481 OR "latitude" < 47.015668
UNION
SELECT * FROM "e_bike_location_history"
WHERE "longitude" > 8.357405 OR "longitude" < 8.233749;

-- We see that from our data one bike has ended up way out of Luzern, near Alpnach. That's a little far.
-- This would be great for a trigger, where the system tracks excursions and alerts into a specific table

-------------------------------------------------------------------------------------------------

-- For quick reference and speed! Basic queries!
SELECT * FROM "customers";
SELECT * FROM "rentals";
SELECT * FROM "e_bikes";
SELECT * FROM "e_bike_location_history";
SELECT * FROM "has_bikes";
SELECT * FROM "rental_locations";
SELECT * FROM "maintenance_locations";
SELECT * FROM "maintenance_tickets";
SELECT * FROM "batteries";
SELECT * FROM "charging_sessions";
SELECT * FROM "charging_stations";

-- Views
SELECT * FROM "available_e_bikes";
SELECT * FROM "current_rentals_detailed";
SELECT * FROM "must_charge";