ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers (customer_id);

ALTER TABLE order_details
ADD CONSTRAINT fk_order_details_orders
FOREIGN KEY (order_id)
REFERENCES orders (order_id);

ALTER TABLE order_details
ADD CONSTRAINT fk_order_details_products
FOREIGN KEY (product_id)
REFERENCES products (product_id);

ALTER TABLE products
ADD CONSTRAINT fk_products_suppliers
FOREIGN KEY (supplier_id)
REFERENCES suppliers (supplier_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_shippers
FOREIGN KEY (ship_via)
REFERENCES shippers (shipper_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_employees
FOREIGN KEY (employee_id)
REFERENCES employees (employee_id);

1.Sales Analysis
1.1.Total number of orders

SELECT COUNT(*) FROM orders

1.2.Top 5 best selling products

SELECT  p.product_name,
		SUM(od.quantity) AS totalquantitysold
		FROM order_details AS od
		JOIN products AS p 
			ON od.product_id = p.product_id
	GROUP BY p.product_name
	ORDER BY totalquantitysold DESC
	LIMIT 5


1.3.Total Number of Orders by Month

SELECT  EXTRACT(YEAR FROM o.order_date) AS order_year,
		EXTRACT(MONTH FROM o.order_date) AS order_month,
		SUM (od.quantity) AS total_sales
		FROM orders AS o
		JOIN order_details AS od
			ON o.order_id = od.order_id
	GROUP BY order_year, order_month
	ORDER BY order_year, order_month
				
1.4.Total sales by year					

  SELECT  EXTRACT(YEAR FROM o.order_date) AS order_year,
		SUM (od.quantity) AS total_sales
		FROM orders AS o
		JOIN order_details AS od
			ON o.order_id = od.order_id
	GROUP BY order_year
	ORDER BY order_year

1.5.Total Number of orders by month

SELECT  EXTRACT(MONTH FROM o.order_date) AS order_month,
		SUM (od.quantity) AS total_sales
		FROM orders AS o
		JOIN order_details AS od
			ON o.order_id = od.order_id
	GROUP BY order_month
	ORDER BY order_month



2.Product Analysis  
2.1. Total number of Product Sold

SELECT  SUM(quantity) AS total_sales
		FROM order_details

2.2. Find the sales number by category and sort from largest to smallest

SELECT  c.category_name,
		SUM(od.quantity) AS totalquantitysold
		FROM  categories AS c
		JOIN products AS p
			ON p.category_id = c.category_id
		JOIN order_details AS od
			ON od.product_id = p.product_id
	GROUP BY c.category_name
	ORDER BY 2 DESC
	LIMIT 5

	
2.3. Number of sales by category on a monthly basis

WITH monthly_sales AS (
    SELECT 
        EXTRACT(MONTH FROM o.order_date) AS month,
        c.category_name,
        SUM(od.quantity) AS total_sales
    FROM orders o
    JOIN order_details AS od 
		ON o.order_id = od.order_id
    JOIN products AS p 
		ON od.product_id = p.product_id
    JOIN categories AS c 
		ON p.category_id = c.category_id
    GROUP BY month, c.category_name
)
		SELECT month, 
	   category_name, 
	   total_sales
		FROM monthly_sales
		WHERE (month, total_sales) IN (
    		SELECT month, MAX(total_sales)
   				FROM monthly_sales
    GROUP BY month
)
	ORDER BY month


2.4. Best performing products by revenue

SELECT  p.product_name,
		SUM (od.quantity *od.unit_price * (1-od.discount)) AS total_revenue
		FROM order_details AS od
		JOIN products AS p
			ON od.product_id = p.product_id
	GROUP BY p.product_name
	ORDER BY total_revenue DESC
	LIMIT 5



3. Customer Analysis
3.1. Customer Count

SELECT COUNT (*) FROM customers

3.2. Country with the most customers

SELECT  country,
		COUNT(customer_id) AS customer_count
		FROM customers
	GROUP BY country
	ORDER BY 2 DESC

3.3. City with the most customers top 10

SELECT  city,
		COUNT(customer_id) AS customer_count
		FROM customers
	GROUP BY city
	ORDER BY 2 DESC
	LIMIT 10

4. Shipping Analysis
4.1.Most commonly used transport firms and their efficiency

SELECT  s.company_name,
		COUNT(o.order_id) AS total_order_shipped,
		AVG (o.shipped_date - o.order_date) AS avg_delivery_time  
		FROM orders AS o
		JOIN shippers AS s
		ON s.shipper_id = o.ship_via
	GROUP BY s.company_name
	ORDER BY 2 DESC


4.2. Shipping costs by carrier and profitability

SELECT  s.company_name,
		SUM(o.freight) AS total_shipping_cost,
		SUM(od.quantity * od.unit_price * (1-od.discount)) AS total_revenue
		FROM orders AS o
		JOIN shippers AS s
			ON s.shipper_id = o.ship_via
		JOIN order_details AS od
			ON o.order_id = od.order_id
	GROUP BY s.company_name


4.3. The most suitable shipping company per product
	
SELECT 
    shippers.company_name, 
    AVG(orders.freight) AS shipping_cost_per_item
FROM 
    orders
JOIN 
    shippers ON orders.ship_via = shippers.shipper_id
GROUP BY 
    shippers.company_name
ORDER BY 
    shipping_cost_per_item ASC




4.4. Quantity numbers by country

SELECT 
    customers.country, 
    SUM(order_details.quantity) AS TotalQuantitySold
FROM 
    orders
JOIN 
    order_details ON orders.order_id = order_details.order_id
JOIN 
    customers ON orders.customer_id = customers.customer_id
GROUP BY 
    customers.country
ORDER BY 
    TotalQuantitySold DESC
LIMIT 10

4.5. Fastest Shipping

SELECT  c.country,
		AVG((o.shipped_date - o.order_date)) AS avg_shipping_time
		FROM orders AS o
	JOIN customers AS c
		ON o.customer_id = c.customer_id
	WHERE o.shipped_date IS NOT NULL
	GROUP BY c.country
	ORDER BY avg_shipping_time
	LIMIT 10

	
5. RFM Analysis


WITH rfm AS(
	WITH rfm_data AS (
	    
	    SELECT 
	        customers.customer_id,
	        MAX(orders.order_date) AS last_order_date,      
	        COUNT(orders.order_id) AS frequency,          
	        SUM(order_details.quantity * order_details.unit_price) AS monetary 
	    FROM 
	        customers
	    JOIN 
	        orders ON customers.customer_id = orders.customer_id
	    JOIN 
	        order_details ON orders.order_id = order_details.order_id
	    GROUP BY 
	        customers.customer_id
	)
	
	SELECT 
	    customer_id,
	    DATE '1999.01.01' - last_order_date AS Recency,  
	    frequency,
	    monetary
	FROM 
	    rfm_data
	ORDER BY 
	    recency ASC, frequency DESC, monetary DESC
)
SELECT 
	        customer_id,
	        CASE 
	            WHEN  '500' - recency <= 30 THEN 5
	            WHEN  '500' - recency <= 90 THEN 4
	            WHEN  '500' - recency <= 180 THEN 3
	            WHEN  '500' - recency <= 250 THEN 2
	            ELSE 1
	        END AS recency_score,
	       
	        CASE 
	            WHEN frequency >= 50 THEN 5
	            WHEN frequency >= 20 THEN 4
	            WHEN frequency >= 10 THEN 3
	            WHEN frequency >= 5 THEN 2
	            ELSE 1
	        END AS frequency_score,	        
	        
	        CASE 
	            WHEN monetary >= 10000 THEN 5
	            WHEN Monetary >= 5000 THEN 4
	            WHEN Monetary >= 2000 THEN 3
	            WHEN monetary >= 1000 THEN 2
	            ELSE 1
	        END AS monetary_score
	    FROM 
	       rfm



	
