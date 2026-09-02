-- ------------------------------------------------------------
-- SEVİYE 1 — (1-6) — Mutlak Temeller (SELECT, WHERE, ORDER BY, LIMIT)


1. Tüm müşteri tablosuna göz at

SELECT * FROM customers LIMIT 5;
--------------------------------------------------------------

2. Sadece şehir ve eyalet kolonlarını gör

SELECT customer_city, customer_state FROM customers LIMIT 5;
--------------------------------------------------------------

3. Sadece SP eyaletindeki müşteriler

SELECT customer_id, customer_city FROM customers

WHERE customer_state = 'SP' LIMIT 10;
--------------------------------------------------------------

4. Şehir adına göre alfabetik sırala

SELECT customer_city, customer_state FROM customers

ORDER BY customer_city ASC LIMIT 10;
--------------------------------------------------------------

5. RJ eyaletindekileri, şehir adına göre sırala

SELECT customer_city FROM customers

WHERE customer_state = 'RJ'

ORDER BY customer_city ASC LIMIT 10;

6. En pahalı 5 ürün kalemi

SELECT product_id, price FROM order_items

ORDER BY price DESC LIMIT 5;
--------------------------------------------------------------

--------------------------------------------------------------
--------------------------------------------------------------
---SEVİYE 2 — (7-12) — Aggregate Fonksiyonlar (COUNT, DISTINCT, GROUP BY)


7.a Toplam kayıt (satır) sayısı

SELECT COUNT(*) AS toplam_musteri FROM customers;

7.b Gerçek, tekil müşteri sayısı

SELECT COUNT(DISTINCT customer_unique_id) AS gercek_musteri_sayisi FROM customers;

8. Kaç farklı sipariş durumu var?

SELECT DISTINCT order_status FROM orders;
--------------------------------------------------------------

9. Her eyalette kaç müşteri var?

SELECT customer_state, COUNT(*) AS musteri_sayisi

FROM customers

GROUP BY customer_state

ORDER BY musteri_sayisi DESC;
--------------------------------------------------------------

10. Ödeme tipine göre işlem sayısı

SELECT payment_type, COUNT(*) AS islem_sayisi

FROM order_payments

GROUP BY payment_type

ORDER BY islem_sayisi DESC;
--------------------------------------------------------------

11. Sipariş durumu dağılımı

SELECT order_status, COUNT(*) AS adet

FROM orders

GROUP BY order_status

ORDER BY adet DESC;
--------------------------------------------------------------

12. Taksit sayısına göre işlem dağılımı

SELECT payment_installments, COUNT(*) AS islem_sayisi

FROM order_payments

GROUP BY payment_installments

ORDER BY payment_installments ASC;

--------------------------------------------------------------
--------------------------------------------------------------
---SEVİYE 3 — (13-18) — Gelişmiş Filtreleme & Metrikler (SUM, AVG, HAVING)


13. Ödeme tipine göre toplam tutar

SELECT payment_type, SUM(payment_value) AS toplam_tutar

FROM order_payments

GROUP BY payment_type

ORDER BY toplam_tutar DESC;
--------------------------------------------------------------

14. Ödeme tipine göre ortalama tutar

SELECT payment_type, ROUND(AVG(payment_value), 2) AS ortalama_tutar

FROM order_payments

GROUP BY payment_type

ORDER BY ortalama_tutar DESC;
--------------------------------------------------------------

15. 3000 den fazla müşterisi olan eyaletler

SELECT customer_state, COUNT(*) AS musteri_sayisi

FROM customers

GROUP BY customer_state

HAVING COUNT(*) > 3000

ORDER BY musteri_sayisi DESC;
--------------------------------------------------------------

16. Ortalama ürün fiyatı 100 den yüksek olan satıcılar

SELECT seller_id, ROUND(AVG(price), 2) AS ort_fiyat

FROM order_items

GROUP BY seller_id

HAVING AVG(price) > 100

ORDER BY ort_fiyat DESC

LIMIT 10;
--------------------------------------------------------------

17. En az 50 işlem yapılan ödeme tipleri ve toplam tutarları

SELECT payment_type, COUNT(*) AS islem_sayisi, SUM(payment_value) AS toplam

FROM order_payments

GROUP BY payment_type

HAVING COUNT(*) > 50

ORDER BY toplam DESC;
--------------------------------------------------------------

18. En yüksek kargo ücreti olan 5 ürün kalemi

SELECT order_id, product_id, freight_value FROM order_items

ORDER BY freight_value DESC LIMIT 5;

--------------------------------------------------------------
--------------------------------------------------------------
--- Seviye 4 — (19-23) — İki Tablolu Birleştirmeler (INNER JOIN)


19. Her siparişin şehir bilgisiyle birlikte gösterimi

SELECT o.order_id, o.order_status, c.customer_city

FROM orders o

JOIN customers c ON o.customer_id = c.customer_id

LIMIT 10;
--------------------------------------------------------------

