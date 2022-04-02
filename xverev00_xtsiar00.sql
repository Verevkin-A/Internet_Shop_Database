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
	telephone_num NUMERIC(15, 0) NOT NULL
		CHECK (telephone_num > 99999999),
	email          VARCHAR(256) UNIQUE NOT NULL
		CHECK (REGEXP_LIKE (email, '^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-]+$'))
);

--Create cart table
CREATE TABLE cart (
	cart_id        INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	products       VARCHAR(256) DEFAULT NULL,    --TODO remove?
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
	employee       INT DEFAULT NULL,     --another employee can be assigned on order
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
	--foreign keys
	supplier       INT NOT NULL,
	employee       INT DEFAULT NULL,     --another employee can be assigned on product
    CONSTRAINT product_supplier_foreign
        FOREIGN KEY (supplier)
        REFERENCES supplier (supplier_id)
        ON DELETE CASCADE,
    CONSTRAINT product_employee_foreign
        FOREIGN KEY (employee)
        REFERENCES employee (employee_id)
        ON DELETE SET NULL
);

CREATE TABLE crayon (
	product_id     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	type           VARCHAR(70) NOT NULL,
	length         INT NOT NULL,
	amount         INT NOT NULL
		CHECK (amount > 0),
	color          VARCHAR(70) NOT NULL	
);

CREATE TABLE sketchbook (
	product_id     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	grammage       INT NOT NULL,
	size           VARCHAR(70),
	num_of_pages   INT NOT NULL
		CHECK (num_of_pages > 0),
	paper_strength INT NOT NULL
);



--Create review table
CREATE TABLE review (
	review_num     INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
	review_date    DATE DEFAULT CURRENT_DATE NOT NULL,
	rating         SMALLINT NOT NULL
		CHECK (rating >= 0 AND rating <= 5),
	content        VARCHAR(256),
	--foreign keys
	customer       INT DEFAULT NULL, --review staying if user is deleted
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
	CONSTRAINT order_product_primary
		PRIMARY KEY ("order", product),
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

INSERT INTO cart(products, total_price, customer) VALUES(DEFAULT, DEFAULT, 1);
INSERT INTO cart(products, total_price, customer) VALUES('1 Black crayon Bulk, 2x A4 sketchbook Conda', 31, 2);
INSERT INTO cart(products, total_price, customer) VALUES('1 White crayon Bulk', 7, 3);
INSERT INTO cart(products, total_price, customer) VALUES('1x A4 sketchbook Conda', 12, 4);

INSERT INTO employee(name, surname, password) VALUES('Jack', 'Wilson', 'DOsmi42@s');
INSERT INTO employee(name, surname, password) VALUES('Sophie', 'Rodriguez', 'qkjw11234j');

INSERT INTO "ORDER"(invoice, employee, customer) VALUES(2491839, 2, 1);
INSERT INTO "ORDER"(invoice, employee, customer) VALUES(202021166, 1, 1);
INSERT INTO "ORDER"(status, invoice, employee, customer) VALUES('PROCESSED', 03000852021, 1, 2);
INSERT INTO "ORDER"(status, invoice, employee, customer) VALUES('DELIVERING', 1900001, 1, 3);
INSERT INTO "ORDER"(status, invoice, employee, customer) VALUES('DELIVERED', 1352, 2, 4);

INSERT INTO supplier(supplier_name, street, city, zip_code, company_ID, VAT_ID)
VALUES('Office SUP s.r.o', '59a Commercial St', 'Rothwell', '83294', '09354970', 'CZ123456789');
INSERT INTO supplier(supplier_name, street, city, zip_code, company_ID, VAT_ID)
VALUES('BestSupplies s.r.o', '23b Supplies St', 'Bestcity', '42000', '83720420', 'CZ847205730');

INSERT INTO product(product_name, description, price, supplier, employee)
VALUES('Black crayon Bulk', 'Black Long-Lasting Marking Crayon', 7, 2, 1);
INSERT INTO product(product_name, description, price, supplier, employee)
VALUES('White crayon Bulk', 'White Long-Lasting Marking Crayon', 7, 2, 2);
INSERT INTO product(product_name, description, price, supplier, employee)
VALUES('Red crayon Bulk', 'Red Long-Lasting Marking Crayon', 7, 1, 1);
INSERT INTO product(product_name, description, price, supplier, employee)
VALUES('A4 sketchbook Conda', 'A4 Heavyweight Hardcover Sketchbook, Ideal for Kids & Adults', 12, 1, 2);
INSERT INTO product (product_name, description, price, supplier, employee)
VALUES('A6 sketchbook Conda', 'A3 Heavyweight Hardcover Sketchbook, Ideal for Kids & Adults', 9, 2, 1);

INSERT INTO review(rating, content, customer, product)
VALUES(5, 'Thanks for awesome A4 sketchbook!', 2, 3);
INSERT INTO review(rating, content, customer, product)
VALUES(2, NULL, 4, 1);

INSERT INTO cart_product(cart, product) VALUES (1, 1);
INSERT INTO cart_product(cart, product) VALUES (1, 3);
INSERT INTO cart_product(cart, product) VALUES (2, 3);
INSERT INTO cart_product(cart, product) VALUES (2, 4);

INSERT INTO order_product("order", product) VALUES (3, 1);
INSERT INTO order_product("order", product) VALUES (3, 3);
INSERT INTO order_product("order", product) VALUES (2, 3);
INSERT INTO order_product("order", product) VALUES (2, 4);
