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

--1. Satis Analizi
-- Toplam siparis sayisi

SELECT COUNT(*) FROM orders

-- En cok satisi olan 5 ürün hangisi?

SELECT  p.product_name,
		SUM(od.quantity) AS totalquantitysold
		FROM order_details AS od
		JOIN products AS p 
			ON od.product_id = p.product_id
	GROUP BY p.product_name
	ORDER BY totalquantitysold DESC
	LIMIT 5


-- Yıllara ve aylara göre satis sayisi

SELECT  EXTRACT(YEAR FROM o.order_date) AS order_year,
		EXTRACT(MONTH FROM o.order_date) AS order_month,
		SUM (od.quantity) AS total_sales
		FROM orders AS o
		JOIN order_details AS od
			ON o.order_id = od.order_id
	GROUP BY order_year, order_month
	ORDER BY order_year, order_month
				
-- yıllara göre toplam satis sayisi					

  SELECT  EXTRACT(YEAR FROM o.order_date) AS order_year,
		SUM (od.quantity) AS total_sales
		FROM orders AS o
		JOIN order_details AS od
			ON o.order_id = od.order_id
	GROUP BY order_year
	ORDER BY order_year

--aylara göre toplam sipariş sayısı

SELECT  EXTRACT(MONTH FROM o.order_date) AS order_month,
		SUM (od.quantity) AS total_sales
		FROM orders AS o
		JOIN order_details AS od
			ON o.order_id = od.order_id
	GROUP BY order_month
	ORDER BY order_month



--2. Ürün analizi 
-- satilan toplam ürün sayisi

SELECT  SUM(quantity) AS total_sales
		FROM order_details

-- kategoriye göre satis sayisini bulup büyükten kücüge siralayin 

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

	
-- ay bazında kategoriye göre satış sayısı,

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


--gelire göre en iyi performans gösteren ürünler

SELECT  p.product_name,
		SUM (od.quantity *od.unit_price * (1-od.discount)) AS total_revenue
		FROM order_details AS od
		JOIN products AS p
			ON od.product_id = p.product_id
	GROUP BY p.product_name
	ORDER BY total_revenue DESC
	LIMIT 5



--3. Müsteri analizi
-- kac müsteri var.

SELECT COUNT (*) FROM customers

-- en cok müsteri hangi ülkeden

SELECT  country,
		COUNT(customer_id) AS customer_count
		FROM customers
	GROUP BY country
	ORDER BY 2 DESC

-- en cok müsteri hangi şehirden

SELECT  city,
		COUNT(customer_id) AS customer_count
		FROM customers
	GROUP BY city
	ORDER BY 2 DESC
	LIMIT 10

--4. Kargolama Analizi
-- En sık kullanılan nakliye araçları ve verimlilikleri

SELECT  s.company_name,
		COUNT(o.order_id) AS total_order_shipped,
		AVG (o.shipped_date - o.order_date) AS avg_delivery_time  
		FROM orders AS o
		JOIN shippers AS s
		ON s.shipper_id = o.ship_via
	GROUP BY s.company_name
	ORDER BY 2 DESC


-- Nakliyeci ve Karlılığa Göre Nakliye Maliyetleri(BU SORUYA TEKRAR BAK TOPLAM SHİPPİNG COST ÇOOK MANTIKLI GELMEDİ)

SELECT  s.company_name,
		SUM(o.freight) AS total_shipping_cost,
		SUM(od.quantity * od.unit_price * (1-od.discount)) AS total_revenue
		FROM orders AS o
		JOIN shippers AS s
			ON s.shipper_id = o.ship_via
		JOIN order_details AS od
			ON o.order_id = od.order_id
	GROUP BY s.company_name


--ÜRÜN BAŞI EN UYGUN SHİPİNG FİRMASI	
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



--ülkeler göre quantity sayıları

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

-- En hızı shiping olan ülkeler

SELECT  c.country,
		AVG((o.shipped_date - o.order_date)) AS avg_shipping_time
		FROM orders AS o
	JOIN customers AS c
		ON o.customer_id = c.customer_id
	WHERE o.shipped_date IS NOT NULL
	GROUP BY c.country
	ORDER BY avg_shipping_time
	LIMIT 10

	
-- RFM analizi(ilk sipariş üzerinden 500 gün geçmiş gibi hesaplama yaptım


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



	
