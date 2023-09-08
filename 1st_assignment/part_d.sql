ALTER SESSION SET nls_date_format = 'DD--MM--YYYY';

--------------------------------------------------------------------------------DHMIOURGIA PINAKWN POY XREIAZONTAI STO ERWTHMA
CREATE TABLE customers AS select * FROM xsales.customers;
CREATE TABLE products AS select * FROM xsales.products;
CREATE TABLE orders AS select * FROM xsales.orders;
CREATE TABLE order_items AS select * FROM xsales.order_items;

CREATE INDEX pidentifier_idx ON products(identifier);
CREATE INDEX pname_idx ON products(name);
CREATE INDEX oiproductid_idx ON order_items(product_id);

--------------------------------------------------------------------------------EYRESH MEGETHOYS KATHE SXESHS KAI EYRETHRIOY
SELECT segment_name, bytes / 1024 / 1024 MB 
FROM user_segments 
WHERE segment_type = 'TABLE' AND segment_name = 'CUSTOMERS';

SELECT segment_name, bytes / 1024 / 1024 MB 
FROM user_segments 
WHERE segment_type = 'TABLE' AND segment_name = 'PRODUCTS';

SELECT segment_name, bytes / 1024 / 1024 MB 
FROM user_segments 
WHERE segment_type = 'TABLE' AND segment_name = 'ORDERS';

SELECT segment_name, bytes / 1024 / 1024 MB 
FROM user_segments 
WHERE segment_type = 'TABLE' AND segment_name = 'ORDER_ITEMS';

SELECT segment_name, bytes / 1024 / 1024 MB 
FROM user_segments
WHERE segment_type = 'INDEX' AND segment_name = 'PIDENTIFIER_IDX';

SELECT segment_name, bytes / 1024 / 1024 MB 
FROM user_segments
WHERE segment_type = 'INDEX' AND segment_name = 'PNAME_IDX';

SELECT segment_name, bytes / 1024 / 1024 MB 
FROM user_segments
WHERE segment_type = 'INDEX' AND segment_name = 'OIPRODUCTID_IDX';

--------------------------------------------------------------------------------DIAGRAFH TWN PINAKWN KAI TVN EYRETHRIWN
DROP INDEX pidentifier_idx;
DROP INDEX pname_idx;
DROP INDEX oiproductid_idx;

DROP TABLE customers;
DROP TABLE products;
DROP TABLE orders;
DROP TABLE order_items;