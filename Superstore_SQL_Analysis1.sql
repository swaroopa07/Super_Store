select TOP 50 * from Superstore;
use Superstoredb;
--What is the total sales generated?
select sum(Superstore.Sales) as Total_Sales from Superstore;

--What is the total profit earned?
select sum(Superstore.Profit) as Total_Profit from Superstore;

--How many unique orders were placed?
SELECT COUNT(DISTINCT Order_ID) as Distinct_orders FROM Superstore;

--How many unique customers are there?
SELECT COUNT(DISTINCT Customer_ID) as Distinct_Customers FROM Superstore;

--How many unique products are sold?
SELECT COUNT(DISTINCT Product_ID) as Distinct_Products FROM Superstore;

--Category Analysis
--Which category generates the highest sales?
select TOP 1 Category, sum(Sales) as highest_category from Superstore
Group BY Category
Order By highest_category desc

--Which category generates the highest profit?
select TOP 1 Category, Sum(profit) as highest_category_profit from Superstore
Group By Category
Order By highest_category_profit desc

--Which sub-category generates the highest sales?
select TOP 1 Sub_Category, SUM(Sales) as highest_subcategory from Superstore
Group By Sub_Category
Order By highest_subcategory desc

--Which sub-category generates the highest profit?
select TOP 1 Sub_Category, Sum(profit) as highest_subcategory_profit from Superstore
Group By Sub_Category
Order By highest_subcategory_profit desc

--Which sub-category incurs the highest loss?
select TOP 1 Sub_Category, Sum(profit) as lowest_subcategory_profit from Superstore
Group By Sub_Category
Order By lowest_subcategory_profit asc

--Regional Analysis

--Which region has the highest sales?
select TOP 1 Region, SUM(Sales) as TOP_Region_Sales from Superstore
Group By Region
Order By TOP_Region_Sales desc

--Which region has the highest profit?
select TOP 1 Region, SUM(Sales) as TOP_Region_Profit from Superstore
Group By Region
Order By TOP_Region_Profit desc

--Which state generates the highest sales?
select TOP 1 State, SUM(Sales) as TOP_State_Sales from Superstore
Group By State
Order By TOP_State_Sales desc

--Which state generates the highest profit?
select TOP 1 State, SUM(Sales) as TOP_State_profit from Superstore
Group By State
Order By TOP_State_profit desc

--Which state incurs the highest loss?
select TOP 1 State, SUM(Sales) as Low_State_Sales from Superstore
Group By State
Order By Low_State_Sales asc

--Customer Analysis
--Who are the top 10 customers by sales?
SELECT TOP 10 customer_id,
       customer_name,
       SUM(sales) AS Customer_Sales
FROM Superstore
GROUP BY customer_id, customer_name
ORDER BY Customer_Sales DESC;

--Who are the top 10 customers by profit?
SELECT TOP 10 customer_id,
       customer_name,
       SUM(profit) AS Customer_Sales_Profit
FROM Superstore
GROUP BY customer_id, customer_name
ORDER BY Customer_Sales_Profit DESC;

--Which customer placed the most orders?
select TOP 1 Customer_ID, 
       COUNT(Distinct Order_ID) as Customer_Orders
FROM Superstore
Group By Customer_ID
Order BY Customer_Orders desc

--Which customer generated the most loss?
SELECT TOP 1 customer_id,
       customer_name,
       SUM(profit) AS MOST_LOSS_CUST
FROM Superstore
GROUP BY customer_id, customer_name
ORDER BY MOST_LOSS_CUST ASC;

--What are the top 10 products by sales?
select TOP 10 Product_Name, Sum(Sales) as Total_ProductSales
       FROM Superstore
       Group BY Product_Name
       Order BY Total_ProductSales desc

--What are the top 10 products by profit?
select TOP 10 Product_Name, Sum(Profit) as Total_ProductProfit
       FROM Superstore
       Group BY Product_Name
       Order BY Total_ProductProfit desc

--Which product generated the highest loss?
select TOP 1 Product_Name, Sum(Profit) as Lowest_Product
       FROM Superstore
       Group BY Product_Name
       Order BY Lowest_Product asc

--Which products were sold the most by quantity?
select TOP 1 product_name, sum(Quantity) as Total_ProductQuantity 
FROM Superstore
Group BY Product_Name
Order By Total_ProductQuantity desc

