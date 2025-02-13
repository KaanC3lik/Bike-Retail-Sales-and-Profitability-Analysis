-- Profit, revenue and change of profit per year
SELECT 
    Year,
    ROUND(SUM(`Total Profit`)) AS "Profit per Year",
    SUM(Revenue) AS "Revenue per Year",
    ROUND(
        ((SUM(`Total Profit`) - LAG(SUM(`Total Profit`)) OVER (ORDER BY Year)) 
        / LAG(SUM(`Total Profit`)) OVER (ORDER BY Year)) * 100, 2
    ) AS "Profit Change (%)",
    ROUND(
        ((SUM(Revenue) - LAG(SUM(Revenue)) OVER (ORDER BY Year)) 
        / LAG(SUM(Revenue)) OVER (ORDER BY Year)) * 100, 2
    ) AS "Revenue Change (%)"
FROM salesforcourse_quizz_table
GROUP BY Year
ORDER BY Year;

-- Profit, revenue and change of profit per month in 2016
WITH MonthlyData AS (
    SELECT 
        DATE_FORMAT(Date, '%Y-%m') AS `Year Month`,
        ROUND(SUM(`Total Profit`)) AS `Profit per Month`,
        SUM(Revenue) AS `Revenue per Month`,
        SUM(Quantity) AS `Sales per Month`
    FROM salesforcourse_quizz_table
    WHERE Year = 2016
    GROUP BY `Year Month`
)
SELECT 
    `Year Month`,
    `Profit per Month`,
    `Revenue per Month`,
    `Sales per Month`,
    ROUND((( `Profit per Month` - LAG(`Profit per Month`) OVER (ORDER BY `Year Month`)) 
        / LAG(`Profit per Month`) OVER (ORDER BY `Year Month`)) * 100, 2) AS `Profit Change (%)`,
    ROUND((( `Revenue per Month` - LAG(`Revenue per Month`) OVER (ORDER BY `Year Month`)) 
        / LAG(`Revenue per Month`) OVER (ORDER BY `Year Month`)) * 100, 2) AS `Revenue Change (%)`,
    ROUND((( `Sales per Month` - LAG(`Sales per Month`) OVER (ORDER BY `Year Month`)) 
        / LAG(`Sales per Month`) OVER (ORDER BY `Year Month`)) * 100, 2) AS `Sales Change (%)`
FROM MonthlyData
ORDER BY `Year Month`;

-- Profit, revenue and change of profit per month and Accessories in 2016
WITH MonthlyData AS (
    SELECT 
		`Product Category`,
        `Sub Category`,
        DATE_FORMAT(Date, '%Y-%m') AS `Year Month`,
        ROUND(SUM(`Total Profit`)) AS `Profit per Month`,
        SUM(Revenue) AS `Revenue per Month`,
        SUM(Quantity) AS `Sales per Month`
    FROM salesforcourse_quizz_table
    WHERE Year = 2016
    GROUP BY `Year Month`, `Product Category`,`Sub Category`
)
SELECT 
	`Product Category`,
    `Sub Category`,
    `Year Month`,
    `Profit per Month`,
    `Revenue per Month`,
    `Sales per Month`,
    ROUND((( `Profit per Month` - LAG(`Profit per Month`) OVER (ORDER BY `Year Month`)) 
        / LAG(`Profit per Month`) OVER (ORDER BY `Year Month`)) * 100, 2) AS `Profit Change (%)`,
    ROUND((( `Revenue per Month` - LAG(`Revenue per Month`) OVER (ORDER BY `Year Month`)) 
        / LAG(`Revenue per Month`) OVER (ORDER BY `Year Month`)) * 100, 2) AS `Revenue Change (%)`,
    ROUND((( `Sales per Month` - LAG(`Sales per Month`) OVER (ORDER BY `Year Month`)) 
        / LAG(`Sales per Month`) OVER (ORDER BY `Year Month`)) * 100, 2) AS `Sales Change (%)`
FROM MonthlyData
WHERE `Sub Category` = 'Helmets'
ORDER BY `Product Category`,`Year Month`;

-- Total Profit, Revenue and Quantity of Sales by country
WITH SumOfAllQuantityCTE AS (
SELECT SUM(`Quantity`) AS SumOfAllQuantity
FROM salesforcourse_quizz_table
),
SumOfTotalProfitCTE AS (
SELECT SUM(`Total Profit`) AS SumOfTotalProfit
FROM salesforcourse_quizz_table
),
SumOfRevenueCTE AS (
SELECT SUM(`Revenue`) AS SumOfRevenue
FROM salesforcourse_quizz_table
)
SELECT `Country`, SUM(`Total Profit`) AS "Sum of Total Profit", ROUND(SUM(`Total Profit`)/ supr.SumOfTotalProfit,2) AS "Percentage of Profit",
		SUM(`Revenue`) AS "Sum of Total Revenue", ROUND(SUM(`Revenue`)/ sure.SumOfRevenue,2) AS "Percentage of Revenue",
        SUM(`Quantity`) AS "Total Quantity of Sales", round(SUM(`Quantity`)/suqu.SumOfAllQuantity, 2) AS "Percentage of sales",
        AVG(`Profit margin`)
FROM salesforcourse_quizz_table sa
JOIN SumOfTotalProfitCTE supr
JOIN SumOfAllQuantityCTE suqu
JOIN SumOfRevenueCTE sure
GROUP BY `Country`, suqu.SumOfAllQuantity, sure.SumOfRevenue, supr.SumOfTotalProfit
ORDER BY SUM(`Total Profit`) DESC;

