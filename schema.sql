-- Get rid of the tables
DROP TABLE IF EXISTS "customers";
DROP TABLE IF EXISTS "rentals";
DROP TABLE IF EXISTS "e_bikes";
DROP TABLE IF EXISTS "e_bike_location_history";
DROP TABLE IF EXISTS "has_bikes";
DROP TABLE IF EXISTS "rental_locations";
DROP TABLE IF EXISTS "maintenance_locations";
DROP TABLE IF EXISTS "maintenance_tickets";
DROP TABLE IF EXISTS "batteries";
DROP TABLE IF EXISTS "charging_sessions";
DROP TABLE IF EXISTS "charging_stations";

DROP VIEW "available_e_bikes";
DROP VIEW "current_rentals_detailed";
DROP VIEW "must_charge";

DROP INDEX "customer_name_index";
DROP INDEX "rental_customer_index";
DROP INDEX "location_history_search_index";
DROP INDEX "rental_time_index";

-- Represent users who will rent e-bikes
CREATE TABLE "customers" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "email" TEXT NOT NULL UNIQUE,
    "phone_number" TEXT NOT NULL UNIQUE,
    "account_created" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "account_active" INTEGER NOT NULL CHECK ("account_active" IN (0,1)), -- BOOL
    PRIMARY KEY("id")
);

-- Represent a record of the e-bike rental
CREATE TABLE "rentals" (
    "id" INTEGER,
    "start_location_id" INTEGER NOT NULL,
    "end_location_id" INTEGER,
    "e_bike_id" INTEGER,
    "customer_id" INTEGER,
    "fare_amount" NUMERIC CHECK ("fare_amount" > 0),
    "rental_distance_km" REAL,
    "start_time" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "end_time" NUMERIC,
    "charge_consumption" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("start_location_id") REFERENCES "rental_locations"("id"),
    FOREIGN KEY("end_location_id") REFERENCES "rental_locations"("id"),
    FOREIGN KEY("e_bike_id") REFERENCES "e_bikes"("id"),
    FOREIGN KEY("customer_id") REFERENCES "customers"("id")
);

-- Represent the particular e-bike
CREATE TABLE "e_bikes" (
    "id" INTEGER,
    "battery_id" INTEGER,
    "latest_location_history_id" INTEGER,
    "photo" BLOB,
    PRIMARY KEY("id"),
    FOREIGN KEY("battery_id") REFERENCES "batteries"("id"),
    FOREIGN KEY("latest_location_history_id") REFERENCES "e_bike_location_history"("id")
);
-- NB: Although there is some data duplication with including the longitude and latitude,
--     It was included here for faster lookup.

-- Represent locations where to rent e-bikes
CREATE TABLE "e_bike_location_history" (
    "id" INTEGER,
    "e_bike_id" INTEGER,
    "rental_id" INTEGER,
    "latitude" REAL NOT NULL,
    "longitude" REAL NOT NULL,
    "updated_at" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("e_bike_id") REFERENCES "e_bikes"("id"),
    FOREIGN KEY("rental_id") REFERENCES "rentals"("id")
);
-- NB: this table can check if there is a theft. It can also help for data collection on
--     different routes taken throughout the city or hot-spots

CREATE TABLE "has_bikes" (
    "id" INTEGER,
    "e_bike_id" INTEGER,
    "rental_location_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("e_bike_id") REFERENCES "e_bikes"("id"),
    FOREIGN KEY("rental_location_id") REFERENCES "rental_locations"("id")
);
-- Having this table helps for faster queries. It quickly matches which bikes at which areas.
-- (where specific bikes are, how many bikes at different stations, help with distribution,
-- or which locations have no bikes!)

