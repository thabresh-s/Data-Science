############################################################
############################################################
-- 			  Working with SQL Stored Procedures
############################################################
############################################################ 

#############################
-- Task One: Getting Started
-- Set the database and retrieve data from tables in the database
#############################

-- 1.0 Create a database
CREATE database projectdb; 

-- 1.1: Set the database to use
USE projectdb;

-- 1.2: Retrieve all the data in the tables
SELECT * FROM customers;
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM regions;
SELECT * FROM sales;

#############################
-- Task Two: The MySQL Syntax for Stored Procedures
-- In this task, writing a simple stored procedures to retrieve the first 500 employees
############################# 

-- 2.1: Delimiters
-- DELIMITER $$
-- DELIMITER //

-- Default delimiter
SELECT * FROM sales;
SELECT * FROM regions;

-- Change delimiter
DELIMITER $$
SELECT * FROM sales $$

-- Change back to default delimiter
DELIMITER ;
SELECT * FROM regions;

-- 2.2: Drop procedure if it exists
DROP PROCEDURE IF EXISTS select_employees;


-- 2.3: Create a stored procedure to retrieve the first 500 employees
DELIMITER $$

CREATE PROCEDURE select_employees()
BEGIN 
	SELECT * FROM EMPLOYEES
    LIMIT 500;
END $$

DELIMITER;

-- 2.4: Call the procedure
CALL projectdb.select_employees();

#############################
-- Task Three: Why Stored Procedures?
-- Understanding why stored procedures are required
#############################

-- 3.0 Create a new user

-- DROP USER user1@localhost;
CREATE USER user1@localhost IDENTIFIED BY '123456';
CREATE USER user2@localhost IDENTIFIED BY '123456';

-- 3.1: Drop procedure if it exists
DROP PROCEDURE IF EXISTS show_depts;

-- 3.2: Create a stored procedure to retrieve all data in the departments table

DELIMITER $$

CREATE DEFINER=user1@localhost PROCEDURE show_depts()
SQL SECURITY DEFINER
BEGIN
	SELECT * FROM departments
    LIMIT 100;
END $$

DELIMITER;

-- 3.2.1 Grant executive permission to user1@localhost
GRANT EXECUTE ON PROCEDURE projectdb.show_depts TO user1@localhost; 

-- 3.2.2 Grant select permission to user1@localhost (Required for show_depts())
GRANT SELECT ON projectdb.departments TO user1@localhost; 

-- 3.2.3 Grant select permission to user2@localhost
GRANT SELECT ON projectdb.departments TO user2@localhost; 

-- 3.2.4 Grant executive permission to user2@localhost
GRANT EXECUTE ON PROCEDURE projectdb.show_depts TO user2@localhost; 

-- 3.3: Call the procedure
CALL show_depts();

#############################
-- Task Four: Stored procedure to retrieve average salary of employees
#############################

-- 4.1: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS avg_salary;

-- 4.2: Create a stored procedure to returns the average salary of employees

DELIMITER $$

CREATE PROCEDURE avg_salary()
BEGIN
    SELECT AVG(SALARY) AS Average_Salary FROM employees;
END $$

DELIMITER ; 

-- 4.3: Call the procedure
CALL avg_salary;
CALL avg_salary();
CALL projectdb.avg_salary();

#############################
-- Task Five: Stored Procedures with an Input Parameter
#############################

-- 5.1: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS emp_details;

-- 5.2: Create a procedure that returns the details of an employee given the employee_id

DELIMITER $$

CREATE PROCEDURE emp_details(IN param_emp_id INTEGER)
BEGIN
	SELECT e.employee_id, e.first_name, e.last_name, e.hire_date, e.salary
    FROM employees e
    WHERE employee_id = param_emp_id;
    -- WHERE employee_id <= param_emp_id;
END $$

DELIMITER ;

-- 5.3: Call the procedure for employee_id = 100
CALL emp_details(100);

-- 5.4: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS emp_region_details;

-- 5.5: Retrieve all data from the employees and regions table
SELECT * FROM employees;
SELECT * FROM regions;

