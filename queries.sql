-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database
-- Queries helping in building the database for row insertion:

-------------------------------------------------------------------------------------------------

-- Find all currently rented bikes:
SELECT * FROM "e_bikes"
WHERE "id" NOT IN (
    SELECT "e_bike_id"
    FROM "has_bikes"
);
-- OR more granularly, with locations
SELECT "e_bikes"."id" AS "e_bike id", "longitude", "latitude", "start_time", "end_time"
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
SELECT "id" AS "battery_id", "charge_level" FROM "batteries"
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
SELECT "e_bikes"."id" AS "e-bike id", "battery_id", "street" FROM "e_bikes"
INNER JOIN "has_bikes" ON "e_bikes"."id" = "has_bikes"."e_bike_id"
INNER JOIN "rental_locations" ON "has_bikes"."rental_location_id" = "rental_locations"."id"
ORDER BY "street";

-------------------------------------------------------------------------------------------------

-- List e-bikes and their charges
-- This may become a view (see below)~
-- Lets also order them by charge levels
SELECT "e_bikes"."id" AS "e-bike id", "charge_level", "battery_id", "street"
FROM "e_bikes"
INNER JOIN "has_bikes" ON "e_bikes"."id" = "has_bikes"."e_bike_id"
INNER JOIN "rental_locations" ON "has_bikes"."rental_location_id" = "rental_locations"."id"
INNER JOIN "batteries" ON "e_bikes"."battery_id" = "batteries"."id"
ORDER BY "charge_level" DESC;



-------------------------------------------------------------------------------------------------

CREATE VIEW "available_e_bikes" AS
    SELECT "e_bikes"."id" AS "e-bike id", "charge_level", "battery_id", "street"
    FROM "e_bikes"
    INNER JOIN "has_bikes" ON "e_bikes"."id" = "has_bikes"."e_bike_id"
    INNER JOIN "rental_locations" ON "has_bikes"."rental_location_id" = "rental_locations"."id"
    INNER JOIN "batteries" ON "e_bikes"."battery_id" = "batteries"."id"
    ORDER BY "charge_level" DESC;

CREATE VIEW "current_rentals_detailed" AS
    SELECT "rentals"."id" AS "rental id", "street" AS "start_location",
    "e_bike_id", "first_name", "last_name", "start_time"
    FROM "rentals"
    INNER JOIN "rental_locations" ON "rentals"."start_location_id" = "rental_locations"."id"
    INNER JOIN "customers" ON "rentals"."customer_id" = "customers"."id"
    WHERE "end_location_id" IS NULL;


-------------------------------------------------------------------------------------------------

-- For fun, lets check if a bike goes beyond city bounds
-- Roughly checked against a large buffer of max/mins of a city's longitude and latitude.
-- This may protect against theft, or be a warning system that can alert customers

-- For the city of Luzern, as per the data in our db, the MAX and MIN lat and longs are as follows:
-- LONGITUDE
    -- MAX: 8.357405
    -- MIN: 8.233749
-- LATITUDE:
    -- MAX: 47.087481
    -- MIN: 47.015668



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
