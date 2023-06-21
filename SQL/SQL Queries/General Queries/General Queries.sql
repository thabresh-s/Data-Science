# Not null to keep atleast some value, auto_increment is like a counter. Updates when new row is added(like index).
-- empid int Not null primary key auto_increment,

# assigning foreign key, Employee is other table and emp_id is its column
-- foreign key(emp_ref_id) references Employee(emp_id) on delete cascade
# *Important. If any row of referenced table is deleted then corresponding row of the referee table is also deleted automatically.

## 1.0 Using database
use company;

## 2.0 Sql query to print details of employees whose salary is between n to n
select * from employee where salary between 50000 and 90000;

## 2.1 Doing the same using inner query for better o/p
select concat(first_name, ' ', last_name) as Employee_name, salary
from employee where emp_id in 
(select emp_id from employee where salary between 50000 and 90000);

## 3.0 SQL query to retrieve detals of the employees who have joined on a specific date eg. dec 2021
select * from employee where year(joining_date)=2021;
select * from employee where year(joining_date)=2021 and month(joining_date)=12;

## 3.1 Doing the same using inner query for better o/p
select concat(first_name, ' ', last_name) as Employee_name, 
	   extract(Month from joining_date) as joining_Month,
       extract(Year from joining_date) as joining_Year
from employee where emp_id in 
(select emp_id from employee where year(joining_date)=2021 and month(joining_date)=12);

## 4.0 SQL query to fetch number of employees in every department
select count(*) as total_emps, department_name from employee group by department_name;

# Intermediate level
## 5.0 SQL query to print details of the employee who are managers (Using inner join)
select employee.first_name, employee_designation.designation from
employee 
inner join 
employee_designation
on employee.emp_id = employee_designation.emp_ref_id 
and employee_designation.designation in ('Manager');
#and employee_designation.designation = 'Manager';

select e.first_name, ed.designation from
employee e
inner join 
employee_designation ed
on e.emp_id = ed.emp_ref_id 
and ed.designation = 'Manager';

## 6.0 SQL query to clone a new table from another table (without data)
create table employee_clone like employee;

## 6.1 SQL query to clone a new table from another table (with data)
create table employee_clone select * from employee;	

## Important
## 7.1 Query to show just the second highest salary
select max(salary) from employee where salary not in(select max(salary) from employee);

## 7.2 Query to show top n employees (top 4 by salary)
select * from employee order by salary desc limit 4;

## 7.3 Get nth highest salary.(Here 4th) (Using limit)
## Params in limit here(n-1, n) n-1 first param shows after how many rows it will fetch records and second params shows how many records to fetch.
## If only one param is used then it means how many rows to fetch
## Using distinct because there can be multiple records with same salary
select distinct salary from employee order by salary desc;
select distinct salary from employee order by salary desc limit 3, 1;
select distinct salary from employee order by salary desc limit 3, 2; #get 4th highest and 5th highest

## 7.4 Get nth highest salary.(Here 4th, n = 4) (Without using limit) (using alias method and condtion in where clause) 
## Creates another same table as e2 and compares the values of salary
select salary from employee e1 where 4-1 = 
(select count(distinct salary) 
from employee e2
where e2.salary > e1.salary);

## 7.5 Get nth highest salary. (Using dense_rank)
select first_name, salary,
dense_rank() over(order by salary desc) 
as salary_rank from employee; # gives same rank to repeated values

select * from (
select first_name, salary,
dense_rank() over(order by salary desc) 
as salary_rank from employee)
as temp where salary_rank = 3;

select emp_id, first_name from employee;

## 8.1 Update table 
update employee set first_name = 'Aron' where emp_id = 1;

## Different types of Join
# 9.1 Simple inner join (without join keyword) (total no. of rows in o/p are the ones common in both)
select e1.*, e2.* from employee e1, employee_designation e2 where e1.emp_id = emp_ref_id;

# 9.2 Simple inner join (with inner join keyword) (total no. of rows in o/p are the ones common in both)
select e1.*, e2.* from employee e1 inner join employee_designation e2 on e1.emp_id = emp_ref_id;

# 9.3 Simple left join (with left outer join keyword) (total no. of rows in o/p are all of them in left table will null in missing right table)
select e1.*, e2.* from employee e1 left outer join employee_designation e2 on e1.emp_id = emp_ref_id;

# Left join with exclusion (Removes common rows. Keeps only rows from left table which are not matching in right table)
select e1.*, e2.* from employee e1 left join employee_designation e2 on e2.emp_ref_id = e1.emp_id where e2.emp_ref_id is null;

# 9.4 Simple right join (with right join keyword) (total no. of rows in o/p are all the rows in right table will null in missing right table)
select e1.*, e2.* from employee e1 right join employee_designation e2 on e1.emp_id = e2.emp_ref_id;

