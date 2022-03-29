--Remove existing tables
-- DROP TABLE CUSTOMER CASCADE CONSTRAINTS PURGE;
-- DROP TABLE "ORDER" CASCADE CONSTRAINTS PURGE;
-- DROP TABLE employee CASCADE CONSTRAINTS PURGE;
-- DROP TABLE cart CASCADE CONSTRAINTS PURGE;
-- DROP TABLE product CASCADE CONSTRAINTS PURGE;
-- DROP TABLE supplier CASCADE CONSTRAINTS PURGE;
-- DROP TABLE review CASCADE CONSTRAINTS PURGE;

--Create customer table
CREATE TABLE customer (
    customer_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name          VARCHAR(70) NOT NULL,
    surname       VARCHAR(70) NOT NULL,
    birthdate     DATE NOT NULL,
    password      VARCHAR(256) NOT NULL
        CHECK (REGEXP_LIKE (password, '^[a-z0-9.!#$@%&*+-/=?^_`{|}~]*$', 'i')), -- remove A-Z because of 'i'
    street        VARCHAR(70) NOT NULL,
    city          VARCHAR(70) NOT NULL,
    zip_code      VARCHAR(70) NOT NULL,
    payment_info  NUMBER(16, 0) NOT NULL
        CHECK (payment_info > 999999999999999),
    telephone_num INT NOT NULL,
    email         VARCHAR(256) NOT NULL
        CHECK (REGEXP_LIKE (email, '^[a-z0-9.-]*@[a-z0-9-]+.[a-z]*$', 'i')) -- remove A-Z because of 'i'
);

--Create order table
CREATE TABLE "ORDER" (
    order_id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_date    DATE NOT NULL,
    status        VARCHAR(70) NOT NULL,
    invoice       VARCHAR(256) NOT NULL
);

--Create employee table
CREATE TABLE employee (
    employee_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name          VARCHAR(70) NOT NULL,
    surname       VARCHAR(70) NOT NULL,
    password      VARCHAR(256) NOT NULL
        CHECK (REGEXP_LIKE (password, '^[a-z0-9.!#$@%&*+-/=?^_`{|}~]*$', 'i'))  -- remove A-Z because of 'i'
);

--Create cart table
CREATE TABLE cart (
    cart_id       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    products      VARCHAR(256) DEFAULT NULL,
    total_price   INT DEFAULT 0 NOT NULL
        CHECK(total_price >= 0)
);

--Create product table
CREATE TABLE product (
    product_id    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_name  VARCHAR(70) NOT NULL,
    description   VARCHAR(256) NOT NULL,
    price         NUMERIC(3, 0) NOT NULL
        CHECK (price >= 0)
);

--Create supplier table
CREATE TABLE supplier (
    supplier_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    supplier_name VARCHAR(70) NOT NULL,
    street        VARCHAR(70) NOT NULL,
    city          VARCHAR(70) NOT NULL,
    zip_code      VARCHAR(70) NOT NULL,
    company_ID    VARCHAR(70) NOT NULL,
    VAT_ID        VARCHAR(70) NOT NULL
        CHECK (REGEXP_LIKE (VAT_ID, '^[CZ]{2}[0-9]{9,10}$', 'i'))
);

--Create review table
CREATE TABLE review (
     review_num   INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
     review_date  DATE NOT NULL,
     rating       INT NOT NULL
                    CHECK (rating >= 0 AND rating <= 5),
     content      VARCHAR(256)
);

--Insert values into created tables
INSERT INTO customer(name, surname, birthdate, password, street, city, zip_code, payment_info, telephone_num, email)
VALUES('Michael', 'Murphy', TO_DATE('07/05/1976', 'DD/MM/YYYY'), '11002003001', '9 Whitney', 'Smithtown', '117817',
       4475219355076478, 12024561111, 'murphy@gmail.com');
INSERT INTO customer(name, surname, birthdate, password, street, city, zip_code, payment_info, telephone_num, email)
VALUES('Daniel', 'Miller', TO_DATE('12/10/1999', 'DD/MM/YYYY'), 'QWJmskE211', 'Corney 2/3','Bright', '45662',
       3575129315066200, 12124567890, 'miller@gmail.com');
INSERT INTO customer(name, surname, birthdate, password, street, city, zip_code, payment_info, telephone_num, email)
VALUES('Emily', 'Jones', TO_DATE('24/03/2000', 'DD/MM/YYYY'), 'iD0#Tk#0W', '12 Chantilly','Woodland', '8939',
       2371219399056474, 4204829485826, 'jones@gmail.com');
INSERT INTO customer(name, surname, birthdate, password, street, city, zip_code, payment_info, telephone_num, email)
VALUES('James', 'Taylor', TO_DATE('01/01/1991', 'DD/MM/YYYY'), '2j2@ks2l', 'Blackhorse Grove 118','London', '21345',
       1232933677494098, 323545000424, 'taylor@gmail.com');
-- TODO invoice values?
INSERT INTO "ORDER"(order_date, status, invoice)
VALUES(TO_DATE('12/03/2022', 'DD/MM/YYYY'), 'DELIVERED', 'BAD');
INSERT INTO "ORDER"(order_date, status, invoice)
VALUES(TO_DATE('17/03/2022', 'DD/MM/YYYY'), 'DELIVERED', 'WORDS');
INSERT INTO "ORDER"(order_date, status, invoice)
VALUES(TO_DATE('21/03/2022', 'DD/MM/YYYY'), 'DELIVERED', 'ARE');
INSERT INTO "ORDER"(order_date, status, invoice)
VALUES(TO_DATE('02/04/2022', 'DD/MM/YYYY'), 'DELIVERING', 'NOT');
INSERT INTO "ORDER"(order_date, status, invoice)
VALUES(TO_DATE('04/03/2022', 'DD/MM/YYYY'), 'IN PROGRESS', 'SUPPORTED');

INSERT INTO employee(name, surname, password) VALUES('Jack', 'Wilson', 'DOsmi42@s');
INSERT INTO employee(name, surname, password) VALUES('Sophie', 'Rodriguez', 'qkjw11234j');

INSERT INTO cart(products, total_price) VALUES(DEFAULT, DEFAULT);
INSERT INTO cart(products, total_price) VALUES('1 Black crayon Bulk, 2x A4 sketchbook Conda', 31);

INSERT INTO product(product_name, description, price)
VALUES('Black crayon Bulk', 'Black Long-Lasting Marking Crayon', 7);
INSERT INTO product(product_name, description, price)
VALUES('White crayon Bulk', 'White Long-Lasting Marking Crayon', 7);
INSERT INTO product(product_name, description, price)
VALUES('Red crayon Bulk', 'Red Long-Lasting Marking Crayon', 7);
INSERT INTO product(product_name, description, price)
VALUES('A4 sketchbook Conda', 'A4 Heavyweight Hardcover Sketchbook, Ideal for Kids & Adults', 12);
INSERT INTO product (product_name, description, price)
VALUES('A6 sketchbook Conda', 'A3 Heavyweight Hardcover Sketchbook, Ideal for Kids & Adults', 9);

INSERT INTO supplier(supplier_name, street, city, zip_code, company_ID, VAT_ID)
 VALUES('Office SUP s.r.o', '59a Commercial St', 'Rothwell', '83294', '09354970', 'CZ123456789');

INSERT INTO review(review_date, rating, content)
VALUES(TO_DATE('22/03/2022', 'DD/MM/YYYY'), 5, 'Thanks for awesome A4 sketchbook!');
INSERT INTO review(review_date, rating, content)
VALUES(TO_DATE('22/03/2022', 'DD/MM/YYYY'), 2, NULL);