-- Represent locations where to rent e-bikes
CREATE TABLE "rental_locations" (
    "id" INTEGER,
    "street" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "postal_code" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Represent locations where e-bikes are maintained
CREATE TABLE "maintenance_locations" (
    "id" INTEGER,
    "street" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "postal_code" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Represent repair tickets on e-bikes
CREATE TABLE "maintenance_tickets" (
    "id" INTEGER,
    "maintenance_location_id" INTEGER,
    "e_bike_id" INTEGER,
    -- "mechanic_id" INTEGER,
    "issue_type" TEXT NOT NULL CHECK ("issue_type" IN (
        'FRAME', 'WHEEL', 'ELECTRONIC', 'BRAKES', 'LIGHTS', 'MISC'
        )),
    "description" TEXT,
    "cost" NUMERIC,
    "time_start" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "time_end" NUMERIC,
    "photo" BLOB,
    PRIMARY KEY("id"),
    FOREIGN KEY("maintenance_location_id") REFERENCES "maintenance_locations"("id"),
    FOREIGN KEY("e_bike_id") REFERENCES "e_bikes"("id")
    -- FOREIGN KEY("mechanic_id") REFERENCES "mechanic"("id")
    -- Operational functionality will not be implemented this iteration
);

-- Represent individual batteries used in e-bikes
CREATE TABLE "batteries" (
    "id" INTEGER,
    "charge_level" INTEGER NOT NULL,
    "photo" BLOB,
    PRIMARY KEY("id")
);

-- Represent a record of batteries being charged
CREATE TABLE "charging_sessions" (
    "id" INTEGER,
    "battery_id" INTEGER,
    "charging_station_id" INTEGER,
    "time_charge_start"  NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "time_charge_end" NUMERIC,
    PRIMARY KEY("id"),
    FOREIGN KEY("battery_id") REFERENCES "batteries"("id"),
    FOREIGN KEY("charging_station_id") REFERENCES "charging_stations"("id")
);

-- Represent locations of charging stations
CREATE TABLE "charging_stations" (
    "id" INTEGER,
    "street" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "postal_code" TEXT NOT NULL,
    "total_chargers" INTEGER NOT NULL,
    PRIMARY KEY("id")
);

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



-- The views as reflected in queries.sql

CREATE VIEW "available_e_bikes" AS
    SELECT "e_bikes"."id" AS "e-bike id", "charge_level" AS "Total Charge (%)", "battery_id", "street"
    FROM "e_bikes"
    INNER JOIN "has_bikes" ON "e_bikes"."id" = "has_bikes"."e_bike_id"
    INNER JOIN "rental_locations" ON "has_bikes"."rental_location_id" = "rental_locations"."id"
    INNER JOIN "batteries" ON "e_bikes"."battery_id" = "batteries"."id"
    ORDER BY "charge_level" DESC;

-- This view gives details and locations to e-bikes currently rented out
CREATE VIEW "current_rentals_detailed" AS
    SELECT "rentals"."id" AS "rental id", "street" AS "start_location",
    "e_bike_id", "first_name", "last_name", "start_time"
    FROM "rentals"
    INNER JOIN "rental_locations" ON "rentals"."start_location_id" = "rental_locations"."id"
    INNER JOIN "customers" ON "rentals"."customer_id" = "customers"."id"
    WHERE "end_location_id" IS NULL;

-- This view allows e-bikes at rental locations to be charged
CREATE VIEW "must_charge" AS
    SELECT "batteries"."id" AS "battery_id", "charge_level" AS "Total Charge (%)", "rental_locations"."street"
    FROM "batteries"
    INNER JOIN "e_bikes" ON "e_bikes"."battery_id" = "batteries"."id"
    INNER JOIN "has_bikes" ON "e_bikes"."id" = "has_bikes"."e_bike_id"
    INNER JOIN "rental_locations" ON "has_bikes"."rental_location_id" = "rental_locations"."id"
    WHERE "charge_level" < 30
    AND "batteries"."id" NOT IN (
        SELECT "battery_id"
        FROM "charging_sessions"
    )
    ORDER BY "charge_level" ASC;



-----------------------------------------------------------------------------------

CREATE INDEX "customer_name_index"
ON "customers" ("first_name", "last_name");

-- SELECT * FROM "rentals"
-- WHERE "customer_id" = (
--     SELECT "id" FROM "customers"
--     WHERE "last_name" = 'Brown'
-- );

-- |--SCAN rentals
-- `--SCALAR SUBQUERY 1
--    `--SCAN customers USING COVERING INDEX customer_name_search

-----------------------------------------------------------------------------------

CREATE INDEX "rental_customer_index"
ON "rentals" ("customer_id");

CREATE INDEX "location_history_search_index"
ON "e_bike_location_history" ("e_bike_id");

-- SELECT "latitude", "longitude" FROM "e_bike_location_history"
-- WHERE "e_bike_id" = (
--     SELECT "id" FROM "rentals"
--     WHERE "customer_id" = (
--         SELECT "id" FROM "customers"
--         WHERE "last_name" = 'Brown'
--     )
-- );

-- QUERY PLAN
-- |--SEARCH e_bike_location_history USING INDEX location_history_search (e_bike_id=?)
-- `--SCALAR SUBQUERY 2
--    |--SEARCH rentals USING COVERING INDEX rental_index (customer_id=?)
--    `--SCALAR SUBQUERY 1
--       `--SCAN customers USING COVERING INDEX customer_name_search

-----------------------------------------------------------------------------------

CREATE INDEX "rental_time_index"
ON "rentals" ("start_time", "end_time");

-- SELECT * FROM "rentals"
-- WHERE "start_time" > "2025-02-20";

-- QUERY PLAN
-- `--SEARCH rentals USING INDEX rental_time_index (start_time>?)


