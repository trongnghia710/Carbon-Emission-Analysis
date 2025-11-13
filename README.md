# Carbon Emission Analysis
## 1. Introduction
### 1.1. What is the project about?
![image](https://github.com/trongnghia710/Carbon-Emission-Analysis/blob/main/cover.jpg)
This report aims to analyze carbon emissions to examine the carbon footprint across various industries. We aim to identify sectors with the highest levels of emissions by analyzing them across countries and years, as well as to uncover trends.

### 1.2. Why should we conduct this project?
Carbon emissions play a crucial role in the environment, accounting for over 75% of global emissions and posing a significant environmental challenge. These emissions contribute to the accumulation of greenhouse gases in the atmosphere, leading to climate change, planetary warming, and involvement in various environmental disasters.

Through this analysis, we hope to gain an understanding of the environmental impact of different industries and contribute to making informed decisions in sustainable development.

## 2. Data Overview
### 2.1. Data Resource
Our dataset is compiled from publicly available data from nature.com and encompasses the product carbon footprints (PCF) for various companies. PCFs represent the greenhouse gas emissions associated with specific products, quantified in CO2 (carbon dioxide equivalent). 

### 2.2. Data Structure
![image](https://github.com/trongnghia710/Carbon-Emission-Analysis/blob/main/Database%20diagram.png)

### 2.3. Table Previews
```sql
select *
from product_emissions
limit 5
```
| id           | company_id | country_id | industry_group_id | year | product_name                                                    | weight_kg | carbon_footprint_pcf | upstream_percent_total_pcf | operations_percent_total_pcf | downstream_percent_total_pcf | 
| -----------: | ---------: | ---------: | ----------------: | ---: | --------------------------------------------------------------: | --------: | -------------------: | -------------------------: | ---------------------------: | ---------------------------: | 
| 10056-1-2014 | 82         | 28         | 2                 | 2014 | Frosted Flakes(R) Cereal                                        | 0.7485    | 2                    | 57.50                      | 30.00                        | 12.50                        | 
| 10056-1-2015 | 82         | 28         | 15                | 2015 | "Frosted Flakes, 23 oz, produced in Lancaster, PA (one carton)" | 0.7485    | 2                    | 57.50                      | 30.00                        | 12.50                        | 
| 10222-1-2013 | 83         | 28         | 8                 | 2013 | Office Chair                                                    | 20.68     | 73                   | 80.63                      | 17.36                        | 2.01                         | 
| 10261-1-2017 | 14         | 16         | 25                | 2017 | Multifunction Printers                                          | 110       | 1488                 | 30.65                      | 5.51                         | 63.84                        | 
| 10261-2-2017 | 14         | 16         | 25                | 2017 | Multifunction Printers                                          | 110       | 1818                 | 25.08                      | 4.51                         | 70.41                        | 

## 3. Pre-processing
### 3.1. Duplicate Check
```sql
SELECT *, COUNT(*) as Duplicates
from product_emissions pe 
GROUP BY id
HAVING COUNT(id) > 1
LIMIT 5;
```
|id|company_id|country_id|industry_group_id|year|product_name|weight_kg|carbon_footprint_pcf|upstream_percent_total_pcf|operations_percent_total_pcf|downstream_percent_total_pcf|Duplicates|
|--|----------|----------|-----------------|----|------------|---------|--------------------|--------------------------|----------------------------|----------------------------|----------|
|10056-1-2014|82|28|2|2014|Frosted Flakes(R) Cereal|0.7485|2|57.50|30.00|12.50|2|
|10056-1-2015|82|28|15|2015|"Frosted Flakes, 23 oz, produced in Lancaster, PA (one carton)"|0.7485|2|57.50|30.00|12.50|2|
|10222-1-2013|83|28|8|2013|Office Chair|20.68|73|80.63|17.36|2.01|2|
|10261-1-2017|14|16|25|2017|Multifunction Printers|110.0|1488|30.65|5.51|63.84|2|
|10261-2-2017|14|16|25|2017|Multifunction Printers|110.0|1818|25.08|4.51|70.41|2|

## 4. Data Analysis
### 4.1. Which products contribute the most to carbon emissions?
```sql
SELECT 
 	pe.product_name,
 	ROUND(AVG(carbon_footprint_pcf),2) as "carbon emissions"
FROM product_emissions pe 
GROUP BY (pe.product_name)
ORDER BY ROUND(AVG(carbon_footprint_pcf),2) desc
LIMIT 10;
```

|product_name|carbon emissions|
|------------|----------------|
|Wind Turbine G128 5 Megawats|3718044.00|
|Wind Turbine G132 5 Megawats|3276187.00|
|Wind Turbine G114 2 Megawats|1532608.00|
|Wind Turbine G90 2 Megawats|1251625.00|
|Land Cruiser Prado. FJ Cruiser. Dyna trucks. Toyoace.IMV def unit.|191687.00|
|Retaining wall structure with a main wall (sheet pile): 136 tonnes of steel sheet piles and 4 tonnes of tierods per 100 meter wall|167000.00|
|TCDE|99075.00|
|Mercedes-Benz GLE (GLE 500 4MATIC)|91000.00|
|Mercedes-Benz S-Class (S 500)|85000.00|
|Mercedes-Benz SL (SL 350)|72000.00|

Wind turbines dominate the list, with their manufacturing and installation creating carbon footprints far higher than any other products. Automobiles and infrastructure projects also contribute significantly, but their emissions are an order of magnitude lower than turbines.
### 4.2. What are the industry groups of these products?
``` sql
SELECT 
     ig.industry_group
FROM product_emissions pe
JOIN industry_groups ig 
    ON pe.industry_group_id = ig.id
GROUP BY ig.industry_group;
```

|industry_group|
|--------------|
|"Consumer Durables, Household and Personal Products"|
|"Food, Beverage & Tobacco"|
|"Forest and Paper Products - Forestry, Timber, Pulp and Paper, Rubber"|
|"Mining - Iron, Aluminum, Other Metals"|
|"Pharmaceuticals, Biotechnology & Life Sciences"|
|"Textiles, Apparel, Footwear and Luxury Goods"|
|Automobiles & Components|
|Capital Goods|
|Chemicals|
|Commercial & Professional Services|
|Consumer Durables & Apparel|
|Containers & Packaging|
|Electrical Equipment and Machinery|
|Energy|
|Food & Beverage Processing|
|Food & Staples Retailing|
|Gas Utilities|
|Household & Personal Products|
|Materials|
|Media|
|Retailing|
|Semiconductors & Semiconductor Equipment|
|Semiconductors & Semiconductors Equipment|
|Software & Services|
|Technology Hardware & Equipment|
|Telecommunication Services|
|Tires|
|Tobacco|
|Trading Companies & Distributors and Commercial Services & Supplies|
|Utilities|
The products span a very wide range of industries, from heavy industrial sectors like Automobiles & Components, Electrical Equipment and Machinery, Energy, Mining, and Chemicals to consumer-oriented sectors such as Food & Beverage, Textiles, Apparel, Household & Personal Products, and Retailing.
### 4.3. What are the industries with the highest contribution to carbon emissions?
```sql
SELECT 
    ig.industry_group,
    ROUND(SUM(pe.carbon_footprint_pcf),2) AS total_carbon_emissions
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
```

|industry_group|total_carbon_emissions|
|--------------|----------------------|
|Electrical Equipment and Machinery|9801558.00|
|Automobiles & Components|2582264.00|
|Materials|577595.00|
|Technology Hardware & Equipment|363776.00|
|Capital Goods|258712.00|
Electrical Equipment & Machinery dominates (9.8M PCF), followed by Automobiles & Components (2.6M).
### 4.4. What are the companies with the highest contribution to carbon emissions?
```sql
SELECT 
    c.company_name,
    ROUND(SUM(pe.carbon_footprint_pcf),2) AS total_carbon_emissions
FROM 
    product_emissions pe
JOIN 
    companies c 
    ON pe.company_id = c.id
GROUP BY 
    c.company_name
ORDER BY 
    total_carbon_emissions DESC
LIMIT 5;
```
|company_name|total_carbon_emissions|
|------------|----------------------|
|"Gamesa Corporación Tecnológica, S.A."|9778464.00|
|Daimler AG|1594300.00|
|Volkswagen AG|655960.00|
|"Mitsubishi Gas Chemical Company, Inc."|212016.00|
|"Hino Motors, Ltd."|191687.00|

Gamesa Corporación Tecnológica, S.A. alone accounts for ~9.8M PCF, almost the entire Electrical Equipment & Machinery footprint (wind turbines).

### 4.5. What are the countries with the highest contribution to carbon emissions?
```sql
SELECT 
    c.country_name,
    SUM(pe.carbon_footprint_pcf) AS total_carbon_emissions
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
```

|country_name|total_carbon_emissions|
|------------|----------------------|
|Spain|9786130.00|
|Germany|2251225.00|
|Japan|653237.00|
|USA|518381.00|
|South Korea|186965.00|

Spain leads overwhelmingly (9.7M PCF), reflecting Gamesa’s dominance.Followed by Germany, Japan, USA, South Korea — all advanced industrial economies.
### 4.6. What is the trend of carbon footprints (PCFs) over the years?
```sql
SELECT 
    pe.year,
    AVG(pe.carbon_footprint_pcf) AS average_carbon_emissions
FROM 
    product_emissions pe
GROUP BY 
    pe.year
ORDER BY 
    pe.year;
```sql
|year|average_carbon_emissions|
|----|------------------------|
|2013|2399.32|
|2014|2457.58|
|2015|43188.90|
|2016|6891.52|
|2017|4050.85|

2013–2014: stable (~2.4K avg emissions).

2015: sharp spike (43K) due to large turbine entries.

2016–2017: emissions dropped, stabilizing at 4K–6.8K.

### 4.7. Which industry groups has demonstrated the most notable decrease in carbon footprints (PCFs) over time? 
```sql
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
```

|year|industry_group|Total_carbon_emissions|
|----|--------------|----------------------|
|2015|"Consumer Durables, Household and Personal Products"|931.00|
|2013|"Food, Beverage & Tobacco"|4995.00|
|2014|"Food, Beverage & Tobacco"|2685.00|
|2015|"Food, Beverage & Tobacco"|0.00|
|2016|"Food, Beverage & Tobacco"|100289.00|
|2017|"Food, Beverage & Tobacco"|3162.00|
|2015|"Forest and Paper Products - Forestry, Timber, Pulp and Paper, Rubber"|8909.00|
|2015|"Mining - Iron, Aluminum, Other Metals"|8181.00|
|2013|"Pharmaceuticals, Biotechnology & Life Sciences"|32271.00|
|2014|"Pharmaceuticals, Biotechnology & Life Sciences"|40215.00|
|2015|"Textiles, Apparel, Footwear and Luxury Goods"|387.00|
|2013|Automobiles & Components|130189.00|
|2014|Automobiles & Components|230015.00|
|2015|Automobiles & Components|817227.00|
|2016|Automobiles & Components|1404833.00|
|2013|Capital Goods|60190.00|
|2014|Capital Goods|93699.00|
|2015|Capital Goods|3505.00|
|2016|Capital Goods|6369.00|
|2017|Capital Goods|94949.00|
|2015|Chemicals|62369.00|
|2013|Commercial & Professional Services|1157.00|
|2014|Commercial & Professional Services|477.00|
|2016|Commercial & Professional Services|2890.00|
|2017|Commercial & Professional Services|741.00|
|2013|Consumer Durables & Apparel|2867.00|
|2014|Consumer Durables & Apparel|3280.00|
|2016|Consumer Durables & Apparel|1162.00|
|2015|Containers & Packaging|2988.00|
|2015|Electrical Equipment and Machinery|9801558.00|
|2013|Energy|750.00|
|2016|Energy|10024.00|
|2015|Food & Beverage Processing|141.00|
|2014|Food & Staples Retailing|773.00|
|2015|Food & Staples Retailing|706.00|
|2016|Food & Staples Retailing|2.00|
|2015|Gas Utilities|122.00|
|2013|Household & Personal Products|0.00|
|2013|Materials|200513.00|
|2014|Materials|75678.00|
|2016|Materials|88267.00|
|2017|Materials|213137.00|
|2013|Media|9645.00|
|2014|Media|9645.00|
|2015|Media|1919.00|
|2016|Media|1808.00|
|2014|Retailing|19.00|
|2015|Retailing|11.00|
|2014|Semiconductors & Semiconductor Equipment|50.00|
|2016|Semiconductors & Semiconductor Equipment|4.00|
|2015|Semiconductors & Semiconductors Equipment|3.00|
|2013|Software & Services|6.00|
|2014|Software & Services|146.00|
|2015|Software & Services|22856.00|
|2016|Software & Services|22846.00|
|2017|Software & Services|690.00|
|2013|Technology Hardware & Equipment|61100.00|
|2014|Technology Hardware & Equipment|167361.00|
|2015|Technology Hardware & Equipment|106157.00|
|2016|Technology Hardware & Equipment|1566.00|
|2017|Technology Hardware & Equipment|27592.00|
|2013|Telecommunication Services|52.00|
|2014|Telecommunication Services|183.00|
|2015|Telecommunication Services|183.00|
|2015|Tires|2022.00|
|2015|Tobacco|1.00|
|2015|Trading Companies & Distributors and Commercial Services & Supplies|239.00|
|2013|Utilities|122.00|
|2016|Utilities|122.00|

Technology Hardware & Equipment: fell dramatically (167K in 2014 → 1.5K in 2016 → 27K in 2017).

Software & Services: peaked at 22K in 2015, dropped to just 690 in 2017.

Capital Goods & Media also saw notable reductions after earlier peaks.
