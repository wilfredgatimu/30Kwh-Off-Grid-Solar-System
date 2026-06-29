-- Data Engineering: 9 off-grid Solar plants
Note: Real plant IDs redacted for confidentiality




CREATE TABLE  solar_daily_system AS
SELECT 
    'Plant_A' AS plant_id,
    `Time` AS date,
    `Daily Production% % kWh% %` AS daily_production_kwh,
    `Daily Consumption% % kWh% %` AS daily_consumption_kwh,
    `Daily Grid Feed-in% % kWh% %` AS daily_grid_feed_in_kwh,
    `Daily Purchased% % kWh% %` AS daily_purchased_kwh,
    `Daily Charge% % kWh% %` AS daily_charge_kwh,
    `Daily Discharge% % kWh% %` AS daily_discharge_kwh
FROM `plantsdetails-history (2)`

UNION ALL
SELECT 'Plant_b',`Time`, `Daily Production% % kWh% %`, `Daily Consumption% % kWh% %`, `Daily Grid Feed-in% % kWh% %`, `Daily Purchased% % kWh% %`, `Daily Charge% % kWh% %`, `Daily Discharge% % kWh% %` FROM `plantsdetails-history (3)`

UNION ALL
SELECT 'Plant_c',`Time`, `Daily Production% % kWh% %`, `Daily Consumption% % kWh% %`, `Daily Grid Feed-in% % kWh% %`, `Daily Purchased% % kWh% %`, `Daily Charge% % kWh% %`, `Daily Discharge% % kWh% %` FROM `plantsdetails-history (4)`

UNION ALL
SELECT 'Plant_d', `Time`, `Daily Production% % kWh% %`, `Daily Consumption% % kWh% %`, `Daily Grid Feed-in% % kWh% %`, `Daily Purchased% % kWh% %`, `Daily Charge% % kWh% %`, `Daily Discharge% % kWh% %` FROM `plantsdetails-history (5)`

UNION ALL
SELECT 'Plant_e',`Time`, `Daily Production% % kWh% %`, `Daily Consumption% % kWh% %`, `Daily Grid Feed-in% % kWh% %`, `Daily Purchased% % kWh% %`, `Daily Charge% % kWh% %`, `Daily Discharge% % kWh% %` FROM `plantsdetails-history (6)`

UNION ALL
SELECT 'Plant_f',`Time`, `Daily Production% % kWh% %`, `Daily Consumption% % kWh% %`, `Daily Grid Feed-in% % kWh% %`, `Daily Purchased% % kWh% %`, `Daily Charge% % kWh% %`, `Daily Discharge% % kWh% %` FROM `plantsdetails-history (7)`

UNION ALL
SELECT 'Plant_g',`Time`,`Daily Production% % kWh% %`, `Daily Consumption% % kWh% %`, `Daily Grid Feed-in% % kWh% %`, `Daily Purchased% % kWh% %`, `Daily Charge% % kWh% %`, `Daily Discharge% % kWh% %` FROM `plantsdetails-history (8)`

UNION ALL
SELECT 'Plant_h',`Time`, `Daily Production% % kWh% %`, `Daily Consumption% % kWh% %`, `Daily Grid Feed-in% % kWh% %`, `Daily Purchased% % kWh% %`, `Daily Charge% % kWh% %`, `Daily Discharge% % kWh% %` FROM `plantsdetails-history (9)`

UNION ALL
SELECT 'Plant_i',`Time`, `Daily Production% % kWh% %`, `Daily Consumption% % kWh% %`, `Daily Grid Feed-in% % kWh% %`, `Daily Purchased% % kWh% %`, `Daily Charge% % kWh% %`, `Daily Discharge% % kWh% %` FROM `plantsdetails-history (10)`

UNION ALL
SELECT 'Plant_j',`Time`, `Daily Production% % kWh% %`, `Daily Consumption% % kWh% %`, `Daily Grid Feed-in% % kWh% %`, `Daily Purchased% % kWh% %`, `Daily Charge% % kWh% %`, `Daily Discharge% % kWh% %` FROM `plantsdetails-history (11)`
;




-- 1. The portfoli totals with all the plants combined
Select 
	Count(distinct plant_id) As total_plants,
    Count(*) As total_days,
    Min(date) As start_date,
    Max(date) As end_date,
	round(Sum(daily_production_kwh), 1) As total_production_kwh,
    round(sum(daily_consumption_kwh), 1) As total_consumption_kwh,
    round(sum(daily_grid_feed_in_kwh), 1) As total_grid_feed_in_kwh,
    round(sum(daily_purchased_kwh), 1) As total_daily_purchased_kwh,
   round(sum(daily_charge_kwh), 1)As total_battery_charge_kwh,
   round(sum(daily_discharge_kwh), 1) As total_battery_discharge_kwh