--What is the average discount given?
select avg(Discount) as avg_discount
from Superstore

--Which discount level is associated with the highest sales?
select Top 1 Discount, SUM(Sales) as highest_discountsales
from Superstore
Group by Discount
Order by highest_discountsales desc

--Does higher discount lead to lower profit?
SELECT 
    CASE 
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount <= 0.1 THEN 'Low Discount'
        WHEN Discount <= 0.3 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS Discount_Level,
    SUM(Profit) AS Total_Profit
FROM Superstore
GROUP BY 
    CASE 
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount <= 0.1 THEN 'Low Discount'
        WHEN Discount <= 0.3 THEN 'Medium Discount'
        ELSE 'High Discount'
    END
ORDER BY Total_Profit;

--Which products are frequently sold with high discounts?
SELECT Product_Name,
       COUNT(*) AS High_Discount_Frequency
FROM Superstore
WHERE Discount >= 0.3
GROUP BY Product_Name
ORDER BY High_Discount_Frequency DESC;

--Time Analysis

--What are the yearly sales trends?
SELECT YEAR(Order_Date),
       SUM(Sales) AS Yearly_Sales
FROM Superstore
GROUP BY YEAR(Order_Date)
ORDER BY YEAR(Order_Date);

--What are the yearly profit trends?
SELECT YEAR(Order_Date),
       SUM(Profit) AS Yearly_ProfitSales
FROM Superstore
GROUP BY YEAR(Order_Date)
ORDER BY YEAR(Order_Date);

--Which month has the highest sales?
select TOP 1 month(Order_date) AS highest_month, sum(sales) as highest_sales
from Superstore
Group by month(Order_date)
order by highest_sales desc

--Which month has the highest profit?
select TOP 1 month(Order_date) AS highest_month, sum(profit) as highest_profitsales
from Superstore
Group by month(Order_date)
order by highest_profitsales desc

--Which year generated the highest total profit?
SELECT TOP 1 YEAR(Order_Date) as best_year,
       SUM(Profit) AS Yearly_Profit
FROM Superstore
GROUP BY YEAR(Order_Date)
ORDER BY Yearly_Profit desc;

--Rank customers by total sales.
WITH cust_sales AS (
    SELECT Customer_ID,
           Customer_Name,
           SUM(Sales) AS Total_Sales
    FROM Superstore
    GROUP BY Customer_ID, Customer_Name
)
SELECT Customer_ID,
       Customer_Name,
       Total_Sales,
       DENSE_RANK() OVER (ORDER BY Total_Sales DESC) AS Ranking
FROM cust_sales;

--Rank products by total profit.
with tot_profit AS(
  select Product_ID,Product_Name,sum(profit) as tot_profit
  from Superstore
  Group by Product_ID,Product_Name
  )
  select Product_ID,Product_Name,tot_profit,
  DENSE_RANK() OVER(ORDER BY tot_profit desc) as profit_ranking
  from tot_profit;

  --Find the top product in each category.
  with top_product AS(
       select Product_ID, Product_Name, Category, Sum(Sales) as tot_sales
       from Superstore
       Group BY Product_ID, Product_Name, Category
       ),
       each_category AS(
              select Product_ID, Product_Name, Category, tot_sales,
              DENSE_RANK() OVER(partition by Category order by tot_sales desc) as top_prodcategory
              from top_product
              )
        select Product_ID, Product_Name, Category, tot_sales from each_category where top_prodcategory=1;

--Find the top customer in each region.
with top_cust AS(
      select customer_ID, customer_Name, Region, sum(sales) as tot_sales
      from Superstore
      Group by customer_ID, customer_Name, Region
      ),
      ranking AS(
           select customer_ID, customer_Name, Region, tot_sales,
                  DENSE_RANK() OVER(PARTITION BY Region order by tot_sales desc) as top_customers
                from top_cust
                )
       select customer_ID, customer_Name, Region, tot_sales from ranking
       where top_customers = 1;

--Calculate cumulative sales over time.
with cum_sales AS(
     select year(Order_DATE) as orderdate, sum(Sales) as tot_sales
     from Superstore
     Group by year(Order_Date)
     ),
     cumulative_sales AS(
     select orderdate, tot_sales,
     sum(tot_sales)
     over(ORDER BY orderdate
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as total_sales
     from cum_sales
     )
     select orderdate, tot_sales, total_sales from cumulative_sales 


