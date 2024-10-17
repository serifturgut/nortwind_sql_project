                                                           
# Northwind 

  Northwind is an international trading company operating in the food and beverage sector. The company sources a variety of products from suppliers worldwide and sells them to retailers and restaurants. Aiming to provide high-quality service and a wide range of products, Northwind efficiently manages customer orders, product inventory, and supplier relationships.

# Northwind Database

  The Northwind database is a sample trading database that includes sales, order, and supply processes. It contains tables related to various business units such as products, customers, suppliers, orders, and employees. Used to model a company's operations, this database is ideal for practicing SQL queries and data analysis.

## 1.	Sales Analysis
## 1.1.	Total number of orders
Total number of this case 830

## 1.2. Top 5 best selling products
![1 2](https://github.com/user-attachments/assets/812a0200-41c0-499e-8606-0619073ffe23)

First, I joined the products table and the order_details table using the product_id column. In the new table, I selected the product_name from the products table and the total quantity from the order_details table. This way, I identified the top 5 best-selling products.
