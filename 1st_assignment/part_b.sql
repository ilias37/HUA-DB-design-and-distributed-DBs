ALTER SESSION SET nls_date_format='yyyy-mm-dd';

--------------------------------------------------------------------------------CUSTOMERS TABLE
CREATE TABLE customers AS
SELECT c.id customer_id, c.gender gender, c.marital_status marital_status, c.income_level income_level, c.birth_date birth_date
FROM xsales.customers c;

ALTER TABLE customers ADD agegroup VARCHAR2(20); 

--------------------------------------------------------------------------------GEMISMA TIMWN THS STHLHS marital_status
UPDATE customers
SET marital_status = 'married'
WHERE marital_status = 'married' OR marital_status = 'Married' OR marital_status = 'Mabsent' OR marital_status = 'Mar-AF';

UPDATE customers
SET marital_status = 'unknown'
WHERE marital_status IS null;

UPDATE customers
SET marital_status = 'single'
WHERE marital_status = 'NeverM' OR marital_status = 'single' OR marital_status = 'Separ.' OR marital_status = 'Divorce.' OR marital_status = 'Widowed' OR marital_status = 'widow' OR marital_status = 'Divorc.' OR marital_status = 'divorced';

--------------------------------------------------------------------------------GEMISMA TIMWN THS STHLHS income_level
UPDATE customers
SET income_level = 'low'
WHERE income_level LIKE 'A%' OR income_level LIKE 'B%' OR income_level LIKE 'C%' OR income_level LIKE 'D%' OR income_level LIKE 'E%';

UPDATE customers
SET income_level = 'medium'
WHERE income_level LIKE 'F%' OR income_level LIKE 'G%' OR income_level LIKE 'H%' OR income_level LIKE 'I%';

UPDATE customers
SET income_level = 'high'
WHERE income_level LIKE 'J%' OR income_level LIKE 'K%' OR income_level LIKE 'L%';

UPDATE customers
SET income_level = null
WHERE income_level IS null;

--------------------------------------------------------------------------------GEMISMA TIMWN THS STHLHS agegroup
UPDATE customers
SET agegroup = 'under 30'
WHERE (SYSDATE - birth_date) / 365 <= 30;

UPDATE customers
SET agegroup = '30-40'
WHERE (SYSDATE - birth_date) / 365 > 30 AND (SYSDATE - birth_date) / 365 <= 40; 

UPDATE customers
SET agegroup = '40-50'
WHERE (SYSDATE - birth_date) / 365 > 40 AND (SYSDATE - birth_date) / 365 <= 50; 

UPDATE customers
SET agegroup = '50-60'
WHERE (SYSDATE - birth_date) / 365 > 50 AND (SYSDATE - birth_date) / 365 <= 60; 

UPDATE customers
SET agegroup = '60-70'
WHERE (SYSDATE - birth_date) / 365 > 60 AND (SYSDATE - birth_date) / 365 <= 70; 

UPDATE customers
SET agegroup = 'above 70'
WHERE (SYSDATE - birth_date) / 365 > 70;

ALTER TABLE customers DROP COLUMN birth_date;

--------------------------------------------------------------------------------PRODUCTS TABLE
CREATE TABLE products AS
SELECT xp.identifier product_id, xp.name productname, xc.name categoryname, xp.list_price list_price
FROM xsales.products xp JOIN xsales.categories xc
ON xp.subcategory_reference = xc.id;

--------------------------------------------------------------------------------ORDERS TABLE
CREATE TABLE orders AS
SELECT xoi.order_id order_id, xoi.product_id product_id, xo.customer_id customer_id, xo.order_finished - xoi.order_date as days_to_process, xoi.amount price, xoi.cost cost, xo.channel channel
FROM xsales.orders xo JOIN xsales.order_items xoi 
ON xo.id = xoi.order_id;

--------------------------------------------------------------------------------EMFANISH KAI DIAGRAFH PINAKWN
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
DROP TABLE customers;
DROP TABLE products;
DROP TABLE orders;