-- 5.6: Create a procedure that returns the details of an
-- employee including the region and country given the employee_id
DELIMITER $$

CREATE PROCEDURE emp_region_details(IN param_emp_id INTEGER)
BEGIN
	SELECT e.employee_id, e.first_name, e.last_name, e.hire_date, e.salary, r.region, r.country, r.region_id
    FROM employees e
    JOIN regions r
    ON e.region_id = r.region_id
    WHERE employee_id = param_emp_id
    -- WHERE employee_id <= param_emp_id
    ORDER BY r.region_id;
END $$

DELIMITER ;

-- 5.7: Call the procedure for employee_id 10
CALL emp_region_details(10);

#############################
-- Task Six: Stored Procedures with Multiple Input Parameters
#############################

-- 6.1: Retrieve all data from the sales and customers table
SELECT * FROM sales;
SELECT * FROM customers;
    
-- 6.2: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS orders_year;

-- 6.3: Create a procedure that returns details of sales and customers given the year and product category

DELIMITER $$
CREATE PROCEDURE orders_year(IN p_year INT, p_category VARCHAR(50))
BEGIN
	SELECT s.order_date, s.customer_id, c.customer_name, c.state, s.category, s.quantity
    FROM sales s
    JOIN customers c
    ON s.customer_id = c.customer_id
    WHERE YEAR(s.order_date) = p_year -- Using inbuilt sql YEAR fn to extract from s.order_date
    AND s.category = p_category;
END $$ 

DELIMITER ;

-- 6.4: Call the procedure for the year 2015 and Furniture category
CALL orders_year(2016, 'Technology');

#############################
-- Task Seven: Writing a stored procedure to retrieve the total 
-- profit made from each product category for each year
#############################

-- 7.1: Using the query
SELECT category, SUM(profit) AS total_profit
FROM sales
GROUP BY category
ORDER BY total_profit DESC;

-- 7.2: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS total_profit_year;

-- 7.3: Create the stored procedure that answers the question
DELIMITER $$
CREATE PROCEDURE total_profit_year(IN p_year INT)
BEGIN
	SELECT s.category, SUM(s.profit) AS total_profit
	FROM sales s
    WHERE YEAR(s.order_date) = p_year
	GROUP BY category
	ORDER BY total_profit DESC;
END $$ 

DELIMITER ;

-- 7.4: Call the procedure for the year 2017
CALL total_profit_year('2017');

#############################
-- Task Eight: Select into a variable
#############################

-- 8.1: Retrieve all data in the regions table
SELECT * FROM regions;

-- 8.2: Retrieve the region and country for region_id 1
SELECT * FROM regions
WHERE region_id = 1;

-- 8.3: Write the query to select into variables region and country
SELECT region, country -- Variables can contain only one row
INTO @var_regions, @var_country
FROM regions
WHERE region_id = 3;

-- 8.4: Retrieve the data in the variables
SELECT @var_regions, @var_country;

#############################
-- Task Nine: Stored Procedures with an Output Parameter
#############################

-- 9.1: Retrieve all data in the sales table
SELECT * FROM sales;

-- 9.2: Count the number of times a customer has purchased from the store
SELECT COUNT(sales) AS count_sales
FROM sales	
WHERE customer_id = 'CG-12520';

-- 9.3: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS cust_avg_sales;

-- 9.4: Create a stored procedure that returns the average amount
-- in sales from a customer given the customer_id

DELIMITER $$

CREATE PROCEDURE cust_avg_sales(IN i_c_id VARCHAR(15), OUT o_avg_sales DECIMAL(12, 2))
BEGIN
	SELECT AVG(sales) AS avg_sales
    INTO o_avg_sales
	FROM sales	
	WHERE customer_id = i_c_id;
END $$

DELIMITER ;

-- 9.5: Call the stored procedure for customer 'CG-12520'
SET @var_avg_sales = 0;
SET @var_customer = 'DV-13045';

CALL cust_avg_sales('CG-12520', @var_avg_sales);
CALL cust_avg_sales(@var_customer, @var_avg_sales);