# 9.5 Simple full join (with full join keyword) (total no. of rows in o/p are all of them in right table will null in missing left table)
select e1.*, e2.* from employee e1 join employee_designation e2 on e1.emp_id = emp_ref_id;

# 9.6 Full outer join  
select e1.emp_id, first_name, salary, e2.project from employee e1 right join employee_projects e2 on e1.emp_id = e2.emp_ref_id
union
select e1.emp_id, first_name, salary, e2.project from employee e1 left join employee_projects e2 on e1.emp_id = e2.emp_ref_id;

# Union combines the columns on both the tables. Same columns from both the tables have to be selected. 
# Uncommon row values are printed at the end.
select e1.emp_id, e1.first_name, e1.salary from employee e1 
union
select e2.empid, e2.first_name, e2.salary from employee_dummy e2;

# 9.7 Cross join (Creates all possibilities)
select distinct e2.project, e1.emp_id, e1.first_name, e1.salary
from employee e1 
cross join employee_projects e2;

# 9.8 Natural join
select distinct e2.project, e1.emp_id, e1.first_name, e1.salary
from employee e1 
natural join employee_projects e2;

select e2.project, e1.emp_id, e1.first_name, e1.salary
from employee e1 
natural join employee_projects e2;
# Natural join and cross join are theoretically different.

select * from employee_designation;
select * from employee_designation group by designation;

# Difference between where and having. Having is used where agg() methods like group by etc are used. where is used directly on rows. 
# USING clause is used when there are columns with same name in different tables. eg using(emp_id).
select * from employee_designation group by designation having emp_ref_id > 1 order by designation_date desc limit 3;

# Very important note about foreign key. The table which references(has set a fkey) cannot add more rows on it's own corresponding to which 
# rows doesn't exist in refered table.
# But it can have rows lesser than the refered table. Missing rows are null

# 10 in which order they should be used in a query (grp by, ordr by, select, where, from, limit, having)
select * from employee_designation group by designation having emp_ref_id > 1 order by designation_date desc limit 2;

# 11 get first 3 characters in a column (nice)
select left (first_name, 3) as first_3 from employee;

# 12 Mask a column such that last few characters are converted to * (like credit card. Asked in visa interview)
select * from employee_clone;
select emp_id, concat(left(salary, 3), '***') as masked_sal from employee_clone; # Concat() is positional (nice)

# 13 Find the 3rd to 6th character of a column
select emp_id, substr(department_name, 2, 2) as sub_str from employee_clone; 
# substr() 1st param is char position to start from, 2nd param is how many chars to take

# 14 Retrieve name of employees who have salary greater than (some employee)
select * from employee;
select first_name, salary from employee where salary > (select salary from employee where first_name='Tiana');

# 15 Create view for the above query
create view sal_view as 
select first_name, salary from employee where salary > (select salary from employee where first_name='Tiana');
select * from sal_view;

# Facebook questions
# Average wifi speed for each wifi id
select avg(wifi_speed), wifi_id from wifi_details group by wifi_id;

# Average wifi speed for each wifi id for last 2 days avg(wifi_speed) These are aggregation methods
# important note. Whenever using an aggr method, the columns in select must be added in group by
# date_add() method is used to add or subrtact date time from current date
select avg(wifi_speed) as avg_wfi_spd, wifi_id, dte from wifi_details 
where dte >= date_add(sysdate(), interval -1 day)
group by wifi_id, dte
order by dte desc; 

# 16 Asked in Facebook interview
# Average wifi speed for each wifi id
select avg(wifi_speed) as avg_wfi_spd, wifi_id from wifi_details group by wifi_id;

# Average wifi speed for each wifi id for last 2 days avg(wifi_speed) These are aggregation methods
# important note. Whenever using an aggr method, the columns in select must be added in group by
# date_add() method is used to add or subrtact date time from current date
select avg(wifi_speed) as avg_wfi_spd, wifi_id, dte from wifi_details 
where dte >= date_add(sysdate(), interval -2 day)
group by wifi_id, dte
order by dte desc;

# Important date time aff methods
select date_add(sysdate(), interval 6 day);
select date_sub(sysdate(), interval 6 day);

# 17 Get first name in uppercase (new video start)
select upper(first_name) from employee;

# 18 Get unique values of department in upper case
select distinct upper(department_name) from employee; 

# 19 Print first 3 characters of first_name in upper case
select upper(substring(first_name, 1, 3)) as upper_sub  from employee;

# 20 Find the position of alphabet 'a' in the first_name column
# instr() agg methd returns the postn of first occurence of string in another string (Case insensitive)
select first_name, instr(first_name, binary'a') as a_at_pos from employee;
select first_name, instr(first_name, binary'a') as a_at_pos from employee where first_name='krystina';

