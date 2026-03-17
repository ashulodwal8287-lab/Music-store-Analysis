select * from playlist_track;
select * from genre;
select * from employee;
select * from customer;
select * from invoice;
select * from invoice_line;

#1 senior most employee based on jon title

select title,levels from employee
order by levels desc limit 3;

#2 which country has most invoice
select * from invoice;
SELECT 
    COUNT(*) AS no_of_invoice, billing_country
 AS country
FROM
    invoice
    group by country
ORDER BY no_of_invoice DESC
LIMIT 3;

#3 top 3 value of total invoice

select total from invoice
order by total desc limit 3;

#4 which city has hight sales
 
select round(sum(total)) as sales,billing_city
as city from invoice group by city
order by sales desc limit 1;

#5 customer who spend most of money

select * from customer;
select * from invoice;

select round(sum(total)) as sale, first_name as buyer 
from invoice i join customer c on 
c.customer_id = i.customer_id 
group by buyer
order by sale desc limit 1; 

#6 write query to return the email, first name,last_name,genre of all rock music listeners.
-- Return your list ordered alphabetically by email starting with A


select email,first_name,last_name
from customer c join
invoice i on i.invoice_id= c.customer_id
join invoice_line l on i.invoice_id = l.invoice_id
where track_id in (
select track_id from track t
join genre g on t.genre_id = g.genre_id
where g.name Like 'Rock')
order by email;

#7 let's invite artist who have written the most rock music in our datasets.
-- write a query that return the artist name and total track count of top 10 rock bands

# Artist who have written most rock music
# 1 Artist Name
# 2 Total track count of top 10 bands

select * from track;
select * from genre;

-- count the track
-- artist name
select * from artist;
select * from album2;
select * from track;


select a.artist_id,a.name,count(a.artist_id) as no_trk
from track t
join album2 ab on t.album_id = ab.album_id
join artist a on a.artist_id = ab.artist_id
join genre g on g.genre_id = t.genre_id
where g.name like "Rock"
group by a.artist_id,a.name
order by no_trk desc
limit 10;

--------------------------------------------------------------------------------------------------------------------

-- Return all track names that have song length longer than avg song length. Return Name and miliseconds for each track.
-- order by song length with longest song list first.

# 1. track name (song lngth > avg song lngth)
# 2. Return name,milisec 
# 3. order by song lngth with longest song list first

select * from track;

select round(avg(milliseconds)) as lng from track;

select name,milliseconds as lng from track where
milliseconds > (select round(avg(milliseconds)) as lng from track)
order by milliseconds desc;

-------------------------------------------------------------------------------------------------------


# find how much amt spend by each customer on artist. write query return customer name, artist name, total spent

select * from artist;
select * from customer;
select * from invoice;
select * from invoice_line;
select * from track;

select c.first_name,a.name as artist_name,
round(sum(i.unit_price*i.quantity)) as tot_spnt
from customer c
join invoice ii on ii.customer_id = c.customer_id
join invoice_line i on i.invoice_id=ii.invoice_id
join track t on t.track_id = i.track_id
join album2 ab on ab.album_id = t.album_id
join artist a on a.artist_id = ab.artist_id
group by 1,2
order by tot_spnt desc;

-----------------------------------------------------------------------------------------------
# We want to find out most popular music genre for each country
# we determine the most popular genre as genre with highest purchase
# write query that return each country along with top genre
# For countries where maximum number of purchase is share return all Genre

-- 1. Most popular music genre with country
-- 2. Find highest purchase

select quantity as purchase, country,g.name,
row_number()over(partition by country order by count(quantity) desc)
from invoice_line ii join invoice i on ii.invoice_id=invoice_id
join customer c on c.customer_id=i.customer_id
join tack t on t.track_id=ii.track_id
join genre g on g.genre_id=t.genre_id
group by 1,2,3;	

WITH genre_counts AS (
    SELECT 
        c.country, 
        g.name AS genre_name, 
        COUNT(il.quantity) AS total_purchases,
        ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY COUNT(il.quantity) DESC) AS row_num
    FROM invoice_line il
    JOIN invoice i ON il.invoice_id = i.invoice_id
    JOIN customer c ON c.customer_id = i.customer_id
    JOIN track t ON t.track_id = il.track_id
    JOIN genre g ON g.genre_id = t.genre_id
    GROUP BY 1, 2
)
SELECT 
    country, 
    genre_name, 
    total_purchases
FROM genre_counts
WHERE row_num = 1;

with popular_order as (
select c.country as country,g.name as genre_name,count(il.quantity) as tot_purchase,
row_number() over(partition by c.country order by count(il.quantity) desc) as row_num
from invoice_line il
join invoice i on il.invoice_id= i.invoice_id
join customer c on c.customer_id = i.customer_id
join track t on t.track_id - il.track_id
join genre g on g.genre_id = t.genre_id
group by 1,2
order by 2 asc,1 desc)
select * from popular_order where row_num =1;

select * from customer;