SELECT @var_avg_sales;
-- IN param takes a value and OUT sets a value in a variable

-- 9.6: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS cust_avg_sales_dtl;

-- 9.7: Create a stored procedure that returns the customers name and
-- the average amount in sales from a customer given the customer_id

DELIMITER $$

CREATE PROCEDURE cust_avg_sales_dtl(IN i_cust_id VARCHAR(10), OUT o_name VARCHAR(100), OUT o_avg_sales DECIMAL(12,2))
BEGIN
	SELECT c.customer_name, AVG(s.sales) AS avg_sales
	INTO o_name, o_avg_sales
	FROM sales s
	JOIN customers c
	ON s.customer_id = c.customer_id
	WHERE s.customer_id = i_cust_id;
END $$

DELIMITER ;

-- 9.8: Call the stored procedure for customer 'SO-20335'
-- SET @v_avg_sales = 0;
CALL cust_avg_sales_dtl('SO-20335', @v_name, @v_avg_sales);
SELECT @v_name,  @v_avg_sales;

#############################
-- Task Ten: Writing a procedure that returns the employee id given
-- the employees first and last names
#############################

-- 10.1: Retrieve all data in the employees table
SELECT * FROM employees;

-- 10.2: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS emp_id_info;

-- 10.3: Create a procedure that returns the employee id given
-- the employees' first and last names
DELIMITER $$

CREATE PROCEDURE emp_id_info(IN emp_first_name VARCHAR(20), IN emp_last_name VARCHAR(20), OUT o_emp_id INT)
BEGIN
	SELECT e.employee_id
	INTO o_emp_id
	FROM employees e
	WHERE e.first_name = emp_first_name
    AND e.last_name = emp_last_name;
END $$

DELIMITER ;

-- 10.4: Call the procedure for an employee whose first name is 'Eddy'
-- and last name is 'McCoole'
CALL emp_id_info('Eddy', 'McCoole', @v_emp_id);
SELECT @v_emp_id;
SELECT * FROM employees WHERE employee_id = 246;

#############################
-- Task Eleven: Practice Queries
#############################

-- 11.1: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS customer_sales_rank;

select * from sales;

-- 11.2: Writing a procedure that returns the details of customers
-- based on the total amount made in sales in different segments
DELIMITER $$

CREATE PROCEDURE customer_sales_rank(IN in_year INT)
BEGIN
	SELECT s.customer_id, c.customer_name, c.segment, c.state, SUM(s.sales) AS total_sales
	FROM sales s
    JOIN customers c
    ON s.customer_id = c.customer_id
	WHERE YEAR(s.order_date) = in_year
    GROUP BY c.segment
    -- GROUP BY s.customer_id
    ORDER BY total_sales DESC
    LIMIT 10;
END $$

DELIMITER ;

-- 11.3: Call the procedure for the year 2016
CALL customer_sales_rank(2016); 

-- 11.4: Extending the stored procedure to return the details of top 5 customers
-- based on the total amount made in sales in different years and product category
DROP PROCEDURE IF EXISTS cust_sales_rank_category;

-- 11.5: Call the procedure for the year 2016 and
-- Technology category
DELIMITER $$

CREATE PROCEDURE cust_sales_rank_category(IN in_year INT, in_category VARCHAR(50))
BEGIN
	SELECT s.customer_id, c.customer_name, c.segment, c.state, SUM(s.sales) AS total_sales
	FROM sales s
    JOIN customers c
    ON s.customer_id = c.customer_id
	WHERE YEAR(s.order_date) = in_year
    AND s.category = in_category
    -- GROUP BY s.customer_id
    GROUP BY c.state
    ORDER BY total_sales DESC;
    -- LIMIT 10;
END $$

DELIMITER ;

-- 11.6: Call the procedure for the year 2016
CALL cust_sales_rank_category(2016, 'Technology');



################################################################
##-------------------------------------------------------------##
## 							COMPLETE						   ##
##-------------------------------------------------------------##
#################################################################

