-- In this SQL file, write (and comment!) the schema of your database,
-- including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-----------------------------------------------------------------------------------
-- DROP if resetting:
-- DROP TABLE IF EXISTS "customers";
-- DROP TABLE IF EXISTS "rentals";
-- DROP TABLE IF EXISTS "e_bikes";
-- DROP TABLE IF EXISTS "e_bike_location_history";
-- DROP TABLE IF EXISTS "has_bikes";
-- DROP TABLE IF EXISTS "rental_locations";
-- DROP TABLE IF EXISTS "maintenance_locations";
-- DROP TABLE IF EXISTS "maintenance_tickets";
-- DROP TABLE IF EXISTS "batteries";
-- DROP TABLE IF EXISTS "charging_sessions";
-- DROP TABLE IF EXISTS "charging_stations";

-- DROP VIEW "available_e_bikes";
-- DROP VIEW "current_rentals_detailed";
-- DROP VIEW "must_charge";

-- DROP INDEX "customer_name_index";
-- DROP INDEX "rental_customer_index";
-- DROP INDEX "location_history_search_index";
-- DROP INDEX "rental_time_index";

-----------------------------------------------------------------------------------
-- CREATE
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
    "cost" NUMERIC CHECK ("cost" >= 0),
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
    "charge_level" INTEGER NOT NULL CHECK ("charge_level" BETWEEN 0 AND 100),
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

-----------------------------------------------------------------------------------
-- VIEWS

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

CREATE INDEX "rental_time_index"
ON "rentals" ("start_time", "end_time");

-- SELECT * FROM "rentals"
-- WHERE "start_time" > "2025-02-20";

-- QUERY PLAN
-- `--SEARCH rentals USING INDEX rental_time_index (start_time>?)

