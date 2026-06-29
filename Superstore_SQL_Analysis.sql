select TOP 10 * FROM Superstore;

use Superstoredb;

--Calculate month-over-month sales growth
with monthlysales AS(
     select DATEFROMPARTS(YEAR(Order_Date),MONTH(Order_Date),1) as orderdate,
            sum(sales) as currentyear_sales
     from Superstore
     Group by DATEFROMPARTS(YEAR(Order_Date),MONTH(Order_Date),1)
     ),
     growth AS(
           select orderdate, currentyear_sales,
                  lag(currentyear_sales) over(order by orderdate) as prevyear_sales
            from monthlysales
     )
     select orderdate, currentyear_sales, prevyear_sales, 
     (currentyear_sales - prevyear_sales) as salesgrowth
     from growth;

--Find customers whose sales are above average.
     
     select Customer_ID,Customer_Name,AVG(Sales) as averagesales
     FROM Superstore
     Group By Customer_ID,Customer_Name
     Having AVG(Sales) >
     (
       select avg(sales) from Superstore
      )

--Find products whose profit is below average.
select Product_ID,Product_Name,AVG(Profit) as averageprofit
     FROM Superstore
     Group By Product_ID,Product_Name
     Having AVG(Profit) <
     (
       select avg(Profit) from Superstore
      )