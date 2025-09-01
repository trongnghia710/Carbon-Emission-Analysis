select *, Count(*) as Duplicates
from product_emissions pe 
group by id
having count(id) > 1
limit 5;

WITH handle_duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS rn
    FROM product_emissions pe
)
SELECT *
FROM handle_duplicates 
 
SELECT 
 	pe.product_name,
 	ROUND(AVG(carbon_footprint_pcf),2) as "carbon emissions"
FROM product_emissions pe 
GROUP BY (pe.product_name)
Order By ROUND(AVG(carbon_footprint_pcf),2) desc
LIMIT 10;

SELECT 
     ig.industry_group
FROM product_emissions pe
JOIN industry_groups ig 
    ON pe.industry_group_id = ig.id
GROUP BY ig.industry_group;

SELECT 
    ig.industry_group,
    ROUND(SUM(pe.carbon_footprint_pcf), 2) AS total_carbon_emissions
FROM 
    product_emissions pe
JOIN 
    industry_groups ig 
    ON pe.industry_group_id = ig.id
GROUP BY 
    ig.industry_group
ORDER BY 
    total_carbon_emissions DESC
LIMIT 5;

SELECT 
    c.company_name,
    ROUND(SUM(pe.carbon_footprint_pcf),2) AS total_carbon_emissions
FROM 
    product_emissions pe
JOIN 
    companies c 
    ON pe.company_id  = c.id
GROUP BY 
    c.company_name
ORDER BY 
    total_carbon_emissions DESC
LIMIT 5;

SELECT 
    c.country_name,
    ROUND(SUM(pe.carbon_footprint_pcf),2) AS total_carbon_emissions
FROM 
    product_emissions pe
JOIN 
    countries  c 
    ON pe.country_id = c.id
GROUP BY 
    c.country_name
ORDER BY 
    total_carbon_emissions DESC
LIMIT 5;

SELECT 
    pe.year,
    ROUND(AVG(pe.carbon_footprint_pcf),2) AS average_carbon_emissions
FROM 
    product_emissions pe
GROUP BY 
    pe.year
ORDER BY 
    pe.year;

SELECT 
	pe.year,
	ig.industry_group,
	ROUND(SUM(pe.carbon_footprint_pcf),2)  as Total_carbon_emissions
FROM product_emissions pe 
JOIN industry_groups ig 
	ON pe.industry_group_id = ig.id 
GROUP BY
	pe.year,
	ig.industry_group
ORDER BY
	ig.industry_group,
	pe.YEAR,
	Total_carbon_emissions;