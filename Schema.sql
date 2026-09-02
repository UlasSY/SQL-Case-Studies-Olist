-- NOT: Tablolar bu sırayla oluşturulmalı (foreign key bağımlılığı
-- nedeniyle önce referans verilen tablo var olmalı).

-- ------------------------------------------------------------
-- 1. CUSTOMERS (Müşteriler)
-- ------------------------------------------------------------
CREATE TABLE customers (
    customer_id                VARCHAR(50) PRIMARY KEY,
    customer_unique_id         VARCHAR(50),
    customer_zip_code_prefix   VARCHAR(10),
    customer_city              VARCHAR(100),
    customer_state             VARCHAR(5)
);

-- ------------------------------------------------------------
-- 2. ORDERS (Siparişler)
-- ------------------------------------------------------------
CREATE TABLE orders (
    order_id                        VARCHAR(50) PRIMARY KEY,
    customer_id                     VARCHAR(50) REFERENCES customers(customer_id),
    order_status                    VARCHAR(30),
    order_purchase_timestamp        TIMESTAMP,
    order_approved_at               TIMESTAMP,
    order_delivered_carrier_date    TIMESTAMP,
    order_delivered_customer_date   TIMESTAMP,
    order_estimated_delivery_date   TIMESTAMP
);

-- ------------------------------------------------------------
-- 3. ORDER_ITEMS (Sipariş Kalemleri)
-- ------------------------------------------------------------
CREATE TABLE order_items (
    order_id              VARCHAR(50) REFERENCES orders(order_id),
    order_item_id         INT,
    product_id            VARCHAR(50),
    seller_id             VARCHAR(50),
    shipping_limit_date   TIMESTAMP,
    price                 NUMERIC(10,2),
    freight_value         NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

-- ------------------------------------------------------------
-- 4. ORDER_PAYMENTS (Ödemeler)
-- ------------------------------------------------------------
CREATE TABLE order_payments (
    order_id               VARCHAR(50) REFERENCES orders(order_id),
    payment_sequential     INT,
    payment_type           VARCHAR(30),
    payment_installments   INT,
    payment_value          NUMERIC(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);


-- ------------------------------------------------------------
-- VERİ DOĞRULAMA (Import sonrası kontrol için)
-- ------------------------------------------------------------
-- SELECT COUNT(*) FROM customers;
-- SELECT COUNT(*) FROM orders;
-- SELECT COUNT(*) FROM order_items;
-- SELECT COUNT(*) FROM order_payments;

-- İlişki özeti:
-- customers  (1) ---- (N) orders
-- orders     (1) ---- (N) order_items
-- orders     (1) ---- (N) order_payments

SELECT
  (SELECT COUNT(*) FROM customers) AS total_customers,
  (SELECT COUNT(*) FROM orders) AS total_orders,
  (SELECT COUNT(*) FROM order_items) AS total_order_items,
  (SELECT COUNT(*) FROM order_payments) AS total_order_payments;


