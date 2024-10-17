                                                           
# Northwind 
![northwind-footer-logo](https://github.com/user-attachments/assets/4f3af3a5-4aff-49ca-b4d1-5e7ef51a55f7)

  Northwind is an international trading company operating in the food and beverage sector. The company sources a variety of products from suppliers worldwide and sells them to retailers and restaurants. Aiming to provide high-quality service and a wide range of products, Northwind efficiently manages customer orders, product inventory, and supplier relationships.

# Northwind Database

  The Northwind database is a sample trading database that includes sales, order, and supply processes. It contains tables related to various business units such as products, customers, suppliers, orders, and employees. Used to model a company's operations, this database is ideal for practicing SQL queries and data analysis.

## 1.	Sales Analysis
### 1.1.Total number of orders
Total number of this case 830

### 1.2.Top 5 best selling products
![1 2](https://github.com/user-attachments/assets/812a0200-41c0-499e-8606-0619073ffe23)

First, I joined the products table and the order_details table using the product_id column. In the new table, I selected the product_name from the products table and the total quantity from the order_details table. This way, I identified the top 5 best-selling products.

### 1.3.Total Number of Orders by Month
![1 3](https://github.com/user-attachments/assets/767fec67-6e52-4786-abd4-c4b19c0fcaea)

The orders and order_details tables were joined using the order_id column. In the newly created table, the year and months were extracted, and the total number of sales was calculated. It is important to note that only data for all months of 1997 is available. For 1996, only the 7th and 12th months have data, and for 1998, data is available only for the months between January and May.

## 2.Product Analysis
### 2.1.Total Number of Products Sold
Total Number of Products Sold is 51317.

### 2.2.Number of Sales by Category
![2 2](https://github.com/user-attachments/assets/19e9395b-8fff-4a57-8000-e7b5bc22090c)

In this analysis, there was no direct connection between the categories and order_details columns. Therefore, the categories table was first joined with the products table using the category_id, and then the order_details and products tables were joined using the product_id. In the newly created table, the totalquantitysold was calculated and sorted in descending order.

### 2.3.Number of Sales by Category on a Monthly Basis
![2 3](https://github.com/user-attachments/assets/28cf2deb-6147-4b38-a352-cdd5b98230ac)

In this analysis, to connect the orders and categories tables, the orders table was first joined with the order_details table, then the products table was joined with the order_details, and finally, the categories table was joined with the products table using the JOIN command. The best-selling categories were then ranked on a monthly basis. After that, a new table was created using WITH, and in this new table, the best-selling category and total sales were ranked by month.

### 2.4.Best Performing Products by Revenue
![2 4](https://github.com/user-attachments/assets/44f3f2fc-2873-494b-9a9a-d2557f4eab3c)

To calculate the total revenue, the quantity and unit_price from the order_details table were multiplied, and to determine the actual selling price, the discount was subtracted. In this analysis, the top 5 most profitable products are ranked. The order_details and products tables were joined using the JOIN command.

## 3.Customer Analysis
### 3.1.Customer Count
Number of customers are 91

### 3.2.Country With the Most Customers
![3 2](https://github.com/user-attachments/assets/c2b3fa5e-fcb5-44dd-a282-13ae36f84d8d)

### 3.3.City With the Most Customers top 10
![3 3](https://github.com/user-attachments/assets/95ca0a31-c85c-4652-8c82-48441c6c80db)

## 4.Shipping Analysis
### 4.1.Most Commonly Used Transport Firms and Their Efficiency
![4 1](https://github.com/user-attachments/assets/3c122c26-ba67-4e71-bf90-ace5fa7bb018)

In this analysis, the average delivery time was calculated by subtracting shipped_date from order_date. The orders and shippers tables were joined to identify the most commonly used shipping methods.

### 4.2.Shipping Costs by Carrier and Profitability
![4 2](https://github.com/user-attachments/assets/7cd471d0-a7bf-4c80-95ca-49e6109e5dae)

### 4.3.The Most Suitable Shipping Company per Product 
![4 3](https://github.com/user-attachments/assets/6e1ff884-4ca0-465b-8bf6-cabe78657b8c)

Looking at the results of the above tables, the most commonly used shipping company is the most expensive, while the least used one offers the most affordable rates per product. By prioritizing the second company, we can increase profitability.

### 4.4.Quantity Numbers by Country
![4 4](https://github.com/user-attachments/assets/5b2ad48c-d490-411f-817b-85323adb035d)

### 4.5.Fastest Shipping
![4 5](https://github.com/user-attachments/assets/45403f93-f5cb-4b19-bc48-a936714b1715)















































