-- Calculate the count of null values for each column in the `Bike_Share_Data_2023` table within the `Cyclistic_Bike_Share` dataset 
-- by subtracting the count of non-null values from the total count of rows for each column.

SELECT COUNT(*) - COUNT(ride_id) AS ride_id,
  COUNT(*) - COUNT(rideable_type) AS rideable_type,
  COUNT(*) - COUNT(started_at) AS started_at,
  COUNT(*) - COUNT(ended_at) AS ended_at,
  COUNT(*) - COUNT(start_station_name) AS start_station_name,
  COUNT(*) - COUNT(start_station_id) AS start_station_id,
  COUNT(*) - COUNT(end_station_name) AS end_station_name,
  COUNT(*) - COUNT(end_station_id) AS end_station_id,
  COUNT(*) - COUNT(start_lat) AS start_lat,
  COUNT(*) - COUNT(start_lng) AS start_lng,
  COUNT(*) - COUNT(end_lat) AS end_lat,
  COUNT(*) - COUNT(end_lng) AS end_lng,
  COUNT(*) - COUNT(member_casual) AS member_casual,
  COUNT(*) - COUNT(ride_length) AS ride_length,
  COUNT(*) - COUNT(day_of_week) AS day_of_week
FROM `zippy-venture-409222.Cyclistic_Bike_Share.Bike_Share_Data_2023`;


-- Calculate the count of duplicate rows in the `Bike_Share_Data_2023` table within the `Cyclistic_Bike_Share` dataset by subtracting the count 
-- of distinct `ride_id` values from the total count of `ride_id` values.

SELECT COUNT(ride_id) - COUNT(DISTINCT ride_id) AS duplicate_rows
FROM `zippy-venture-409222.Cyclistic_Bike_Share.Bike_Share_Data_2023`;


-- Create a new table named `Bike_Share_Data_2023_V1` in the `Cyclistic_Bike_Share` dataset, if it doesn't exist, with modified data from the `Bike_Share_Data_2023` table. 
-- The modification includes adding a new column `ride_length` calculated as the difference in minutes between `ended_at` and `started_at`, 
-- and a new column `month` derived from the `started_at` timestamp indicating the month name.

CREATE TABLE IF NOT EXISTS `zippy-venture-409222.Cyclistic_Bike_Share.Bike_Share_Data_2023_V1` AS (
  SELECT 
    ride_id, rideable_type, started_at, ended_at, 
    start_station_name, start_station_id, end_station_name, end_station_id, 
    start_lat, start_lng, end_lat, end_lng, member_casual, 
    TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length,
    day_of_week,
    CASE EXTRACT(MONTH FROM started_at)
      WHEN 1 THEN 'January'
      WHEN 2 THEN 'February'
      WHEN 3 THEN 'March'
      WHEN 4 THEN 'April'
      WHEN 5 THEN 'May'
      WHEN 6 THEN 'June'
      WHEN 7 THEN 'July'
      WHEN 8 THEN 'August'
      WHEN 9 THEN 'September'
      WHEN 10 THEN 'October'
      WHEN 11 THEN 'November'
      WHEN 12 THEN 'December'
    END AS month
  FROM `zippy-venture-409222.Cyclistic_Bike_Share.Bike_Share_Data_2023`
);


-- Create a new table named `Bike_Share_Data_2023_V2` in the `Cyclistic_Bike_Share` dataset, if it doesn't exist, with filtered and sorted data from the `Bike_Share_Data_2023_V1` table. 
-- The filtering conditions include removing rows where any of the station names or coordinates are NULL, and where the `ride_length` is less than or equal to 1 minute. 
-- The resulting data is ordered by the `started_at` timestamp.

CREATE TABLE IF NOT EXISTS `zippy-venture-409222.Cyclistic_Bike_Share.Bike_Share_Data_2023_V2` AS (
  SELECT 
    ride_id, rideable_type, started_at, ended_at, ride_length,
    start_station_name, end_station_name, start_lat, start_lng, 
    end_lat, end_lng, member_casual, day_of_week, month
  FROM 
    `zippy-venture-409222.Cyclistic_Bike_Share.Bike_Share_Data_2023_V1`
  WHERE
    start_station_name IS NOT NULL AND
    end_station_name IS NOT NULL AND
    start_lat IS NOT NULL AND
    start_lng IS NOT NULL AND
    end_lat IS NOT NULL AND
    end_lng IS NOT NULL AND
    ride_length > 1
  ORDER BY 
    started_at
);


-- Calculate the count of NULL values for each column in the `Bike_Share_Data_2023_V2` table within the `Cyclistic_Bike_Share` dataset by 
-- subtracting the count of non-NULL values from the total count of rows for each column.

SELECT COUNT(*) - COUNT(ride_id) AS ride_id,
  COUNT(*) - COUNT(rideable_type) AS rideable_type,
  COUNT(*) - COUNT(started_at) AS started_at,
  COUNT(*) - COUNT(ended_at) AS ended_at,
  COUNT(*) - COUNT(start_station_name) AS start_station_name,
  COUNT(*) - COUNT(end_station_name) AS end_station_name,
  COUNT(*) - COUNT(start_lat) AS start_lat,
  COUNT(*) - COUNT(start_lng) AS start_lng,
  COUNT(*) - COUNT(end_lat) AS end_lat,
  COUNT(*) - COUNT(end_lng) AS end_lng,
  COUNT(*) - COUNT(member_casual) AS member_casual,
  COUNT(*) - COUNT(ride_length) AS ride_length,
  COUNT(*) - COUNT(day_of_week) AS day_of_week,
  COUNT(*) - COUNT(month) AS month
FROM `zippy-venture-409222.Cyclistic_Bike_Share.Bike_Share_Data_2023_V2`;


-- Calculate the count of duplicate rows in the `Bike_Share_Data_2023_V2` table within the `Cyclistic_Bike_Share` dataset by 
-- subtracting the count of distinct `ride_id` values from the total count of `ride_id` values.

SELECT COUNT(ride_id) - COUNT(DISTINCT ride_id) AS duplicate_rows
FROM `zippy-venture-409222.Cyclistic_Bike_Share.Bike_Share_Data_2023_V2`;


-- Create a new table named `Bike_Share_Data_2023_V3` in the `Cyclistic_Bike_Share` dataset, if it doesn't exist, by deduplicating data from the `Bike_Share_Data_2023_V2` table. 
-- The deduplication is done based on the `ride_id` column, keeping only the earliest entry for each `ride_id`. The resulting data is ordered by the `started_at` timestamp.

CREATE TABLE IF NOT EXISTS `zippy-venture-409222.Cyclistic_Bike_Share.Bike_Share_Data_2023_V3` AS (
  WITH DeduplicatedData AS (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY started_at) AS row_num
    FROM `zippy-venture-409222.Cyclistic_Bike_Share.Bike_Share_Data_2023_V2`
  )
  SELECT
    ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    end_station_name,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual,
    ride_length,
    day_of_week,
    month
  FROM DeduplicatedData
  WHERE row_num = 1
  ORDER BY started_at
);


-- Calculate the count of duplicate rows in the `Bike_Share_Data_2023_V3` table within the `Cyclistic_Bike_Share` dataset by 
-- subtracting the count of distinct `ride_id` values from the total count of `ride_id` values.

SELECT COUNT(ride_id) - COUNT(DISTINCT ride_id) AS duplicate_rows
FROM `zippy-venture-409222.Cyclistic_Bike_Share.Bike_Share_Data_2023_V3`;


