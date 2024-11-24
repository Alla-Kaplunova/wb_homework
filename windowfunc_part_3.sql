CREATE TABLE query (
    searchid SERIAL PRIMARY KEY,
    year INT,
    month INT,
    day INT,
    userid INT,
    ts BIGINT,
    devicetype VARCHAR(50),
    deviceid VARCHAR(50),
    query VARCHAR(255)
);


INSERT INTO query (year, month, day, userid, ts, devicetype, deviceid, query)
VALUES
(2024, 11, 24, 1, 1700820000, 'android', 'device_1', 'к'),
(2024, 11, 24, 1, 1700820100, 'android', 'device_1', 'ку'),
(2024, 11, 24, 1, 1700820200, 'android', 'device_1', 'куп'),
(2024, 11, 24, 1, 1700824000, 'android', 'device_1', 'купить'),
(2024, 11, 24, 2, 1700820000, 'ios', 'device_2', 'к'),
(2024, 11, 24, 2, 1700821000, 'ios', 'device_2', 'кур'),
(2024, 11, 24, 2, 1700821100, 'ios', 'device_2', 'куртка');


WITH query_with_next AS (
    SELECT
        q1.*,
        LEAD(q1.query) OVER (PARTITION BY q1.userid, q1.deviceid ORDER BY q1.ts) AS next_query,
        LEAD(q1.ts) OVER (PARTITION BY q1.userid, q1.deviceid ORDER BY q1.ts) AS next_ts
    FROM query q1
),
is_final_calculation AS (
    SELECT
        *,
        CASE
            WHEN next_query IS NULL THEN 1
            WHEN (next_ts - ts) > 180 THEN 1
            WHEN (next_ts - ts) > 60 AND LENGTH(next_query) < LENGTH(query) THEN 2
            ELSE 0
        END AS is_final
    FROM query_with_next
)
SELECT
    year,
    month,
    day,
    userid,
    ts,
    devicetype,
    deviceid,
    query,
    next_query,
    is_final
FROM
    is_final_calculation
WHERE
    devicetype = 'android' 
    AND is_final IN (1, 2) 
    AND year = 2024 AND month = 11 AND day = 24;
