SELECT * FROM car_sales.cars;

ALTER TABLE cars
MODIFY COLUMN Sellingprice INT;

SET SQL_SAFE_UPDATES = 0;

UPDATE cars
SET Sellingprice = REPLACE(
    REPLACE(Sellingprice, '$', ''),
    ',', ''
);

ALTER TABLE cars
MODIFY COLUMN Sellingprice DECIMAL(12,2);

Select * from cars;

#1. Sales in Each State ?
SELECT state, COUNT(*)
FROM cars
GROUP BY state;

#2. Make and Model ?
SELECT Company, model, count(*)
FROM cars
GROUP BY Company, model
ORDER BY COUNT(*) DESC;

#3. Avg Selling in States ?
SELECT state, AVG(Sellingprice) AS Avg_Selling_Prices
FROM cars
GROUP BY State
ORDER BY Avg_Selling_Prices DESC;

#_____
ALTER TABLE cars
ADD COLUMN Sale_Year INT,
ADD COLUMN Sale_Month_Name VARCHAR(10),
ADD COLUMN Sale_Day INT,
ADD COLUMN Sale_Month INT;

#4. Average Price per Month ?
SELECT Saledate,
MID(Saledate, 12,4) AS Sale_Year,
MID(Saledate, 5,3) AS Sale_Month_Name,
MID(Saledate, 9,2) AS Sale_Day,
CASE MID(Saledate, 5,3)
	WHEN 'Jan' THEN 1
    WHEN 'Feb' THEN 2
    WHEN 'Mar' THEN 3
    WHEN 'Apr' THEN 4
    WHEN 'May' THEN 5
    WHEN 'Jun' THEN 6
    WHEN 'Jul' THEN 7
    WHEN 'Aug' THEN 8
    WHEN 'Sep' THEN 9
    WHEN 'Oct' THEN 10
    WHEN 'Nov' THEN 11
    WHEN 'Dec' THEN 12
    ELSE'None'
END AS Sale_Month
From cars
Limit 1000;

UPDATE cars
SET
    Sale_Year = CAST(MID(Saledate, 12, 4) AS UNSIGNED),
    Sale_Month_Name = MID(Saledate, 5, 3),
    Sale_Day = CAST(MID(Saledate, 9, 2) AS UNSIGNED),
    Sale_Month = CASE MID(Saledate, 5, 3)
        WHEN 'Jan' THEN 1
        WHEN 'Feb' THEN 2
        WHEN 'Mar' THEN 3
        WHEN 'Apr' THEN 4
        WHEN 'May' THEN 5
        WHEN 'Jun' THEN 6
        WHEN 'Jul' THEN 7
        WHEN 'Aug' THEN 8
        WHEN 'Sep' THEN 9
        WHEN 'Oct' THEN 10
        WHEN 'Nov' THEN 11
        WHEN 'Dec' THEN 12
    END;
    
SELECT * FROM cars;

SELECT 
sale_year,
sale_month_name,
Avg(Sellingprice) AS Avg_Selling_Prices
FROM Cars
GROUP BY Sale_year, Sale_Month_Name
ORDER BY Sale_year, Sale_Month_Name;
 
 #5. Number of Sales by Each Month ?
 SELECT sale_month_name, COUNT(*)
 FROM cars
 GROUP BY sale_month_Name
 ORDER BY Sale_month_Name ASC;
 
ALTER TABLE cars
RENAME COLUMN `Body type` TO body_type;

DESCRIBE cars;

#6.Top models for Each Body Type ?
SELECT
Company,
model,
body_type,
COUNT(*) AS num_sales,
RANK()OVER(PARTITION BY body_type ORDER BY COUNT(*) DESC) AS Body_Rank
FROM cars
GROUP BY Company,model,body_type
ORDER BY Body_type DESC, COUNT(*) DESC;

#7. Sales Higher than Model Average ?
SELECT
Company,
model,
vin,
sale_year,
sale_month,
sale_day,
avg_model
	FROM(
    SELECT
    company,
    model,
    vin,
    sale_year,
    sale_month,
    sale_day,
    sellingprice,
    Avg(sellingprice)OVER(PARTITION BY company, model) AS Avg_Model
    FROM cars
    )s
    WHERE sellingprice > avg_model
    ORDER BY sellingprice/avg_model desc;
    
ALTER TABLE cars
RENAME COLUMN `Condition` TO car_condition;
    
select * from cars;
 
#8. Condition and Sales Price ?
SELECT
CASE
	WHEN car_condition between 0 AND 9 THEN '0 to 9'
    WHEN car_condition between 10 AND 19 THEN '10 to 19'
    WHEN car_condition between 20 AND 29 THEN '20 to 29'
    WHEN car_condition between 30 AND 39 THEN '30 to 39'
    WHEN car_condition between 40 AND 49 THEN '40 to 49'
END AS Car_condition_bucket,
COUNT(*) AS num_sales,
AVG(sellingprice) AS avg_selling_price
FROM cars
GROUP BY Car_condition_bucket
ORDER BY Car_condition_bucket;

#9.Odometer and Sales Price ?
 SELECT
 CASE
	WHEN odometer < 100000 THEN '0-99,999'
    WHEN odometer < 200000 THEN '100,000-199,999'
    WHEN odometer < 300000 THEN '200,000-299,999'
    WHEN odometer < 400000 THEN '300,000-399,999'
    WHEN odometer < 500000 THEN '400,000-499,999'
    WHEN odometer < 600000 THEN '500,000-599,999'
    WHEN odometer < 700000 THEN '600,000-699,999'
    WHEN odometer < 800000 THEN '700,000-799,999'
    WHEN odometer < 900000 THEN '800,000-899,999'
    WHEN odometer < 1000000 THEN '900,000-299,999'
    END AS odometer,
 COUNT(*) AS num_sales,
 AVG(sellingprice) AS avg_selling_price
 FROM cars
 GROUP BY Odometer
 ORDER BY Odometer ASC;
 
 #10. Brand Details ?
 SELECT
 company,
 COUNT(DISTINCT model) AS num_models,
 COUNT(*) AS num_sales,
 MIN(sellingprice) AS min_price,
 MAX(sellingprice) AS avg_price
 FROM cars
 GROUP BY company
 ORDER BY avg_price DESC;
 
 