-- Total Profit, Revenue and Quantity of Sales by product category
WITH SumOfAllQuantityCTE AS (
SELECT SUM(`Quantity`) AS SumOfAllQuantity
FROM salesforcourse_quizz_table
),
SumOfTotalProfitCTE AS (
SELECT SUM(`Total Profit`) AS SumOfTotalProfit
FROM salesforcourse_quizz_table
),
SumOfRevenueCTE AS (
SELECT SUM(`Revenue`) AS SumOfRevenue
FROM salesforcourse_quizz_table
)
SELECT Year, `Product Category`, SUM(`Total Profit`) AS "Sum of Total Profit", ROUND(SUM(`Total Profit`)/ supr.SumOfTotalProfit,2) AS "Percentage of Profit",
		SUM(`Revenue`) AS "Sum of Total Revenue", ROUND(SUM(`Revenue`)/ sure.SumOfRevenue,2) AS "Percentage of Revenue",
        SUM(`Quantity`) AS "Total Quantity of Sales", round(SUM(`Quantity`)/suqu.SumOfAllQuantity, 2) AS "Percentage of sales"
FROM salesforcourse_quizz_table su
JOIN SumOfTotalProfitCTE supr 
JOIN SumOfAllQuantityCTE suqu 
JOIN SumOfRevenueCTE sure 
GROUP BY Year, `Product Category`, supr.SumOfTotalProfit,sure.SumOfRevenue,suqu.SumOfAllQuantity
ORDER BY SUM(`Total Profit`) DESC;

-- Total Profit, Revenue and Quantity of Sales by product category and in 2016-6
WITH SumOfAllQuantityCTE AS (
SELECT SUM(`Quantity`) AS SumOfAllQuantity
FROM salesforcourse_quizz_table
),
SumOfTotalProfitCTE AS (
SELECT SUM(`Total Profit`) AS SumOfTotalProfit
FROM salesforcourse_quizz_table
),
SumOfRevenueCTE AS (
SELECT SUM(`Revenue`) AS SumOfRevenue
FROM salesforcourse_quizz_table
)
SELECT `Product Category`, SUM(`Total Profit`) AS "Sum of Total Profit", ROUND(SUM(`Total Profit`)/ supr.SumOfTotalProfit,2) AS "Percentage of Profit",
		SUM(`Revenue`) AS "Sum of Total Revenue", ROUND(SUM(`Revenue`)/ sure.SumOfRevenue,2) AS "Percentage of Revenue",
        SUM(`Quantity`) AS "Total Quantity of Sales", round(SUM(`Quantity`)/suqu.SumOfAllQuantity, 2) AS "Percentage of sales"
FROM salesforcourse_quizz_table su
JOIN SumOfTotalProfitCTE supr 
JOIN SumOfAllQuantityCTE suqu 
JOIN SumOfRevenueCTE sure 
WHERE Year = '2016-06'
GROUP BY `Product Category`, supr.SumOfTotalProfit,sure.SumOfRevenue,suqu.SumOfAllQuantity
ORDER BY SUM(`Total Profit`) DESC;

-- Total Profit, Revenue and Quantity of Sales by product category and sub cateogry
WITH SumOfAllQuantityCTE AS (
SELECT SUM(`Quantity`) AS SumOfAllQuantity
FROM salesforcourse_quizz_table
),
SumOfTotalProfitCTE AS (
SELECT SUM(`Total Profit`) AS SumOfTotalProfit
FROM salesforcourse_quizz_table
),
SumOfRevenueCTE AS (
SELECT SUM(`Revenue`) AS SumOfRevenue
FROM salesforcourse_quizz_table
)
SELECT `Product Category`, `Sub Category`, SUM(`Total Profit`) AS "Sum of Total Profit", ROUND(SUM(`Total Profit`)/ supr.SumOfTotalProfit,2) AS "Percentage of Profit",
		SUM(`Revenue`) AS "Sum of Total Revenue", ROUND(SUM(`Revenue`)/ sure.SumOfRevenue,2) AS "Percentage of Revenue",
        SUM(`Quantity`) AS "Total Quantity of Sales", round(SUM(`Quantity`)/suqu.SumOfAllQuantity, 2) AS "Percentage of sales"
FROM salesforcourse_quizz_table su
JOIN SumOfTotalProfitCTE supr 
JOIN SumOfAllQuantityCTE suqu 
JOIN SumOfRevenueCTE sure 
GROUP BY `Product Category`, `Sub Category`, supr.SumOfTotalProfit,sure.SumOfRevenue,suqu.SumOfAllQuantity
ORDER BY SUM(`Total Profit`) DESC;

SELECT `Product Category`, `Sub Category`, avg(`Profit Margin`)
FROM salesforcourse_quizz_table
GROUP BY `Product Category`, `Sub Category`
ORDER BY avg(`Profit Margin`) DESC;

-- Profit of bike
Select year, `Product Category`,`Country`, SUM(`Quantity`)
FROM salesforcourse_quizz_table
Where `Product Category` = "Bikes"
GROUP BY year, `Country`,`Product Category`
ORDER BY SUM(`Total Profit`);

SELECT Year, `Country`, `Product Category`, SUM(`Quantity`)
FROm salesforcourse_quizz_table
GROUP BY year, `Country`,`Product Category`
ORDER BY Year;