From  solar_daily_system
;

-- 2. how the each plant perfomed

SELECT 
    plant_id,
    COUNT(*) AS days,
    ROUND(SUM(daily_production_kwh), 1) AS total_prod_kwh,
    ROUND(AVG(daily_production_kwh), 2) AS avg_daily_prod_kwh,
    ROUND(SUM(daily_consumption_kwh), 1) AS total_cons_kwh,
    ROUND( (SUM(daily_consumption_kwh) - SUM(daily_purchased_kwh)) / NULLIF(SUM(daily_consumption_kwh),0) * 100, 1) AS self_sufficiency_pct,
    ROUND( (SUM(daily_production_kwh) - SUM(daily_grid_feed_in_kwh)) / NULLIF(SUM(daily_production_kwh),0) * 100, 1) AS self_consumption_pct,
    ROUND(SUM(daily_purchased_kwh) - SUM(daily_grid_feed_in_kwh), 1) AS net_grid_kwh
FROM solar_daily_system
GROUP BY plant_id
ORDER BY total_prod_kwh DESC;
-- 3. How the perfomance has been over time
SELECT 
    date,
    COUNT(*) AS plants_reporting,
    ROUND(SUM(daily_production_kwh), 1) AS total_production,
    ROUND(SUM(daily_consumption_kwh), 1) AS total_consumption,
    ROUND(AVG(daily_production_kwh), 2) AS avg_production_per_plant,
    ROUND(SUM(daily_grid_feed_in_kwh), 1) AS total_export,
    ROUND(SUM(daily_purchased_kwh), 1) AS total_import
FROM solar_daily_system
GROUP BY date
ORDER BY date;


SELECT 
    DATE_FORMAT(date, '%Y-%m') AS month,
    COUNT(DISTINCT plant_id) AS plants,
    COUNT(*) AS total_days,
    ROUND(SUM(daily_production_kwh), 1) AS total_production_kwh,
    ROUND(SUM(daily_consumption_kwh), 1) AS total_consumption_kwh,
    ROUND(SUM(daily_production_kwh) - SUM(daily_consumption_kwh), 1) AS net_surplus_kwh,
    ROUND(SUM(daily_grid_feed_in_kwh), 1) AS exported_kwh,
    ROUND(SUM(daily_purchased_kwh), 1) AS imported_kwh
FROM solar_daily_system
GROUP BY DATE_FORMAT(date, '%Y-%m')
ORDER BY month;


-- 3. The monthly production vs Consumption

Select 
	plant_id,
    Date_format(date, '%y-%m-01') As month_start,
    ROUND(SUM(daily_production_kwh), 1) AS production,
    ROUND(SUM(daily_consumption_kwh), 1) AS consumption
From solar_daily_system
Group by plant_id, Date_format(date, '%y-%m-01') 
order by month_start, plant_id
;



-- 4. Best solar production days

Select
	plant_id,
     Date,
    daily_production_kwh,
    daily_consumption_kwh,
    ROUND(daily_production_kwh - daily_consumption_kwh, 2) As daily_surplus
From solar_daily_system
Order by daily_production_kwh  Desc
limit 10
;

-- plant_3 led consecutively with a daily production of 43.7 Kwh and 38.2 Kwh 

-- 5. Highest consumption days

Select
	plant_id,
     Date,
    daily_production_kwh,
    daily_consumption_kwh,
    ROUND(daily_production_kwh - daily_consumption_kwh, 2) As daily_surplus
From solar_daily_system
Order by  daily_consumption_kwh Desc
limit 10
;

-- Plant_11 led in consumption with 48.1 kwh followed by plant 7


-- 6. Surplus Vs Deficit days



Select 
	plant_id,
    count(*) As total_days,
    Round(SUM(daily_production_kwh), 1) AS total_production_kwh,
    Round(SUM(daily_consumption_kwh), 1) AS total_consumption_kwh
From solar_daily_system
Group by plant_id
;


-- 7. Battery efficiency by month

Select 
	 Date_format(date, '%y-%m-01') As month_start,
     Sum(daily_charge_kwh) As Battery_charge_kwh,
     Sum(daily_discharge_kwh) As Battery_Discharge_kwh,
     Round(Sum(daily_discharge_kwh) / Nullif(sum(daily_charge_kwh), 1) * 100, 1) As battery_efficiency
From solar_daily_system
group by  Date_format(date, '%y-%m-01') 
order by  month_start
; 


-- 8. Consistency $ Volatility analysis 

-- How stable is your production and consumption 

