DROP TABLE customer;
DROP TABLE "order";
DROP TABLE employee;
DROP TABLE cart;
DROP TABLE product;
DROP TABLE supplier;
DROP TABLE review;

CREATE TABLE customer (
    customer_id   INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY NOT NULL,
    name          VARCHAR(42) NOT NULL,
    surname       VARCHAR(42) NOT NULL,
    birthdate     DATE,
    password      VARCHAR(256) NOT NULL
        CHECK(REGEXP_LIKE(password, '^[a-zA-Z0-9.!#$%&*+-/=?^_`{|}~]*$', 'i')),
    street        VARCHAR(42) NOT NULL,
    city          VARCHAR(42) NOT NULL,
    zip_code      VARCHAR(42) NOT NULL,
    payment_info  INT NOT NULL
        CHECK(MOD(payment_info, 16) = 0),
    telephone_num INT NOT NULL,
    email         VARCHAR(256) NOT NULL
        CHECK(REGEXP_LIKE(email, '^[a-zA-Z0-9.-]*@[a-zA-Z0-9-]+.[a-zA-Z]*$', 'i'))
);

CREATE TABLE "order" (
    order_id      INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY NOT NULL,
    order_date    DATE,
    status        VARCHAR(42) NOT NULL,
    invoice       VARCHAR(256) NOT NULL
);

CREATE TABLE employee (
    employee_id   INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY NOT NULL,
    name          VARCHAR(42) NOT NULL,
    surname       VARCHAR(42) NOT NULL,
    password      VARCHAR(256) NOT NULL
        CHECK(REGEXP_LIKE(password, '^[a-zA-Z0-9.!#$%&*+-/=?^_`{|}~]*$', 'i'))
);

CREATE TABLE cart (
    cart_id       INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY NOT NULL,
    products      VARCHAR(256) DEFAULT NULL,
    total_price   INT DEFAULT 0
        CHECK(total_price >= 0)
);

CREATE TABLE product (
    product_id    INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY NOT NULL,
    product_name  VARCHAR(42) NOT NULL,
    description   VARCHAR(256) NOT NULL,
    price         INT(42) NOT NULL
        CHECK(price <= 999 AND price >= 0)
);

CREATE TABLE supplier (
    supplier_id   INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY NOT NULL,
    supplier_name VARCHAR(42) NOT NULL,
    street        VARCHAR(42) NOT NULL,
    city          VARCHAR(42) NOT NULL,
    zip_code      VARCHAR(42) NOT NULL,
    company_ID    VARCHAR(42) NOT NULL,
    VAT_ID        VARCHAR(42) NOT NULL
        CHECK(REGEXP_LIKE(VAT_ID, '^[CZ]{2}[0-9]{9,10}$', 'i'))
);

CREATE TABLE review (
     review_num   INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
     review_date  DATE,
     rating       INT,
     content      VARCHAR(256) NOT NULL
);

INSERT INTO customer VALUES('7605071500', 'Michael', 'Murphy', TO_DATE('07/05/1976', 'DD/MM/YYYY'), '11002003001', '9 Whitney','Smithtown', '117817', '4475219355076478', '12024561111', 'murphy@gmail.com');
INSERT INTO customer VALUES('9812241235', 'Daniel', 'Miller', TO_DATE('12/10/1999', 'DD/MM/YYYY'), 'QWJmskE211', 'Corney 2/3','Bright', '45662', '3575129315066200', '12124567890', 'miller@gmail.com');
INSERT INTO customer VALUES('750905192', 'Emily', 'Jones', TO_DATE('24/03/2000', 'DD/MM/YYYY'), 'iD0#Tk#0W', '12 Chantilly','Woodland', '8939', '2371219399056474', '4204829485826', 'jones@gmail.com');
INSERT INTO customer VALUES('895913548', 'James', 'Taylor', TO_DATE('01/01/1991', 'DD/MM/YYYY'), '2j2@ks2l', 'Blackhorse Grove 118','London', '21345', '1232933677494098', '323545000424', 'taylor@gmail.com');

INSERT INTO "order" VALUES(1, TO_DATE('12/03/2022', 'DD/MM/YYYY'), 'DELIVERED', 'SUKA');
INSERT INTO "order" VALUES(2, TO_DATE('17/03/2022', 'DD/MM/YYYY'), 'DELIVERED', 'SUKA');
INSERT INTO "order" VALUES(3, TO_DATE('21/03/2022', 'DD/MM/YYYY'), 'DELIVERED', 'SUKA');
INSERT INTO "order" VALUES(4, TO_DATE('02/04/2022', 'DD/MM/YYYY'), 'DELIVERING', 'SUKA');
INSERT INTO "order" VALUES(5, TO_DATE('04/03/2022', 'DD/MM/YYYY'), 'IN PROGRESS', 'SUKA');

INSERT INTO employee VALUES(1, 'Jack', 'Wilson', 'DOsmi42@s');
INSERT INTO employee VALUES(2, 'Sophie', 'Rodriguez', 'qkjw11234j');

INSERT INTO cart VALUES(1, '', '');
INSERT INTO cart VALUES(2, '1 Black crayon Bulk, 2x A4 sketchbook Conda', '31$');

INSERT INTO product VALUES(1, 'Black crayon Bulk', 'Black Long-Lasting Marking Crayon', '7$');
INSERT INTO product VALUES(2, 'White crayon Bulk', 'White Long-Lasting Marking Crayon', '7$');
INSERT INTO product VALUES(3, 'Red crayon Bulk', 'Red Long-Lasting Marking Crayon', '7$');
INSERT INTO product VALUES(4, 'A4 sketchbook Conda', 'A4 Heavyweight Hardcover Sketchbook, Ideal for Kids & Adults', '12$');
INSERT INTO product VALUES(5, 'A6 sketchbook Conda', 'A3 Heavyweight Hardcover Sketchbook, Ideal for Kids & Adults', '9$');

INSERT INTO supplier VALUES(1, 'Office SUP s.r.o', '59a Commercial St', 'Rothwell', '83294', '09354970', 'CZ123456789');

INSERT INTO review VALUES(1, TO_DATE('22/03/2022', 'DD/MM/YYYY'), '5/5', 'Thanks for awesome A4 sketchbook!');
