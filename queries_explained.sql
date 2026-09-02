-----------------------------------------------------------------
---  customers tablosunda customer_state = 'RJ' olan müşterileri,
--- customer_city'ye göre alfabetik sıralı listeleyin :

SELECT customer_id, customer_city,customer_state FROM customers
WHERE customer_state = 'RJ' order by customer_city asc; 

select count(*) as rj_musteri_sayisi from customers where customer_state = 'RJ'; 

------------------------------------------------------------------
--- orders tablosunda kaç farklı order_status değeri vardır? Hepsini listeleyin :

SELECT
    order_status
FROM orders
GROUP BY order_status
ORDER BY order_status;

--------------------------------------------------------------------
-- order_payments tablosunda payment_type = 'boleto' olan işlemlerin sayısını bulun.

SELECT
    COUNT(*) AS boleto_islem_sayisi
FROM order_payments
WHERE payment_type = 'boleto';

--------------------------------------------------------------------
-- Her eyalette (customer_state) kaç müşteri olduğunu bulun, müşteri sayısına göre azalan sırada listeleyin.

select customer_state, count(*) as musteri_sayisi
from customers
group by customer_state
order by musteri_sayisi desc;

--------------------------------------------------------------------
--Ödeme tipine (payment_type) göre toplam (SUM) ve ortalama
--(AVG) ödeme tutarını hesaplayın, toplam tutara göre azalan sırada gösterin

select payment_type,
       round(sum(payment_value)::numeric, 2) as toplam_odeme,
       round(avg(payment_value)::numeric, 2) as ortalama_odeme
from order_payments
group by payment_type
order by toplam_odeme desc;

--------------------------------------------------------------------
---En az 3000 müşterisi olan eyaletleri bulun.

select customer_state, count(*) as musteri_sayisi
from customers
group by customer_state
having count(*) >= 3000
order by musteri_sayisi desc;

--------------------------------------------------------------------
-- customers ve orders tablolarını birleştirerek, her siparişin
-- hangi şehirden geldiğini gösteren bir sorgu yazın.

select o.order_id,
       o.customer_id,
       c.customer_city,
       c.customer_state
from orders o
inner join customers c
    on o.customer_id = c.customer_id;

--------------------------------------------------------------------
-- customers ve orders tablolarını birleştirerek,
-- her siparişin hangi şehirden geldiğini gösteren bir sorgu yazın.

select c.customer_city, count(o.order_id) as siparis_sayisi
from customers c
inner join orders o
    on c.customer_id = o.customer_id
group by c.customer_city
having count(o.order_id) > 100
order by siparis_sayisi desc;
--------------------------------------------------------------------
-- Şehir bazında (customer_city) toplam sipariş sayısını bulun
-- (JOIN + GROUP BY birlikte), sadece 100'den fazla siparişi olan şehirleri gösterin,
-- sipariş sayısına göre azalan sıralayın.

select c.customer_city, count(o.order_id) as siparis_sayisi
from customers c
inner join orders o
    on c.customer_id = o.customer_id
group by c.customer_city
having count(o.order_id) > 100
order by siparis_sayisi desc;

--------------------------------------------------------------------

-- Hiç siparişi olmayan müşterileri bulun.

select c.customer_id, c.customer_city, c.customer_state
from customers c
left join orders o
    on c.customer_id = o.customer_id
where o.order_id is null;

select count(*) as siparisi_olmayan_musteri_sayisi
from customers c
left join orders o
    on c.customer_id = o.customer_id
where o.order_id is null;

--------------------------------------------------------------------
-- orders, order_items ve order_payments tablolarını birlikte kullanarak,
-- her ödeme tipi için ortalama ürün fiyatını (price) hesaplayın.

select p.payment_type,
       round(avg(i.price)::numeric, 2) as ortalama_urun_fiyati
from orders o
inner join order_items i
    on o.order_id = i.order_id
inner join order_payments p
    on o.order_id = p.order_id
group by p.payment_type
order by ortalama_urun_fiyati desc;