SELECT 
    ROUND(AVG(daily_production_kwh), 2) AS avg_production,
    ROUND(STDDEV(daily_production_kwh), 2) AS stdev_production,
    ROUND(AVG(daily_consumption_kwh), 2) AS avg_consumption,
    ROUND(STDDEV(daily_consumption_kwh), 2) AS stdev_consumption,
    ROUND(STDDEV(daily_production_kwh) / NULLIF(AVG(daily_production_kwh),0) * 100, 1) AS prod_cv_pct,
    ROUND(STDDEV(daily_consumption_kwh) / NULLIF(AVG(daily_consumption_kwh),0) * 100, 1) AS cons_cv_pct
FROM solar_daily_system;

-- 9. Energy Deficit Risks

SELECT 
    plant_id,
    date,
    daily_production_kwh,
    daily_consumption_kwh,
    daily_charge_kwh,
    daily_discharge_kwh,
    ROUND(daily_production_kwh - daily_consumption_kwh, 2) AS daily_energy_balance,
    ROUND(daily_production_kwh + daily_discharge_kwh - daily_consumption_kwh, 2) AS net_after_battery,
    CASE 
        WHEN daily_production_kwh + daily_discharge_kwh < daily_consumption_kwh THEN 'DEFICIT RISK'
        WHEN daily_production_kwh < daily_consumption_kwh THEN 'Battery Used'
        ELSE 'Surplus'
    END AS risk_flag
FROM solar_daily_system
WHERE daily_production_kwh + daily_discharge_kwh < daily_consumption_kwh
   OR daily_production_kwh < daily_consumption_kwh
ORDER BY net_after_battery ASC, date;

-- it helps in sizing the system
-- and it shows how often your system is under-producing

-- 10. Deficit risk summary per plant 

