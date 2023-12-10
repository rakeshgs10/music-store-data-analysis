create schema music_store_data;

use music_store_data; 

show tables;

select * from album2;
select * from artist;
select * from track;
select * from playlist;
select * from playlist_track;
select * from media_type;
select * from genre;
select * from invoice_line;
select * from invoice;
select * from customer;
select * from employee;


-- Q1. Which is country best for conducting a concert to earn profits? venue is chosen based on the number of invoices.
 
 SELECT billing_country, COUNT(billing_country) AS no_of_invoices
 FROM invoice
 GROUP BY billing_country
 ORDER BY no_of_invoices DESC
 LIMIT 1;
 
 /* Q2: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

SELECT customer.customer_id ,customer.first_name,customer.last_name, SUM(invoice.total) AS total
FROM customer JOIN invoice ON customer.customer_id = invoice.customer_id 
GROUP BY customer.customer_id 
ORDER BY total DESC
LIMIT 1;

/* Q3: Which artist is the most demanding? based on who have composed the most music in our dataset.*/

SELECT artist.artist_id, artist.name, COUNT(album2.album_id) AS Num_of_songs
FROM artist JOIN album2 ON artist.artist_id = album2.artist_id
GROUP BY artist_id
ORDER BY Num_of_songs DESC
LIMIT 1;

/* Q4: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

WITH CTE AS(
SELECT (I.billing_country)Country, (G.name)Genre_name, SUM(IL.quantity)No_of_purchase, DENSE_RANK() OVER(PARTITION BY I.billing_country ORDER BY SUM(IL.quantity) DESC)ran
FROM invoice I
INNER JOIN invoice_line IL
ON I.invoice_id = IL.invoice_id
INNER JOIN track T
ON IL.track_id = T.track_id
INNER JOIN genre G
ON T.genre_id = G.genre_id
GROUP BY I.billing_country, G.name)

SELECT Country, Genre_name FROM CTE
WHERE ran = 1;

 



-- ADDITIONAL QUESTIONS  :
         
-- 1) Who is the senior most employee,find name and job title.

SELECT first_name,last_name,title ,levels
FROM employee
ORDER BY levels DESC
LIMIT 1;
 
 -- 2) Which countries have the most Invoices?
 
 SELECT billing_country, COUNT(billing_country) AS no_of_invoices
 FROM invoice
 GROUP BY billing_country
 ORDER BY no_of_invoices DESC
 LIMIT 1;
 
 -- 3) What are top 3 values of total invoice?
 
 SELECT billing_country,total
 FROM invoice
 ORDER BY total DESC 
 LIMIT 3;
 

 /*Q4 Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically 
by email starting with A */

SELECT DISTINCT customer.first_name, customer.last_name, customer.email, genre.name
FROM customer
JOIN invoice ON invoice.customer_id= customer.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice. invoice_id
JOIN track ON track.track_id = invoice_line.track_id 
JOIN genre ON genre.genre_id= track.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email ASC

/* Q5Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and 
total track count of the top 5 rock bands */

SELECT  artist.artist_id, artist.name, COUNT(artist.artist_id ) AS Num_of_songs
FROM track
JOIN album2 ON album2.album_id = track.album_id
JOIN artist ON artist.artist_id = album2.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY Num_of_songs DESC
LIMIT 5;





