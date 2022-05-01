-- Internet shop with pencils and sketchbooks
-- Authors: Aleksandr Verevkin (xverev00)
--          Ivan Tsiareshkin (xtsiar00)

--Remove existing tables
DROP TABLE customer CASCADE CONSTRAINTS PURGE;
DROP TABLE "ORDER" CASCADE CONSTRAINTS PURGE;
DROP TABLE employee CASCADE CONSTRAINTS PURGE;
DROP TABLE cart CASCADE CONSTRAINTS PURGE;
DROP TABLE product CASCADE CONSTRAINTS PURGE;
DROP TABLE supplier CASCADE CONSTRAINTS PURGE;
DROP TABLE review CASCADE CONSTRAINTS PURGE;
DROP TABLE cart_product CASCADE CONSTRAINTS PURGE;
DROP TABLE order_product CASCADE CONSTRAINTS PURGE;

--Create customer table
CREATE TABLE customer (
	customer_id    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name           VARCHAR(70) NOT NULL,
	surname        VARCHAR(70) NOT NULL,
	birthdate      DATE NOT NULL,
	password       VARCHAR(256) NOT NULL
		CHECK (REGEXP_LIKE (password, '^[a-zA-Z0-9.!#$@%&*+-\\/=?^_`{|}~]{8,}$')),
	street         VARCHAR(70) NOT NULL,
	city 		   VARCHAR(70) NOT NULL,
	zip_code       VARCHAR(70) NOT NULL,
	payment_info   NUMBER(16, 0) NOT NULL
		CHECK (payment_info > 999999999999999),
	telephone_num  NUMERIC(15, 0) NOT NULL
		CHECK (telephone_num > 99999999),
	email          VARCHAR(256) UNIQUE NOT NULL
		CHECK (REGEXP_LIKE (email, '^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-]+$'))
);

--Create cart table
CREATE TABLE cart (
	cart_id        INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	total_price    INT DEFAULT 0 NOT NULL
		CHECK(total_price >= 0),
    -- foreign keys
    customer       INT NOT NULL,     --cart can't exist without customer
    CONSTRAINT cart_customer_foreign
        FOREIGN KEY (customer)
        REFERENCES customer (customer_id)
        ON DELETE CASCADE
);

--Create employee table
CREATE TABLE employee (
    employee_id    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name           VARCHAR(70) NOT NULL,
    surname        VARCHAR(70) NOT NULL,
    password       VARCHAR(256) NOT NULL
		CHECK (REGEXP_LIKE (password, '^[a-zA-Z0-9.!#$@%&*+-\\/=?^_`{|}~]{8,}$'))
);

--Create order table
CREATE TABLE "ORDER" (
	order_id       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	order_date     DATE DEFAULT CURRENT_DATE NOT NULL,
	status         VARCHAR(70) DEFAULT 'PROCESSING' NOT NULL,
	invoice        INT UNIQUE NOT NULL
		CHECK (invoice > 0),
	--foreign keys
	employee       INT DEFAULT NULL,     --another employee can be assigned on the order
	customer       INT NOT NULL,
	CONSTRAINT order_employee_foreign
        FOREIGN KEY (employee)
        REFERENCES employee (employee_id)
        ON DELETE SET NULL,
    CONSTRAINT order_customer_foreign
        FOREIGN KEY (customer)
        REFERENCES customer (customer_id)
        ON DELETE CASCADE
);

--Create supplier table
CREATE TABLE supplier (
    supplier_id    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    supplier_name  VARCHAR(70) NOT NULL,
    street         VARCHAR(70) NOT NULL,
    city           VARCHAR(70) NOT NULL,
    zip_code       VARCHAR(70) NOT NULL,
    company_ID     VARCHAR(70) UNIQUE NOT NULL,
    VAT_ID         VARCHAR(70) UNIQUE NOT NULL
        CHECK (REGEXP_LIKE (VAT_ID, '^[CZ]{2}[0-9]{9,10}$', 'i'))
);