SELECT 
    plant_id,
    COUNT(*) AS total_days,
    SUM(CASE WHEN daily_production_kwh < daily_consumption_kwh THEN 1 ELSE 0 END) AS deficit_days,
    ROUND(SUM(CASE WHEN daily_production_kwh < daily_consumption_kwh THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) AS deficit_day_pct,
    ROUND(AVG(CASE WHEN daily_production_kwh < daily_consumption_kwh 
              THEN daily_consumption_kwh - daily_production_kwh ELSE 0 END), 2) AS avg_deficit_kwh,
    ROUND(MAX(daily_consumption_kwh - daily_production_kwh), 2) AS worst_deficit_kwh,
    ROUND(MIN(daily_production_kwh), 2) AS worst_prod_day
FROM solar_daily_system
GROUP BY plant_id
ORDER BY deficit_day_pct DESC;

-- 11. Days of autonomy, how many bad days can you survive based on your system

SELECT 
    plant_id,
    ROUND(AVG(daily_consumption_kwh), 2) AS avg_daily_consumption,
    ROUND(28.0 / NULLIF(AVG(daily_consumption_kwh),0), 1) AS days_of_autonomy,
    ROUND(MIN(daily_production_kwh), 2) AS worst_prod_day,
    ROUND(28.0 / NULLIF(AVG(daily_consumption_kwh) - MIN(daily_production_kwh), 0), 1) AS worst_case_days
FROM solar_daily_system
GROUP BY plant_id
ORDER BY days_of_autonomy ASC;

-- 12. Battery stress analysis


Select *
From Thirty_Kwh_system_Deyeinverter;
Select 
	Date,
    daily_charge_kwh,
    daily_discharge_kwh,
    abs(daily_charge_kwh - daily_discharge_kwh) As imbalance_kwh
From solar_daily_system
Order by imbalance_kwh Desc
;

-- High imbalance
-- Could indicate:
   -- Overcharging
   -- unused stored energy
   
-- 13. Battery cycle estimation (daily + monthly)

-- Full cycle per day/ plant 

Select 
	plant_id,
    date,
    daily_charge_kwh,
    daily_discharge_kwh,
    Round(daily_discharge_kwh / 30.0, 2) As discharge_cycles,
    Round((daily_charge_kwh + daily_discharge_kwh) /2/ 30.0, 2) As full_cycle_equivalent
From solar_daily_system
order by date Desc, full_cycle_equivalent Desc
;

-- Total cycles per plant - cycles used on a monthly basis

Select 
	plant_id,
    Count(*) As days_online,
    Round(sum(daily_discharge_kwh), 1) As total_discharge_kwh,
    Round(sum(daily_discharge_kwh) / 30.0, 1) As total_cycles_used,
    Round(sum(daily_discharge_kwh) / 30.0 / count(*), 2) As avg_cycles_per_day,
    Round(6000 - Sum(daily_discharge_kwh) / 30.0, 0) As cycles_remaining,
    Round((6000 - Sum(daily_discharge_kwh) / 30.0) / Nullif(sum(daily_discharge_kwh) / 30.0 / count(*), 0) / 365, 1) As years_left_estimate
From solar_daily_system
Group by plant_id
Order by avg_cycles_per_day
;


-- Monthly cycle rate

SELECT 
    plant_id,
    DATE_FORMAT(date, '%Y-%m') AS month,
    COUNT(*) AS days,
    ROUND(SUM(daily_discharge_kwh) / 30.0, 1) AS cycles_this_month,
    ROUND(SUM(daily_discharge_kwh) / 30.0 / COUNT(*), 2) AS avg_cycles_per_day,
    ROUND(AVG(daily_discharge_kwh / NULLIF(daily_charge_kwh,0) * 100), 1) AS avg_batt_efficiency_pct
FROM solar_daily_system
GROUP BY plant_id, DATE_FORMAT(date, '%Y-%m')
ORDER BY month, cycles_this_month DESC
;

-- Depth of discharge estimate per day

SELECT 
    plant_id,
    date,
    daily_discharge_kwh,
    ROUND(daily_discharge_kwh / 30.0 * 100, 1) AS est_DoD_pct,
    CASE 
        WHEN daily_discharge_kwh / 30.0 > 0.8 THEN 'Deep >80% DoD'
        WHEN daily_discharge_kwh / 30.0 > 0.5 THEN 'Medium 50-80% DoD'
        ELSE 'Shallow <50% DoD'
    END AS cycle_depth
FROM solar_daily_system
WHERE daily_discharge_kwh > 0
ORDER BY est_DoD_pct DESC;



-- the above analysis helps the technician analyze and estimate the battery wear
-- if the battery avg_cycles is ranging between 0.4-0.7 the battery is in good condition and can last to 20+ years

-- 14. How the solar has been utilized 

Select 
	date,
    daily_production_kwh,
    daily_consumption_kwh,
    (daily_consumption_kwh / Nullif(daily_production_kwh,0)) As solar_utilization_ratio
From solar_daily_system
Order by solar_utilization_ratio Desc
;

-- consumption exceeds production

-- 15. Underutilized solar days

Select 
	date,
    daily_production_kwh,
    daily_consumption_kwh,
    Round(daily_production_kwh - daily_consumption_kwh, 1) As unused_energy
From solar_daily_system
Where daily_production_kwh > daily_consumption_kwh
Order by unused_energy Desc
;

-- it helps in identyfying the wasted solar energy and provides an opportunity to know whether there is a need for expansion

-- 16. Days of the week analysis
Select 
	dayname(date) As day_name,
   Round(Avg(daily_production_kwh), 2) As avg_production,
    Round(Avg(daily_consumption_kwh), 2) As avg_consumption,
    Round(stddev(daily_production_kwh), 2) As stddev_production,
    Count(*) As day_count
From solar_daily_system
Group by dayname(date), dayofweek(date)
Order by dayofweek(date)
;

-- it detects the behavioral patterns for the weekends vs the weekdays
-- It helps in planning

-- 17. Load factor

Select 
	Avg(daily_consumption_kwh) / Max(daily_consumption_kwh) As load_factor
From 
;
-- close to 1 means there is consistent usage

SELECT
    plant_id,
    ROUND(
        SUM(daily_production_kwh) /
        NULLIF(SUM(daily_consumption_kwh),0) * 100,2
    ) AS production_coverage_pct
FROM solar_daily_system
GROUP BY plant_id
ORDER BY production_coverage_pct DESC
;

-- Which plant covers the highest percentage of its energy demand through solar production

SELECT
    plant_id,
    ROUND(
        SUM(daily_production_kwh) * 35,
        2
    ) AS estimated_savings
FROM solar_daily_system
GROUP BY plant_id
ORDER BY estimated_savings DESC
;

-- It shows the amount of money saved by each plant through generating solar eneergy

SELECT
    plant_id,
    ROUND(
        SUM(daily_production_kwh) * 0.430,
        0
    ) AS co2_saved_kg
FROM solar_daily_system
GROUP BY plant_id
ORDER BY co2_saved_kg DESC
;

-- This shows the environmental impact of each plant 

SELECT
    plant_id,
    ROUND(
        SUM(daily_discharge_kwh) /
        NULLIF(SUM(daily_consumption_kwh),0) * 100,
        2
    ) AS battery_dependency_pct
FROM solar_daily_system
GROUP BY plant_id
ORDER BY battery_dependency_pct DESC
;

-- Shows which site mainly depends on storage

SELECT
    plant_id,
    ROUND(
        SUM(
            CASE
                WHEN daily_production_kwh >= daily_consumption_kwh
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS reliability_pct
FROM solar_daily_system
GROUP BY plant_id
ORDER BY reliability_pct DESC
;


