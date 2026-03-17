#1. Who is the senior most employee based on job title?

select first_name from employee order by levels desc;

#2 Which countries have the most invoices?

select billing_country as country,
count(*) as tot_invoice from invoice
group by billing_country
order by tot_invoice desc;

#3 What are the top 3 invoice totals?

select total from invoice order by total desc;

#4 Which city has the highest total invoice amount?

select billing_city as city, round(sum(total)) as total_amt
from invoice group by city order by total_amt;

#5 Who is the best customer (highest spending)?

SELECT 
    c.customer_id, 
    c.first_name, 
    SUM(i.total) AS exp
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name;


#6 Find the most popular genre (most purchased).

select g.name,count(quantity) as tot_purchased 
from invoice_line i inner join track t
on t.track_id = i.track_id
join genre g on g.genre_id = t.genre_id
group by g.name order by tot_purchased desc;

#7 Find the artist who has the most tracks.

select a.name, count(track_id) as tot_track
from track t join album2 ab on t.album_id = ab.album_id
join artist a on a.artist_id = ab.artist_id
group by a.name 
order by tot_track desc;

#8 Find customers who spent more than the average spending.

select round(avg(total)) as avg_exp from invoice;

select first_name as name, round(sum(total)) as tot_exp from customer c
join invoice i on i.customer_id = c.customer_id
group by first_name 
having tot_exp > (select round(avg(total)) as avg_exp from invoice)
order by tot_exp desc;

#9 Find the best selling track.

select t.name, count(quantity) as tot_qty from track t 
join invoice_line i on i.track_id = t.track_id
group by t.name
order by tot_qty desc
limit 2;

#10 Find the most profitable artist.

SELECT 
    a.name, 
    round(SUM(i.quantity * i.unit_price)) AS tot_sales
FROM invoice_line i 
JOIN track t ON t.track_id = i.track_id
JOIN album2 al ON al.album_id = t.album_id
JOIN artist a ON a.artist_id = al.artist_id
GROUP BY a.name
ORDER BY tot_sales DESC;








