# 📊 Olist E-Commerce Ecosystem: End-to-End SQL Analytical Case Study

## 📌 Executive Summary (Özet)
Bu proje, Brezilya pazarının önde gelen e-ticaret platformlarından **Olist** veri seti (~100.000+ anonimleştirilmiş sipariş verisi) üzerinde gerçekleştirilen uçtan uca ilişkisel veri analizi ve iş içgörüsü (business insight) çalışmasıdır.

Süreç boyunca ham e-ticaret verileri ilişkisel veritabanı mimarisine göre modellenmiş; müşteri davranışları, sipariş operasyonları, ödeme kırılımları ve bölgesel lojistik performansları ileri seviye SQL teknikleri ile analiz edilmiştir.

---

## 🛠️ Technical Stack & Methods (Teknik Araçlar ve Yöntemler)
* **Environment / RDBMS:** PostgreSQL / MySQL / DBeaver[cite: 4, 6]
* **Query Techniques:** Complex Joins (`INNER`, `LEFT`), Multi-level Aggregations (`GROUP BY`, `HAVING`), Conditional Aggregations (`CASE WHEN`), Temporal & Date Analytics, Subqueries.
* **Data Domain:** E-Commerce, Logistics, Financial Transactions & Payment Methods.

---

## 🗂️ Data Architecture (Veri Mimarisi ve İlişkiler)
Analiz kapsamında birbiriyle ilişkili aşağıdaki ana tablolar üzerinde çalışılmıştır:
* `olist_customers`: Müşteri segmentasyonu, eyalet ve şehir bazlı lokasyon verileri.
* `olist_orders`: Sipariş durumları (`delivered`, `shipped`, `canceled`), zaman damgaları (`order_purchase_timestamp`, `order_delivered_customer_date`).
* `olist_order_items`: Ürün bazlı satış, fiyat (`price`) ve kargo (`freight_value`) maliyet detayları.
* `olist_order_payments`: Ödeme türleri (`credit_card`, `boleto`, `voucher`), taksit sayıları ve işlem tutarları.

---

## 🔍 Key Analytical Highlights & Queries (Öne Çıkan Analitik Sorgular)

### 1. Bölgesel Müşteri & Sipariş Yoğunluğu Analizi
> **İş Amacı:** Müşteri bazlı sipariş dağılımlarını eyalet düzeyinde agregasyonla analiz ederek lojistik ve pazarlama odaklı içgörüler sunmak.
```sql
SELECT 
    c.customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS total_unique_customers,
    COUNT(o.order_id) AS total_orders
FROM olist_customers c
LEFT JOIN olist_orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_state
HAVING COUNT(o.order_id) > 100
ORDER BY total_orders DESC;


### 2. **Ödeme Yöntemleri** & Taksit Analizi
İş Amacı: Müşterilerin ödeme tercihlerini ve ortalama taksit sayılarını ödeme tipine göre gruplayarak finansal işlem dağılımını incelemek.