--Create product table
CREATE TABLE product (
	product_id     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	product_name   VARCHAR(70) NOT NULL,
	description    VARCHAR(256) NOT NULL,
	price          SMALLINT NOT NULL
		CHECK (price >= 0),
	type           VARCHAR(10) NOT NULL
	    CHECK (type = 'crayon' or type = 'sketchbook'),
	-- crayon attributes
	crayon_type    VARCHAR(70) DEFAULT NULL,
	length         INT DEFAULT NULL
	    CHECK (length > 0),
	amount         INT DEFAULT NULL
		CHECK (amount > 0),
	color          VARCHAR(70) DEFAULT NULL,
	-- sketchbook attributes
	grammage       INT DEFAULT NULL
	    CHECK (grammage > 0),
	"size"         VARCHAR(70) DEFAULT NULL,
	num_of_pages   INT DEFAULT NULL
		CHECK (num_of_pages > 0),
	density INT DEFAULT NULL
	    CHECK (density > 0),

	--foreign keys
	supplier       INT NOT NULL,
	employee       INT DEFAULT NULL,     --another employee can be assigned on the product
    CONSTRAINT product_supplier_foreign
        FOREIGN KEY (supplier)
        REFERENCES supplier (supplier_id)
        ON DELETE CASCADE,
    CONSTRAINT product_employee_foreign
        FOREIGN KEY (employee)
        REFERENCES employee (employee_id)
        ON DELETE SET NULL
);

--Create review table
CREATE TABLE review (
	review_num     INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
	review_date    DATE DEFAULT CURRENT_DATE NOT NULL,
	rating         SMALLINT NOT NULL
		CHECK (rating >= 0 AND rating <= 5),
	content        VARCHAR(256),
	--foreign keys
	customer       INT DEFAULT NULL, --review staying if the user was deleted
	product        INT NOT NULL,
	CONSTRAINT review_customer_foreign
		FOREIGN KEY (customer)
		REFERENCES customer (customer_id)
		ON DELETE SET NULL,
	CONSTRAINT review_product_foreign
		FOREIGN KEY (product)
		REFERENCES product (product_id)
		ON DELETE CASCADE
);

--Cart-Product relation table
CREATE TABLE cart_product (
	cart           INT NOT NULL,
	product        INT NOT NULL,
	CONSTRAINT cart_product_primary
		PRIMARY KEY (cart, product),
	CONSTRAINT cart_product_cart_foreign
		FOREIGN KEY (cart)
		REFERENCES cart (cart_id)
        ON DELETE CASCADE,
	CONSTRAINT cart_product_product_foreign
		FOREIGN KEY (product)
		REFERENCES product (product_id)
        ON DELETE CASCADE
);

--Order-Product relation table
CREATE TABLE order_product (
	"order"        INT NOT NULL,
	product        INT NOT NULL,
	CONSTRAINT order_product_order_foreign
		FOREIGN KEY ("order")
		REFERENCES "ORDER" (order_id)
		ON DELETE CASCADE,
	CONSTRAINT order_product_product_foreign
		FOREIGN KEY (product)
		REFERENCES product (product_id)
        ON DELETE CASCADE
);

--Insert values into created tables

INSERT INTO customer(name, surname, birthdate, password, street, city, zip_code, payment_info, telephone_num, email)
VALUES('Michael', 'Murphy', TO_DATE('07/05/1976', 'DD/MM/YYYY'), '11002003001', '9 Whitney', 'Smithtown', '117817',
       4475219355076478, 420702003322, 'murphy@gmail.com');
INSERT INTO customer(name, surname, birthdate, password, street, city, zip_code, payment_info, telephone_num, email)
VALUES('Daniel', 'Miller', TO_DATE('12/10/1999', 'DD/MM/YYYY'), 'QWJmskE211', 'Corney 2/3','Bright', '45662',
       3575129315066200, 420774066577, 'miller@gmail.com');
