CREATE TABLE customer (
    customer_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name          VARCHAR(70) NOT NULL,
    surname       VARCHAR(70) NOT NULL,
    birthdate     DATE DEFAULT NULL,
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

CREATE TABLE "ORDER" (
    order_id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_date    DATE NOT NULL,
    status        VARCHAR(70) NOT NULL,
    invoice       VARCHAR(256) NOT NULL
);

CREATE TABLE employee (
    employee_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name          VARCHAR(70) NOT NULL,
    surname       VARCHAR(70) NOT NULL,
    password      VARCHAR(256) NOT NULL
        CHECK (REGEXP_LIKE (password, '^[a-z0-9.!#$@%&*+-/=?^_`{|}~]*$', 'i'))  -- remove A-Z because of 'i'
);

CREATE TABLE cart (
    cart_id       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    products      VARCHAR(256) DEFAULT NULL,
    total_price   INT DEFAULT 0 NOT NULL
        CHECK(total_price >= 0)
);

CREATE TABLE product (
    product_id    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_name  VARCHAR(70) NOT NULL,
    description   VARCHAR(256) NOT NULL,
    price         NUMERIC(3, 0) NOT NULL
        CHECK (price >= 0)
);

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

CREATE TABLE review (
     review_num   INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
     review_date  DATE NOT NULL,
     rating       INT NOT NULL
                    CHECK (rating >= 0 AND rating <= 5),
     content      VARCHAR(256)
);

INSERT INTO customer VALUES(DEFAULT, 'Michael', 'Murphy', TO_DATE('07/05/1976', 'DD/MM/YYYY'), '11002003001',
                            '9 Whitney','Smithtown', '117817', 4475219355076478, 12024561111, 'murphy@gmail.com');
INSERT INTO customer VALUES(DEFAULT, 'Daniel', 'Miller', TO_DATE('12/10/1999', 'DD/MM/YYYY'), 'QWJmskE211',
                            'Corney 2/3','Bright', '45662', 3575129315066200, 12124567890, 'miller@gmail.com');
INSERT INTO customer VALUES(DEFAULT, 'Emily', 'Jones', TO_DATE('24/03/2000', 'DD/MM/YYYY'), 'iD0#Tk#0W',
                            '12 Chantilly','Woodland', '8939', 2371219399056474, 4204829485826, 'jones@gmail.com');
INSERT INTO customer VALUES(DEFAULT, 'James', 'Taylor', TO_DATE('01/01/1991', 'DD/MM/YYYY'), '2j2@ks2l',
                            'Blackhorse Grove 118','London', '21345', 1232933677494098, 323545000424, 'taylor@gmail.com');

INSERT INTO "ORDER" VALUES(DEFAULT, TO_DATE('12/03/2022', 'DD/MM/YYYY'), 'DELIVERED', 'BAD');     -- TODO invoice values?
INSERT INTO "ORDER" VALUES(DEFAULT, TO_DATE('17/03/2022', 'DD/MM/YYYY'), 'DELIVERED', 'WORDS');
INSERT INTO "ORDER" VALUES(DEFAULT, TO_DATE('21/03/2022', 'DD/MM/YYYY'), 'DELIVERED', 'ARE');
INSERT INTO "ORDER" VALUES(DEFAULT, TO_DATE('02/04/2022', 'DD/MM/YYYY'), 'DELIVERING', 'NOT');
INSERT INTO "ORDER" VALUES(DEFAULT, TO_DATE('04/03/2022', 'DD/MM/YYYY'), 'IN PROGRESS', 'SUPPORTED');

INSERT INTO employee VALUES(DEFAULT, 'Jack', 'Wilson', 'DOsmi42@s');
INSERT INTO employee VALUES(DEFAULT, 'Sophie', 'Rodriguez', 'qkjw11234j');

INSERT INTO cart VALUES(DEFAULT, DEFAULT, DEFAULT);
INSERT INTO cart VALUES(DEFAULT, '1 Black crayon Bulk, 2x A4 sketchbook Conda', 31);

INSERT INTO product VALUES(DEFAULT, 'Black crayon Bulk', 'Black Long-Lasting Marking Crayon', 7);
INSERT INTO product VALUES(DEFAULT, 'White crayon Bulk', 'White Long-Lasting Marking Crayon', 7);
INSERT INTO product VALUES(DEFAULT, 'Red crayon Bulk', 'Red Long-Lasting Marking Crayon', 7);
INSERT INTO product VALUES(DEFAULT, 'A4 sketchbook Conda', 'A4 Heavyweight Hardcover Sketchbook, Ideal for Kids & Adults', 12);
INSERT INTO product VALUES(DEFAULT, 'A6 sketchbook Conda', 'A3 Heavyweight Hardcover Sketchbook, Ideal for Kids & Adults', 9);

INSERT INTO supplier VALUES(DEFAULT, 'Office SUP s.r.o', '59a Commercial St', 'Rothwell', '83294', '09354970', 'CZ123456789');

INSERT INTO review VALUES(DEFAULT, TO_DATE('22/03/2022', 'DD/MM/YYYY'), 5, 'Thanks for awesome A4 sketchbook!');
INSERT INTO review VALUES(DEFAULT, TO_DATE('22/03/2022', 'DD/MM/YYYY'), 2, NULL);