# Important: The difference between where and having keyword
# Both of then are used for filtering but where is used at individual level and having is used at group level  

# 21 Fetch unique values of dept and print its length
select distinct length(department_name) as dept_len, upper(department_name) from employee;

# 22 Print details of emps whose first_name starts with 'T'
select * from employee where first_name like 'T%' order by first_name;

# 23 Print details of emps who have 'a' in their name
select * from employee where first_name like '%a%' order by first_name;

# 24 SQL query that fetches unique value of department from emp table and print its length
select distinct length(department_name) as emp_dept, emp_id, first_name from employee order by first_name;

# 25 SQL query to print details of the workers whose first_name ends with 'a' and contains 8 alphabets
select * from employee where first_name like '_______a';
select * from employee where length(first_name)=8 and first_name like '%a%';

# 26 SQL query to get count of emps for each dept in desc
select emp_ref_id, designation, count(emp_ref_id) as no_emps 
from employee_designation 
group by designation 
order by emp_ref_id desc;

# 27 Give details of emps who are also managers 
select e.emp_id, e.first_name, d.designation from employee e, employee_designation d
where e.emp_id = d.emp_ref_id 
and d.designation = 'manager'
order by e.first_name asc;

# 28 Only show the odd and even rows of a table (using mod operator)
select * from employee where mod(emp_id, 2) <> 0;
select * from employee where mod(emp_id, 2) = 0;

# 29 Top 5 salary from the table
select distinct(salary) from employee order by salary desc limit 1, 5;

# 30 Fetch the emps with same salary
select distinct e.emp_id, e.first_name, e.salary
from employee e, employee e1
where e.salary = e.salary
and e.emp_id != e1.emp_id;

# 31.1 Get first 50% of records (This query works only when there is a key with incremental value. Here, emp_id)
select * from employee where emp_id <= (select count(emp_id)/2 from employee);

# 31.2 Get last 50% of records
select * from employee where emp_id >= (select count(emp_id)/2 from employee);

# 31.3 Solve this 
select * from employee_dummy where empid > (select count(empid)/2 from employee_dummy);
show index from employee_dummy;
use company;

# 32 Get query to fetch departments having less than 5 people in it
select designation, count(emp_ref_id) as no_of_emps 
from employee_designation
group by designation
having count(emp_ref_id) <= 2;

# 33 Get emp with highest salary in each dept
create table dept_max_sal as
select max(salary) as max_sal, department_name from employee group by department_name;

select e.first_name, e.salary, e.department_name from employee e 
inner join dept_max_sal ms on e.department_name = ms.department_name 
and e.salary = ms.max_sal order by salary asc;

# 34 Creating views
create view emp_info as  
select e1.emp_id, e1.first_name, e1.salary, e2.project 
from employee e1 
right join employee_projects e2 
on e1.emp_id = e2.emp_ref_id;

alter view emp_info1 as  
select e1.emp_id, e1.first_name, e1.salary, e2.project 
from employee e1 
left join employee_projects e2 
on e1.emp_id = e2.emp_ref_id;

select avg(emp_id), emp_id from employee_clone;

select * from emp_info;
drop view emp_info1;

# Important notes about views. 
# 1) It is not a separate table. It is just referring to other tables.
# 2) All types of queries are not supported. Stetements such as update, group by, having, union are not supported in creating views.
# 3) Left/Right outer join. Inner join is allowed.
# 4) Using sub queries are also not supported.

# 35 Stored procedure
# Prepared query that can be saved to be used over and over again.
# Params can also be added as i/p.
# Any kind of complex query can be used.
# MySQL client workbench executes queries separated by; Delimiter is used to execute a whole block.

# Creating a basic stored procedure
#create procedure emp_info1
#as 
#select * from employee

# Create a stored procedure to take i/p
#CREATE DEFINER=`root`@`localhost` PROCEDURE `emp_info`(in sal int)
#BEGIN  
#    SELECT * FROM employee WHERE salary > sal;    
#END

# Calling an i/p stored procedure
# call emp_info(70000);

# Create a stored procedure to take o/p
#CREATE DEFINER=`root`@`localhost` PROCEDURE `emp_info`(out sal int)
#BEGIN  
#    SELECT count(*) into sal FROM employee e1 WHERE e1.salary > 70000;    
#END

# Calling an o/p stored procedure
call emp_info(@salary); 
select @salary as emp_sal;

# Create a stored procedure to take i/p and o/p
#CREATE DEFINER=`root`@`localhost` PROCEDURE `emp_info`(inout op_variable int, in empid int)
#BEGIN  
#    SELECT * into op_variable FROM employee e1 WHERE e1.emp_id > empid;    
#END

# Calling an i/p o/p stored procedure
call emp_info(@op_var, 8); 
select @op_var as emp_sal; 

