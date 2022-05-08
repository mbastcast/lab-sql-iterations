-- Write a query to find what is the total business done by each store.
SELECT i.store_id, SUM(p.amount) AS total_sales 
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY store_id;

-- Convert the previous query into a stored procedure.


DELIMITER //
create procedure total_sales_3 (in store int, out param1 int)
begin
 SELECT i.store_id, SUM(p.amount) AS total_sales 
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY store_id;
end //
DELIMITER ;

CALL total_sales_3 (2,@1);

-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store

DELIMITER //
create procedure total_sales__ (in store int, out param1 int)
begin
 SELECT i.store_id, SUM(p.amount) AS total_sales 
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY store_id
Having store_id=store;
end //
DELIMITER ;

CALL total_sales__ (1,@try);




##Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store).
##Call the stored procedure and print the results.


DELIMITER //
CREATE PROCEDURE total_store_biz (IN store_no INT)
BEGIN
DECLARE TOTAL_SALES_AMOUNT FLOAT;
SELECT TOTAL_BUSINESS INTO TOTAL_SALES_AMOUNT
FROM
(SELECT STORE_ID,ROUND(SUM(AMOUNT)) AS TOTAL_BUSINESS
FROM PAYMENT
JOIN STAFF USING (STAFF_ID)
WHERE STORE_ID= STORE_NO
GROUP BY STORE_ID) AS TABLE1;
SELECT TOTAL_SALES_AMOUNT;
END//
DELIMITER;

CALL total_store_biz();
SELECT @try;
 

 
 
-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
-- Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.


DELIMITER //
CREATE PROCEDURE total_business (in id int, out sales float4, out flag varchar(20))
BEGIN
DECLARE colour VARCHAR(20) DEFAULT "";
   SELECT 
	round(sum(p.amount),2) into sales
FROM
	store s
JOIN
	staff st ON st.store_id = s.store_id
JOIN
	payment p ON p.staff_id = st.staff_id
GROUP BY
	st.staff_id, s.store_id
HAVING
	s.store_id = id;
IF sales > 30000 THEN
	SET colour = 'Green Flag';
ELSE
	SET colour = 'Red Flag';
END IF;
SELECT colour INTO flag;
END;
//
delimiter ;

CALL total_business(1, @sales, @flag);
SELECT @sales, @flag;

