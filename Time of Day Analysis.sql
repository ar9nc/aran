-- REACH
DROP TABLE IF EXISTS dataforce_sandbox.ac_time_of_day_reach;
CREATE TABLE dataforce_sandbox.ac_time_of_day_reach AS
SELECT
    COUNT(DISTINCT aadse.audience_id) as total_users,
    aadse.date_of_event as day,
    TO_CHAR(aadse.date_of_event, 'Day') as day_of_week,
    EXTRACT(HOUR FROM aadse.event_datetime_min) as hour,
    left(wfc.frequency_band,1) AS frequency_band,
    aadse.page_name
FROM audience.audience_activity_daily_summary_enriched aadse
LEFT JOIN sounds_insight.weekly_frequency_calculations wfc
    ON aadse.audience_id = wfc.bbc_hid3
    AND aadse.date_of_event BETWEEN wfc.date_of_segmentation AND wfc.date_of_segmentation + 6
WHERE
    date_of_event BETWEEN '2023-06-01' AND '2023-08-31'
    AND destination = 'PS_SOUNDS'
    AND page_name = 'sounds.my.page' OR page_name = 'sounds.page' OR page_name = 'sounds.podcasts.page' OR page_name = 'sounds.music.page'
GROUP BY 2, 3, 4, 5, 6
;

-- CONSUMPTION
DROP TABLE IF EXISTS dataforce_sandbox.ac_time_of_day_consumption;
CREATE TABLE dataforce_sandbox.ac_time_of_day_consumption AS
SELECT
    SUM(aadse.playback_time_total) as total_listening_time,
    aadse.date_of_event as day,
    TO_CHAR(aadse.date_of_event, 'Day') as day_of_week,
    EXTRACT(HOUR FROM aadse.event_datetime_min) as hour,
    left(wfc.frequency_band,1) AS frequency_band,
    aadse.page_name
FROM audience.audience_activity_daily_summary_enriched aadse
LEFT JOIN sounds_insight.weekly_frequency_calculations wfc
ON aadse.audience_id = wfc.bbc_hid3
AND aadse.date_of_event BETWEEN wfc.date_of_segmentation AND wfc.date_of_segmentation + 6
WHERE
    day BETWEEN '2023-06-01' AND '2023-08-31'
    AND destination = 'PS_SOUNDS'
    AND page_name = 'sounds.my.page' OR page_name = 'sounds.page' OR page_name = 'sounds.podcasts.page' OR page_name = 'sounds.music.page'
GROUP BY 2, 3, 4, 5, 6
;