use Blinkitdb
select * from BlinkIT_data
select distinct item_fat_content from BlinkIT_data

update BlinkIT_data
set Item_Fat_Content= 
case 
when Item_Fat_Content in ('LF', 'low fat') then 'Low Fat'
when Item_Fat_Content= 'reg' then 'Regular'
else Item_Fat_Content
end

---What is the Total sales as per the fat content?
select item_fat_content, Round(sum(total_Sales),2) as total_Sales
from BlinkIT_data
group by item_fat_content
--In millions
select item_fat_content, Cast(sum(total_Sales)/1000000 as decimal(10,2)) as total_Sales_Mil
from BlinkIT_data
group by item_fat_content

---What is the Total Sales as per the item type
select item_type, Round(sum(Total_Sales),2) as total_sales from BlinkIT_data
group by item_type
-- Outlet with Max Sales

SELECT 
    Outlet_Identifier,
    Round(MAX(Total_Sales),2) AS MaxSales
FROM BlinkIT_data
GROUP BY Outlet_Identifier;
-- Outlet with MIn Sales
SELECT 
    Outlet_Identifier,
    Round(Min(Total_Sales),2) AS MinSales
FROM BlinkIT_data
GROUP BY Outlet_Identifier
Order by MinSales 

---Give Total, Min and Max sales of each outlet.
Select Outlet_Identifier, sum(Total_sales) as Totalsales,
Min(Total_sales) as Minn, MAX(Total_sales) as Maxx
from BlinkIT_data
group by Outlet_Identifier

---Give Min and Max sales of each Item of that OutleT

SELECT 
    Outlet_Identifier,
    Item_Type,
    ROUND(Total_Sales,2) AS TotalSales,
    MIN(Total_Sales) OVER (PARTITION BY Outlet_Identifier, Item_Type) AS Min_Sales,
    MAX(Total_Sales) OVER (PARTITION BY Outlet_Identifier, Item_Type) AS Max_Sales
FROM BlinkIT_data
ORDER BY Outlet_Identifier, Item_Type, TotalSales DESC;


SELECT 
    Outlet_Identifier,
    Item_Type,
    MIN(Total_Sales) AS Min_Sales,
    MAX(Total_Sales) AS Max_Sales
FROM BlinkIT_data
GROUP BY Outlet_Identifier, Item_Type
ORDER BY Outlet_Identifier, Item_Type;

--If management wants to know which Outlet_Type 
----(e.g., Supermarket Type1, Grocery Store) is most profitable, how would you query it?

SELECT TOP 1
    Outlet_Type,
    SUM(Total_Sales) AS TotalSales
FROM BlinkIT_data
GROUP BY Outlet_Type
ORDER BY TotalSales desc;


---Outlet type with 2nd Highest sales
Select Outlet_Type, TotalSAles
from (Select Outlet_Type, sum(total_Sales) as Totalsales,
rank() over(order by sum(total_Sales) desc) as rk
from BlinkIT_data
group by Outlet_Type) t
where rk=2

---Least Sales 
SELECT TOP 1
    Outlet_Type,
    SUM(Total_Sales) AS TotalSales
FROM BlinkIT_data
GROUP BY Outlet_Type
ORDER BY TotalSales;

---2 least of Outlet
Select Outlet_Type, Totalsales from 
(Select Outlet_Type, Sum(Total_Sales) as Totalsales,
Rank()over(order by Sum(Total_Sales)) as rk from BlinkIT_data
group by Outlet_Type)t
where rk=2

---Top 3 Best-Selling Items in Each Item_Type
Select Item_Type,Outlet_Type, Totalsales from
(Select Item_Type,Outlet_Type, Sum(Total_Sales) as Totalsales,
Rank() over(Partition by Item_Type order by Sum(Total_Sales) desc ) as rk
from BlinkIT_data
Group by Item_Type,Outlet_Type)t
where rk <= 3
Order by Item_Type, Outlet_Type, Totalsales

---Cumulative sales 
Select * from BlinkIT_data
where Item_Weight is NULL
Select Outlet_Type, Item_Type, Outlet_establishment_Year,Total_Sales,
Sum(Total_sales) over (order by Outlet_Type, Item_Type, Outlet_establishment_Year, Total_Sales) as Totalsales
from BlinkIT_data

---Cumulative sales of each Outlet, Item Type and Establishment Year
Select Outlet_Type, Item_Type, Outlet_establishment_Year,Total_Sales,
Sum(Total_sales) 
over (
partition by Outlet_Type, Item_Type, Outlet_establishment_Year 
order by Outlet_Type, Item_Type, Outlet_establishment_Year, Total_Sales   ) as Totalsales
from BlinkIT_data

---Replace Nulls with coalesce
Select *, coalesce(Item_Weight,Avg(Item_Weight)over()) as Clean_weight
from BlinkIT_data


---Highest Ranked Outlet
Select Outlet_Identifier,Sum(Rating) as Ranki
from BlinkIT_data
Group by Outlet_Identifier
Order by Sum(Rating) desc

Select * from BlinkIT_data

Select Outlet_Identifier,Outlet_Size, Outlet_Establishment_Year, Sum(Rating) as Ranki
from BlinkIT_data
Group by Outlet_Identifier,Outlet_Size,Outlet_Establishment_Year
Order by Outlet_Establishment_Year,Sum(Rating) desc

Select Outlet_Identifier,Outlet_Size, Rating,
Sum(Rating) over(Partition by Outlet_Identifier,Outlet_Size
order by Outlet_Identifier,Outlet_Size,rating) as Ranki
from BlinkIT_data
Group by Outlet_Identifier,Outlet_Size