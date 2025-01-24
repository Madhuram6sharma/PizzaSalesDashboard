-- Cross Check Data is imported correctly
SELECT * 
FROM PizzaDS

-- Now we will write Queries for each KPI

-- KPI 1 = Total Revenue : The sum of total price of all pizza orders
SELECT SUM(total_price) AS Total_Revenue
FROM PizzaDS;

-- KPI 2 = Average Order Value : The average amount spent per order, calculated by dividing total revenue by total number of orders
SELECT SUM(total_price)/COUNT(DISTINCT order_id) AS Avg_Order_Value
FROM PizzaDS;

-- KPI 3 = Total Pizza Sold : Sum of quantity of all pizza sold
SELECT SUM(quantity) AS Total_Pizza_Sold
FROM PizzaDS;

-- KPI 4 = Total Orders : Total number of orders placed
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM PizzaDS;

-- KPI 5 = Average Pizza per Order : The average number of pizzas sold per order, calculated by dividing total number of pizzas sold by total orders
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2))/CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) AS Avg_Pizza_Per_Order
FROM PizzaDS;

-- Now we will write queries for charts

-- Chart 1 = Daily Trends for Total Orders : Chart that displays daily trends of total orders over specific time period.
-- This will helps us identify any patterns or fluctuations in order volumes on daily basis

SELECT DATENAME(DW, order_date) AS Order_Day, COUNT(DISTINCT order_id) AS Total_Order
FROM PizzaDS
GROUP BY DATENAME(DW, order_date);

-- Chart 2 = Monthly Trends for Total Orders : Chart that illustrates hourly trends of total orders throughtout the day.
-- This will help us identify peak hours or periods of high order activity

SELECT DATENAME(MONTH, order_date) AS Order_Month, COUNT(DISTINCT order_id) AS Total_Order
FROM PizzaDS
GROUP BY DATENAME(MONTH, order_date)
ORDER BY Total_Order DESC;

-- Chart 3 = Percentage of Sales by Pizza Category : Chart shows distribution of pizza sales by Pizza Category
-- This Chart provides insights into popularity of various pizza categories and their contribution to overall sales

SELECT pizza_category, SUM(total_price) AS Total_Sales, SUM(total_price) * 100 /
(SELECT SUM(total_price) FROM PizzaDS WHERE MONTH(order_date) = 1) AS Percentage_Total_Sales
FROM PizzaDS
WHERE MONTH(order_date) = 1
GROUP BY pizza_category;

-- Chart 4 = Prcentage of Pizza Sales by Pizza Size : Chart represents percentage of sales attributed to different pizza size.
-- This chart will help us understand customer preference for pizza size and their impact on sales

SELECT pizza_size, SUM(total_price) AS Total_Sales, CAST(SUM(total_price) * 100 /
(SELECT SUM(total_price) FROM PizzaDS WHERE DATEPART(quarter, order_date) = 1) AS DECIMAL(10,2)) AS Percentage_Total_Sales
FROM PizzaDS
WHERE DATEPART(quarter, order_date) = 1
GROUP BY pizza_size
ORDER BY Percentage_Total_Sales DESC;

-- Chart 5 = Top 5 Best Sellers by Revenue, Quantity and Total Orders
-- This chart will help us identify most popular pizza options

-- TOP 5 by Revenue
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM PizzaDS
GROUP BY pizza_name
ORDER BY Total_Revenue DESC;

-- TOP 5 by Quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Quantity
FROM PizzaDS
GROUP BY pizza_name
ORDER BY Total_Quantity DESC;

-- Top 5 by Total Orders
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM PizzaDS
GROUP BY pizza_name
ORDER BY Total_Orders DESC;

-- Chart 6 = Bottom 5 Worst Sellers by Revenue, Quantity and Total Orders
-- This chart will enable us to identify underperforming or less popular pizza options

-- Bottom 5 by Revenue
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM PizzaDS
GROUP BY pizza_name
ORDER BY Total_Revenue ASC;

-- Bottom 5 by Quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Quantity
FROM PizzaDS
GROUP BY pizza_name
ORDER BY Total_Quantity ASC;

-- Bottom 5 by Total Orders
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM PizzaDS
GROUP BY pizza_name
ORDER BY Total_Orders ASC;