INSERT INTO customer(name, surname, birthdate, password, street, city, zip_code, payment_info, telephone_num, email)
VALUES('Emily', 'Jones', TO_DATE('24/03/2000', 'DD/MM/YYYY'), 'iD0#Tk#0W', '12 Chantilly','Woodland', '8939',
       2371219399056474, 4204829485826, 'jones@gmail.com');
INSERT INTO customer(name, surname, birthdate, password, street, city, zip_code, payment_info, telephone_num, email)
VALUES('James', 'Taylor', TO_DATE('01/01/1991', 'DD/MM/YYYY'), '2j2@ks2l', 'Blackhorse Grove 118','London', '21345',
       1232933677494098, 420601228345, 'taylor@gmail.com');

INSERT INTO cart(total_price, customer) VALUES(DEFAULT, 1);
INSERT INTO cart(total_price, customer) VALUES(31, 2);
INSERT INTO cart(total_price, customer) VALUES(7, 3);
INSERT INTO cart(total_price, customer) VALUES(12, 4);

INSERT INTO employee(name, surname, password) VALUES('Jack', 'Wilson', 'DOsmi42@s');
INSERT INTO employee(name, surname, password) VALUES('Sophie', 'Rodriguez', 'qkjw11234j');
INSERT INTO employee(name, surname, password) VALUES('Aleksandr', 'Verevkin', 'password123');

INSERT INTO "ORDER"(invoice, employee, customer) VALUES(2491839, 2, 1);
INSERT INTO "ORDER"(status, invoice, employee, customer) VALUES('DELIVERING', 202021166, 2, 1);
INSERT INTO "ORDER"(status, invoice, employee, customer) VALUES('PROCESSED', 03000852021, 1, 2);
INSERT INTO "ORDER"(status, invoice, employee, customer) VALUES('DELIVERING', 1900001, 1, 3);
INSERT INTO "ORDER"(status, invoice, employee, customer) VALUES('DELIVERED', 1352, 2, 4);

INSERT INTO supplier(supplier_name, street, city, zip_code, company_ID, VAT_ID)
VALUES('Office SUP s.r.o', '59a Commercial St', 'Rothwell', '83294', '09354970', 'CZ123456789');
INSERT INTO supplier(supplier_name, street, city, zip_code, company_ID, VAT_ID)
VALUES('BestSupplies s.r.o', '23b Supplies St', 'Bestcity', '42000', '83720420', 'CZ847205730');
INSERT INTO supplier(supplier_name, street, city, zip_code, company_ID, VAT_ID)
VALUES('PencilDoctor s.r.o', '9b Main St', 'Bestcity', '42012', '45129362', 'CZ843041962');

INSERT INTO product(product_name, description, price, type, crayon_type, length, amount, color, supplier, employee)
VALUES('Black crayon Bulk', 'Black Long-Lasting Marking Crayon', 7, 'crayon', 'Long-Lasting', 10, 5, 'black', 2, 1);
INSERT INTO product(product_name, description, price, type, crayon_type, length, amount, color, supplier, employee)
VALUES('White crayon Bulk', 'White Long-Lasting Marking Crayon', 7, 'crayon', 'Long-Lasting', 10, 5, 'white', 2, 2);
INSERT INTO product(product_name, description, price, type, crayon_type, length, amount, color, supplier, employee)
VALUES('Red crayon Bulk', 'Red Long-Lasting Marking Crayon', 7, 'crayon', 'Long-Lasting', 10, 5, 'red', 1, 1);
INSERT INTO product(product_name, description, price, type, grammage, "size", num_of_pages, density, supplier, employee)
VALUES('A4 sketchbook Conda', 'A4 Heavyweight Hardcover Sketchbook, Ideal for Kids & Adults', 12, 'sketchbook', 60, 'Big', 32, 1200, 1, 2);
INSERT INTO product(product_name, description, price, type, grammage, "size", num_of_pages, density, supplier, employee)
VALUES('A6 sketchbook Conda', 'A3 Heavyweight Hardcover Sketchbook, Ideal for Kids & Adults', 9, 'sketchbook', 30, 'Medium', 32, 1000, 2, 1);