# Recursive stored procedure

# Perforn normalization
# https://www.lifewire.com/transitive-dependency-1019760

# Perform indexing 
# Adding index
alter table employee_dummy add index emp_index1(first_name);
drop index emp_index1 on employee; 

select * from employee_dummy where first_name = 'emiliano';
# first_name values are indexed(stored) in a separate(location) index table(column or data structure) 
# in order and called when first_name is used in query which results in faster execution.
# When using indexes, binary search is performed on the indexed column. In binary search the binary search value is divided. 
# Since the values are ordered. Looks for middle value in the indexed col. 
# If searched value is greater then it will look on right(down) of middle value and vice versa.
# The same procedure continues until it finds a match. This way mysql doesn't have to crawl through each row.
# And when the result is found it also gets the location(pointer) to the original table and retrieves the value.
# Though the make the queries fast. They do take up storage space and some proccessing while being created. So, choose indexes wisely.


# Triggers
# Envoked either before or after a set event. Eg. customer should receive a welcome email asa registered.
# Before triggers are used to update or validate values before they are saved in a table.
# After triggers are used to access field values set by system and affect changes in other records.
# Records that affect after triggers are read only. Cannot use after trigger to update a record. Causes read-only error.
# They work ar row level or column level. 
# Row level: Get executed before or after any column value of a row changes.
# Column level: Get executed before or after the specified column changes.

# Creating before insert trigger. Updates value before insertion.
create trigger trigger_1 before insert on employee_dummy for each row set new.empid = new.empid+5;

# Creating after insert trigger. Updates value before insertion. (Solve this to insert all values of row)
#create trigger trigger_2 after insert on employee_dummy for each row 
#begin
#insert into employee_clone select * from employee_dummy where emp_id = new.emp_id;
#end

# Alter trigger by right clicking on the table name and alter option.
# empid will be inserted as +5 in employee_dummy by trigger_1.
# emp_id will be inserted as +5 in employee_clone by trigger_2 when inserting value in employee_dummy. (After insert) 
insert into employee_dummy values ('053','Max','Velocity','98000','2007-01-04 04:20:00','recusandae');
select * from employee_clone order by emp_id;
select * from employee_dummy order by empid;
# Nested triggers: Actions that are automatically executed when certain database op's are performed.
# Can perform multiple operations simultaneously. Need to be careful otherwise could lead to infinte loop.
# Eg. from previous eg, after registration of customer, the email id should be stored separately to give count of emails sent.
 
# Show triggers in db
show triggers in company;

# Dropping a trigger
drop trigger trigger_2;

# SQL functions 
# user defined fn's (Scalar, multi statement valued fn's, inline table valued)
# Custom concat function (fn's must always return a value)
create function func_1(full_nm char(20), last_nm char(20))
returns char(55) deterministic
return concat(full_nm, ' ', last_nm); 

# Calling function
select emp_id, func_1(first_name, last_name) as full_name from employee_clone;

# Dropping a function
drop function func_1;

# Difference between function and stored procedures.
-- https://www.dotnettricks.com/learn/sqlserver/difference-between-stored-procedure-and-function-in-sql-server

# Merge statement not supported in sql

# limit with where and order by and keyword
# offset is the first i/p param. That many rows will be skipped to get no. of rows mentioned in limit i/p param.
select * from employee_dummy where salary > 5000 order by empid limit 2,3;

# Dynamic SQL queries using params, exec and sp_executesql 


# Collation

# Replace
# Replace is a combo of insert and update (unique to mysql)
# If the value to insert already exists it performs an update and if it doesn't it performs an insert.
replace into employee_new values ('arya@stark.com', 'Arya', 'Stark', 'Needle weilder');
-- replace into employee_new values ('gregor@clegane.org', 'Gregor', 'Clegane', 'The Hound');
replace into employee_new values ('davos@seaworth.com', 'Davos', 'Seaworth', 'The Onion Knight');

delete from employee_new where email='arya@stark.org' and common_name='Needle weilder';
delete from employee_new where common_name='Needle weilder' ORDER BY yourColumnName2 DESC LIMIT 1;

select * from employee_new; 

# Getting count from table 
select emp_id as emp_count from employee group by sum;

# Fetch common records from two tables 
SELECT e1.emp_id
FROM employee e1
inner join employee_dummy e2
on e1.emp_id = e2.empid order by e1.emp_id;

select e2.empid, e2.first_name, e2.salary from employee_dummy e2 order by empid;

select empid, first_name from employee_dummy order by empid asc;

# Pattern matching operators
# % - Matches 0 or more characters
select empid, first_name from employee_dummy where first_name like '%na' order by empid asc;
# _ - Matches 0 or more characters
select empid, first_name from employee_dummy where first_name like 'no_' order by empid asc;


  