20. Hangi şehirdeki müşteriler en çok sipariş verdi?

SELECT c.customer_city, COUNT(DISTINCT o.order_id) AS siparis_sayisi

FROM orders o

JOIN customers c ON o.customer_id = c.customer_id

GROUP BY c.customer_city

ORDER BY siparis_sayisi DESC

LIMIT 10;
--------------------------------------------------------------

21. Eyalet bazında ortalama ürün fiyatı

SELECT c.customer_state, ROUND(AVG(oi.price), 2) AS ort_fiyat

FROM customers c

JOIN orders o ON c.customer_id = o.customer_id

JOIN order_items oi ON o.order_id = oi.order_id

GROUP BY c.customer_state

ORDER BY ort_fiyat DESC

LIMIT 10;
--------------------------------------------------------------

22. Bir siparişin ürünleri ve fiyatları

SELECT o.order_id, oi.product_id, oi.price

FROM orders o

JOIN order_items oi ON o.order_id = oi.order_id

LIMIT 10;
--------------------------------------------------------------

23. En çok kredi kartıyla ödeme yapan ilk 5 şehir

SELECT c.customer_city, COUNT(*) AS kredi_karti_sayisi

FROM customers c

JOIN orders o ON c.customer_id = o.customer_id

JOIN order_payments op ON o.order_id = op.order_id

WHERE op.payment_type = 'credit_card'

GROUP BY c.customer_city

ORDER BY kredi_karti_sayisi DESC

LIMIT 5;
--------------------------------------------------------------

--------------------------------------------------------------
--------------------------------------------------------------
--- Seviye 5 — (24-27) — İleri Analitik Sorgular (3-Table JOIN + HAVING)


24. Her ödeme tipi için ortalama ürün fiyatı

SELECT op.payment_type, ROUND(AVG(oi.price), 2) AS ort_urun_fiyati

FROM orders o

JOIN order_items oi ON o.order_id = oi.order_id

JOIN order_payments op ON o.order_id = op.order_id

GROUP BY op.payment_type

ORDER BY ort_urun_fiyati DESC;
--------------------------------------------------------------

25. 100 den fazla siparişi olan şehirlerde ortalama ödeme tutarı

SELECT c.customer_city,

       COUNT(DISTINCT o.order_id) AS siparis_sayisi,

       ROUND(AVG(op.payment_value), 2) AS ort_odeme

FROM orders o

JOIN customers c ON o.customer_id = c.customer_id

JOIN order_payments op ON o.order_id = op.order_id

GROUP BY c.customer_city

HAVING COUNT(DISTINCT o.order_id) > 100

ORDER BY siparis_sayisi DESC;
--------------------------------------------------------------

26. Eyalet bazında toplam ödeme tutarı, en az 500 sipariş olanlar

SELECT c.customer_state,

       COUNT(DISTINCT o.order_id) AS siparis_sayisi,

       SUM(op.payment_value) AS toplam_odeme

FROM orders o

JOIN customers c ON o.customer_id = c.customer_id

JOIN order_payments op ON o.order_id = op.order_id

GROUP BY c.customer_state

HAVING COUNT(DISTINCT o.order_id) > 500

ORDER BY toplam_odeme DESC;
--------------------------------------------------------------

27. Şehir + ödeme tipi kırılımında işlem sayısı (en az 20 işlem)

SELECT c.customer_city, op.payment_type, COUNT(*) AS islem_sayisi

FROM orders o

JOIN customers c ON o.customer_id = c.customer_id

JOIN order_payments op ON o.order_id = op.order_id

GROUP BY c.customer_city, op.payment_type

HAVING COUNT(*) > 20

ORDER BY islem_sayisi DESC

LIMIT 15;
--------------------------------------------------------------

--------------------------------------------------------------
--------------------------------------------------------------
--- SEVİYE 6 — (28-30) — İş Senaryoları & Lojistik Analizi 
--- (LEFT JOIN, Geciken Teslimat Analizleri)

28. Hiç siparişi olmayan müşteriler

SELECT c.customer_id, c.customer_city

FROM customers c

LEFT JOIN orders o ON c.customer_id = o.customer_id

WHERE o.order_id IS NULL;
--------------------------------------------------------------

29. Her müşterinin (gerçek/unique) toplam sipariş sayısı, en çok sipariş veren ilk 10

SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS siparis_sayisi

FROM customers c

JOIN orders o ON c.customer_id = o.customer_id

GROUP BY c.customer_unique_id

ORDER BY siparis_sayisi DESC

LIMIT 10;
--------------------------------------------------------------

30. Gecikmiş siparişlerin (gerçek teslimat > tahmini teslimat) şehir bazında sayısı

SELECT c.customer_city, COUNT(*) AS gecikmis_siparis_sayisi

FROM orders o

JOIN customers c ON o.customer_id = c.customer_id

WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date

GROUP BY c.customer_city

ORDER BY gecikmis_siparis_sayisi DESC

LIMIT 10;

--------------------------------------------------------------
