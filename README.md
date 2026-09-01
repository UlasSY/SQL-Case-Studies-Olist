# 📊 Olist E-Commerce Ecosystem: End-to-End SQL Analytical Case Study

## 📌 Executive Summary (Özet)
Bu proje, Brezilya pazarının önde gelen e-ticaret platformlarından **Olist** veri seti (~100.000+ anonimleştirilmiş sipariş verisi) üzerinde gerçekleştirilen uçtan uca ilişkisel veri analizi ve iş içgörüsü (business insight) çalışmasıdır.

Süreç boyunca ham e-ticaret verileri ilişkisel veritabanı mimarisine göre modellenmiş; müşteri davranışları, sipariş operasyonları, ödeme kırılımları ve bölgesel lojistik performansları ileri seviye SQL teknikleri ile analiz edilmiştir.

---

## 🛠️ Technical Stack & Methods (Teknik Araçlar ve Yöntemler)
* **Environment / RDBMS:** PostgreSQL / DBeaver
* **Query Techniques:** Multi-table Joins (`INNER`, `LEFT`), Multi-level Aggregations (`GROUP BY`, `HAVING`), Relational Schema Design (PK/FK), Filtering & Ordering.
* **Data Domain:** E-Commerce, Logistics, Financial Transactions & Payment Methods.

---

## 🗂️ Data Architecture & Relations (Veri Mimarisi ve İlişkiler)
Analiz kapsamında ilişkisel bütünlük (Primary Key / Foreign Key) standartlarına uygun olarak modellenmiş aşağıdaki ana tablolar üzerinde çalışılmıştır:

* `customers`: Müşteri segmentasyonu, eyalet (`customer_state`) ve şehir (`customer_city`) verileri.
* `orders`: Sipariş durumları (`delivered`, `shipped`, `canceled`), zaman damgaları ve müşteri ilişkisi.
* `order_items`: Ürün bazlı satış, fiyat (`price`) ve kargo (`freight_value`) maliyet detayları.
* `order_payments`: Ödeme türleri (`credit_card`, `boleto`, `voucher`), taksit sayıları ve işlem tutarları.

**İlişki Mimarisi:**
* `customers` (1) ─── (N) `orders`
* `orders` (1) ─── (N) `order_items`
* `orders` (1) ─── (N) `order_payments`

> **Not:** Veri tabanı oluşturma ve tablo tanımlama script'lerine repository içerisindeki [`schema.sql`](./schema.sql) dosyasından ulaşabilirsiniz.

---

## 🔍 Key Analytical Highlights & Queries (Öne Çıkan Analitik Sorgular)

### 1. Bölgesel Müşteri & Sipariş Yoğunluğu Analizi
> **İş Amacı:** Müşteri bazlı sipariş dağılımlarını eyalet düzeyinde agregasyonla analiz ederek lojistik ve pazarlama odaklı içgörüler sunmak.

```sql
SELECT 
    c.customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS total_unique_customers,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_state
HAVING COUNT(o.order_id) > 100
ORDER BY total_orders DESC;
```
### 2. Ödeme Yöntemleri & Taksit Analizi
> **İş Amacı:** Müşterilerin ödeme tercihlerini ve ortalama taksit sayılarını ödeme tipine göre gruplayarak finansal işlem dağılımını incelemek.
```sql
SELECT 
    payment_type,
    COUNT(order_id) AS total_transactions,
    ROUND(AVG(payment_installments), 2) AS avg_installments,
    ROUND(SUM(payment_value)::numeric, 2) AS total_revenue
FROM olist_order_payments
GROUP BY payment_type
ORDER BY total_revenue DESC;
```
