# 📊 Olist E-Commerce Ecosystem: End-to-End SQL Analytical Case Study

## 📌 Executive Summary (Özet)
Bu proje, Brezilya pazarının önde gelen e-ticaret platformlarından **Olist** veri seti (~100.000+ anonimleştirilmiş sipariş verisi) üzerinde gerçekleştirilen uçtan uca ilişkisel veri analizi ve iş içgörüsü (business insight) çalışmasıdır.

Süreç boyunca ham e-ticaret verileri ilişkisel veritabanı mimarisine göre modellenmiş; müşteri davranışları, sipariş operasyonları, ödeme kırılımları ve bölgesel lojistik performansları ileri seviye SQL teknikleri ile analiz edilmiştir.

---

## 🛠️ Technical Stack & Infrastructure (Teknik Mimari)
* **Cloud RDBMS:** Neon DB (Serverless PostgreSQL)
* **Database Client:** DBeaver
* **Query Techniques:** Multi-table Joins (`INNER`, `LEFT`), Multi-level Aggregations (`GROUP BY`, `HAVING`), Relational Schema Design (PK/FK), Filtering & Ordering, Type Casting (`::numeric`).
* **Data Domain:** E-Commerce, Logistics, Financial Transactions & Payment Methods.

> **☁️ Infrastructure Note:** Bu projede veritabanı altyapısı olarak serverless PostgreSQL hizmeti sunan **Neon DB** kullanılmıştır. Veri seti bulut ortamında barındırılarak DBeaver üzerinden yönetilmiştir.

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

> **Not:** Veri tabanı DDL ve tablo oluşturma script'lerine [`schema.sql`](./schema.sql) dosyasından ulaşabilirsiniz.

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
### 3. Ödeme Kanalı Bazlı Ortalama Ürün Fiyat Analizi (3-Table JOIN)
> **İş Amacı:** Farklı ödeme yöntemlerini tercih eden müşterilerin ortalama sepet/ürün harcama eğilimlerini tespit etmek.
```sql
SELECT 
    p.payment_type,
    ROUND(AVG(i.price)::numeric, 2) AS avg_product_price
FROM orders o
INNER JOIN order_items i ON o.order_id = i.order_id
INNER JOIN order_payments p ON o.order_id = p.order_id
GROUP BY p.payment_type
ORDER BY avg_product_price DESC;
```
**İçgörü:** Kredi kartı kullanan müşterilerin ortalama ürün harcaması (126.48 BRL), nakit/havale (Boleto) veya debit kart kullananlara kıyasla belirgin şekilde daha yüksektir.

## 📚 Repository SQL Structure (Sorgu Yapısı)
Projedeki SQL sorguları iki ayrı modüler dosyada organize edilmiştir:

1. queries_modular.sql: Seviye 1'den Seviye 6'ya kadar kademeli olarak zorlaşan, temellerden ileri analitiğe kadar 30 adet pratik sorgusu.

2. queries_explained.sql: Belirli iş senaryolarına ve problem çözümlerine odaklanan 10 adet açıklayıcı ve detaylı analitik sorgu.

## 📚 Modular SQL Query Repository (Sorgu Kütüphanesi)
Projenin teknik derinliğini ve SQL hakimiyetini gösteren Seviye 1'den Seviye 6'ya kadar hazırlanmış 30 adet pratik sorgusu **Queries.sql** dosyasında modüler olarak sunulmuştur:

- Seviye 1: Mutlak Temeller (SELECT, WHERE, ORDER BY, LIMIT)

- Seviye 2: Aggregate Fonksiyonlar (COUNT, DISTINCT, GROUP BY)

- Seviye 3: Gelişmiş Filtreleme & Metrikler (SUM, AVG, HAVING)

- Seviye 4: İki Tablolu Birleştirmeler (INNER JOIN)

- Seviye 5: İleri Analitik Sorgular (3-Table JOIN + HAVING)

- Seviye 6: İş Senaryoları & Lojistik Analizi (LEFT JOIN, Geciken Teslimat Analizleri)

## 🚀 How to Run (Kurulum ve Çalıştırma)
**1.** Depoyu klonlayın:       
git clone [https://github.com/UlasSY/SQL-Case-Studies-Olist.git](https://github.com/UlasSY/SQL-Case-Studies-Olist.git)

**2.** PostgreSQL ortamınızda veritabanını oluşturup schema.sql dosyasını çalıştırarak tabloları oluşturun.

**3.** Veri setini yükledikten sonra analitik sorguları çalıştırmak için queries.sql dosyasını kullanabilirsiniz.

## 📜 License
Bu proje MIT lisansı altında yayınlanmıştır.