INSERT INTO review(rating, content, customer, product)
VALUES(5, 'Thanks for awesome A4 sketchbook!', 2, 4);
INSERT INTO review(rating, content, customer, product)
VALUES(2, NULL, 4, 1);
INSERT INTO review(rating, content, customer, product)
VALUES(5, 'paper is so soft. love it.', 4, 4);

INSERT INTO cart_product(cart, product) VALUES (1, 1);
INSERT INTO cart_product(cart, product) VALUES (1, 3);
INSERT INTO cart_product(cart, product) VALUES (2, 3);
INSERT INTO cart_product(cart, product) VALUES (2, 4);

INSERT INTO order_product("order", product) VALUES (4, 1);
INSERT INTO order_product("order", product) VALUES (4, 3);
INSERT INTO order_product("order", product) VALUES (2, 3);
INSERT INTO order_product("order", product) VALUES (2, 4);

-- TASK #4 --

-- TRIGGERS --

-- Recounts total cart price
CREATE OR REPLACE TRIGGER update_cart_price
    BEFORE INSERT ON cart_product
    FOR EACH ROW
DECLARE
    cart_total INT;
BEGIN
    SELECT SUM(price) INTO cart_total FROM cart_product CP JOIN
        cart C on CP.cart = C.cart_id JOIN
        product P on CP.product = P.product_id
        WHERE C.cart_id = :NEW.cart
        GROUP BY C.cart_id;
    UPDATE cart
        SET total_price = cart_total + (SELECT price FROM product WHERE product_id = :NEW.product)
    WHERE cart_id = :NEW.cart;
END;
-- total price of cart is updating after inserting new products
INSERT INTO cart_product(cart, product) VALUES (1, 5);
SELECT total_price FROM cart WHERE customer = 1;
INSERT INTO cart_product(cart, product) VALUES (1, 2);
SELECT total_price FROM cart WHERE customer = 1;

-- Checks if user already have review on reviewed product
CREATE OR REPLACE TRIGGER check_duplicate_review
    BEFORE INSERT ON review
    FOR EACH ROW
DECLARE
    review_cnt INT;
BEGIN
    SELECT COUNT(*) INTO review_cnt FROM review
        WHERE customer = :NEW.customer AND product = :NEW.product;
    IF review_cnt <> 0 THEN
        RAISE_APPLICATION_ERROR(-20069, 'Review from this user already exists');
    END IF;
END;

-- creating review on product
INSERT INTO review(rating, content, customer, product)
VALUES(4, 'nice crayon', 4, 3);
-- error on attempt of creating new review on the same product (uncomment for demonstration)
-- INSERT INTO review(rating, content, customer, product)
-- VALUES(5, 'good crayon', 4, 3);

-- PROCEDURES --

-- prints out currently delivering orders and responsible for them employees
CREATE OR REPLACE PROCEDURE delivering_orders
AS
    CURSOR order_cur IS SELECT * FROM "ORDER";
    ord "ORDER"%ROWTYPE;
    emp employee%ROWTYPE;
    products_cnt INT;
    empty_delivery EXCEPTION;
    PRAGMA exception_init ( empty_delivery, -20001 );
