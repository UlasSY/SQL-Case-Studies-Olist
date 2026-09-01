# 📊 Olist E-Commerce Ecosystem: End-to-End SQL Analytical Case Study

## 📌 Executive Summary (Özet)
Bu proje, Brezilya pazarının önde gelen e-ticaret platformlarından **Olist** veri seti (~100.000+ anonimleştirilmiş sipariş verisi) üzerinde gerçekleştirilen uçtan uca ilişkisel veri analizi ve iş içgörüsü (business insight) çalışmasıdır[cite: 8, 10].

Süreç boyunca ham e-ticaret verileri ilişkisel veritabanı mimarisine göre modellenmiş; müşteri davranışları, sipariş operasyonları, ödeme kırılımları ve bölgesel lojistik performansları ileri seviye SQL teknikleri ile analiz edilmiştir[cite: 8, 10].

---

## 🛠️ Technical Stack & Methods (Teknik Araçlar ve Yöntemler)
* **Environment / RDBMS:** PostgreSQL / DBeaver[cite: 4, 6]
* **Query Techniques:** Multi-table Joins (`INNER`, `LEFT`), Multi-level Aggregations (`GROUP BY`, `HAVING`), Relational Schema Design (PK/FK), Filtering & Ordering[cite: 8, 9, 10].
* **Data Domain:** E-Commerce, Logistics, Financial Transactions & Payment Methods.

---

## 🗂️ Data Architecture & Relations (Veri Mimarisi ve İlişkiler)
Analiz kapsamında ilişkisel bütünlük (Primary Key / Foreign Key) standartlarına uygun olarak modellenmiş aşağıdaki ana tablolar üzerinde çalışılmıştır:

* `customers`: Müşteri segmentasyonu, eyalet (`customer_state`) ve şehir (`customer_city`) verileri[cite: 8, 10].
* `orders`: Sipariş durumları (`delivered`, `shipped`, `canceled`), zaman damgaları ve müşteri ilişkisi[cite: 8, 10].
* `order_items`: Ürün bazlı satış, fiyat (`price`) ve kargo (`freight_value`) maliyet detayları[cite: 8, 9, 10].
* `order_payments`: Ödeme türleri (`credit_card`, `boleto`, `voucher`), taksit sayıları ve işlem tutarları[cite: 8, 9, 10].

**İlişki Mimarısı:**
* `customers` (1) ─── (N) `orders`[cite: 10]
* `orders` (1) ─── (N) `order_items`[cite: 10]
* `orders` (1) ─── (N) `order_payments`[cite: 10]

> **Not:** Veri tabanı oluşturma ve tablo tanımlama script'lerine repository içerisindeki [`schema.sql`](./schema.sql) dosyasından ulaşabilirsiniz[cite: 10].

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
