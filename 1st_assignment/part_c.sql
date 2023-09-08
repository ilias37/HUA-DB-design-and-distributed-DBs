ALTER SESSION SET nls_date_format = 'DD--MM--YYYY';

--------------------------------------------------------------------------------DHMIOURGIA PINAKWN POY XREIAZONTAI STO ERWTHMA
CREATE TABLE customers AS select * FROM xsales.customers;
CREATE TABLE products AS select * FROM xsales.products;
CREATE TABLE orders AS select * FROM xsales.orders;
CREATE TABLE order_items AS select * FROM xsales.order_items;

--------------------------------------------------------------------------------TO EXPLAIN TOU QUERIE
EXPLAIN PLAN FOR 
SELECT c.name, oi.amount, oi.quantity, p.name
FROM customers c JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.identifier
WHERE p.name LIKE '%DVD%' AND oi.order_date BETWEEN '1/1/2000' AND '31/12/2000' AND o.channel='Internet'
ORDER BY c.name;

--------------------------------------------------------------------------------EMFANISH SUGKEKRIMENWN STHLWN TOY PLAN_TABLE
SELECT cost,io_cost, cpu_cost, cardinality, id, parent_id, depth, operation, options, object_name, time
FROM plan_table
START WITH id = 0
CONNECT BY PRIOR ID = parent_id;

SELECT id, parent_id, depth, operation, options, object_name, access_predicates, filter_predicates, projection, cost, cardinality
FROM plan_table
START WITH id = 0
CONNECT BY PRIOR ID = parent_id
ORDER BY id;

--------------------------------------------------------------------------------EMFANISH TOY PLAN_TABLE ME DIAFORETIKH MORFH 
SELECT plan_table_output FROM TABLE(dbms_xplan.display());

--------------------------------------------------------------------------------DIAGRAFH TOY PLAN_TABLE
DELETE FROM plan_table;

--------------------------------------------------------------------------------DWSMENO QUERIE...BLEPOYME TO SYNOLIKO ARITHMO PLEIADWN
SELECT c.name, oi.amount, oi.quantity, p.name
FROM customers c JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.identifier
WHERE p.name LIKE '%DVD%' AND oi.order_date BETWEEN '1/1/2000' AND '31/12/2000' AND o.channel='Internet'
ORDER BY c.name;

--------------------------------------------------------------------------------DHMIOURGIA TWN EYRETHRIWN GIA BELTISTOPOIHSH TOY QUERIE
CREATE INDEX pidentifier_idx ON products(identifier);
CREATE INDEX pname_idx ON products(name);
CREATE INDEX oiproductid_idx ON order_items(product_id);

/*
DOKIMASTHKAN POLLOI SYNDIASMOI ALLA DEN EGINE KAMIA KALYTERH EKTELESH TOY QUERIE

CREATE INDEX cname_idx ON customers(name);
CREATE INDEX oiamount_idx ON order_items(amount);
CREATE INDEX oiquantity ON order_items(quantity);
CREATE INDEX cid_idx ON customers(id);
CREATE INDEX ocustomerid_idx ON orders(customer_id);
CREATE INDEX oid_idx ON orders(id);
CREATE INDEX oiorderid_idx ON order_items(order_id);
CREATE INDEX oiorderdate_idx ON order_items(order_date);
CREATE INDEX ochannel_idx ON orders(channel);

DROP INDEX cname_idx;
DROP INDEX oiamount_idx;
DROP INDEX oiquantity;
DROP INDEX cid_idx;
DROP INDEX ocustomerid_idx;
DROP INDEX oid_idx;
DROP INDEX oiorderid_idx;
DROP INDEX oiorderdate_idx;
DROP INDEX ochannel_idx;
*/

--------------------------------------------------------------------------------DIAGRAFH TWN PINAKWN KAI TN EYRETHRIVN
DROP INDEX pidentifier_idx;
DROP INDEX pname_idx;
DROP INDEX oiproductid_idx;

DROP TABLE customers;
DROP TABLE products;
DROP TABLE orders;
DROP TABLE order_items;