BEGIN
    OPEN order_cur;
    LOOP
        FETCH order_cur INTO ord;
        EXIT WHEN order_cur%NOTFOUND;

        IF ord.status = 'DELIVERING' THEN
            SELECT * INTO emp FROM employee WHERE employee_id = ord.employee;
            SELECT COUNT(*) INTO products_cnt FROM order_product WHERE "order" = ord.order_id;
            IF products_cnt = 0 THEN
                RAISE empty_delivery;
            END IF;
            -- print summarized info
            DBMS_OUTPUT.PUT_LINE('ORDER DATE: ' || ord.order_date || ', ' ||
                                 'RESPONSIBLE: ' || emp.name || ' ' || emp.surname || ', ' ||
                                 'PRODUCTS AMOUNT: ' || products_cnt);
        END IF;
    END LOOP;
    CLOSE order_cur;
    EXCEPTION WHEN empty_delivery THEN
    BEGIN
        DBMS_OUTPUT.put_line('Empty delivery found! ' ||
                             'RESPONSIBLE: ' || emp.name || ' ' || emp.surname || ', ' ||
                             'ORDER ID: ' || ord.order_id);
    END;
END;
-- procedure execution
BEGIN
    delivering_orders;
END;

-- takes product name as argument and prints out it's supplier
CREATE OR REPLACE PROCEDURE product_supplier (p_name IN VARCHAR)
AS
    sup_id INT;
    sup_name VARCHAR(70);
BEGIN
    SELECT supplier INTO sup_id FROM product WHERE product_name = p_name;
    SELECT supplier_name INTO sup_name FROM supplier WHERE supplier_id = sup_id;
    DBMS_OUTPUT.put_line('SUPPLIER: ' || sup_name);
END;

BEGIN
    product_supplier ('A4 sketchbook Conda');
END;

-- EXPLAIN PLAN --

DROP INDEX product_indentif;

-- amount of reviews on each product
EXPLAIN PLAN FOR
    SELECT P.product_id, P.product_name, COUNT(r.review_num) number_of_reviews FROM product P
    LEFT JOIN review R on P.product_id = R.product
    GROUP BY P.product_id,
             P.product_name
    ORDER BY number_of_reviews DESC,
             P.product_id;
-- show executed operations WITHOUT index
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());

-- create index for product identification columns, for faster searching
CREATE INDEX product_indentif ON product(product_id, product_name);
-- evaluation of the same select, now with index
EXPLAIN PLAN FOR
    SELECT P.product_id, P.product_name, COUNT(r.review_num) number_of_reviews FROM product P
    LEFT JOIN review R on P.product_id = R.product
    GROUP BY P.product_id,
             P.product_name
    ORDER BY number_of_reviews DESC,
             P.product_id;
-- show executed operations WITH index
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());

-- PERMISSIONS --

GRANT ALL ON customer TO XTSIAR00;
GRANT ALL ON "ORDER" TO XTSIAR00;
GRANT ALL ON employee TO XTSIAR00;
GRANT ALL ON cart TO XTSIAR00;
GRANT ALL ON product TO XTSIAR00;
GRANT ALL ON supplier TO XTSIAR00;
GRANT ALL ON review TO XTSIAR00;
GRANT ALL ON cart_product TO XTSIAR00;
GRANT ALL ON order_product TO XTSIAR00;

GRANT EXECUTE ON delivering_orders TO XTSIAR00;
GRANT EXECUTE ON product_supplier TO XTSIAR00;

-- MATERIALIZED VIEW --
DROP MATERIALIZED VIEW products_suppliers;

-- Products and their suppliers
-- called and used by the second member of the team
CREATE MATERIALIZED VIEW products_suppliers
    BUILD IMMEDIATE AS
        SELECT P.product_id,
           P.product_name,
           S.supplier_id,
           S.supplier_name FROM supplier S
        JOIN product P on S.supplier_id = P.supplier
        ORDER BY P.product_id;

SELECT * FROM products_suppliers;
-- add new product
INSERT INTO product(product_name, description, price, type, crayon_type, length, amount, color, supplier, employee)
VALUES('Red long crayon', 'Red Marking Crayon', 5, 'crayon', 'Marking', 9, 5, 'red', 3, 2);
COMMIT;
-- data doesn't change
SELECT * FROM products_suppliers;
