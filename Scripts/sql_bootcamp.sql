/******************************************************************************
Title:  SQL Bootcamp
Author:  Brandon M. Burroughs
Description:  This code is for a SQL Bootcamp.  It focuses much more on 
accessing data from a database rather than database administration.  It assumes
you have MySQL running and have downloaded the data repository here:

https://github.com/brandonmburroughs/sql_bootcamp

Begin by connecting to MySQL via the Command Line Tool or your favorite GUI.
You can download MySQL Community Server and MySQL Workbench for free.

MySQL Community Server:  http://dev.mysql.com/downloads/mysql/
MySQL Workbench:  http://dev.mysql.com/downloads/workbench/

Feel free to contact me with any questions, suggestions, or corrections!
Email:  brandonmburroughs@gmail.com
LinkedIn:  https://www.linkedin.com/in/brandonmburroughs
Twitter:  @ToTheBurroughs
******************************************************************************/



/******************************************************************************
***** CREATING DATABASES AND TABLES *****
******************************************************************************/

/* Look at the available databases */
SHOW DATABASES;

/* Delete the database if it currently exists.
The "IF EXISTS" clause prevents it from throwing an error. */
DROP DATABASE IF EXISTS sql_bootcamp;

/* Create a database */
CREATE DATABASE sql_bootcamp;
/* Now look at the database again */
SHOW DATABASES;

/* Let's connect to our new database. */
USE sql_bootcamp; 

/* The DROP IF EXISTS idea works for tables too! */
DROP TABLE IF EXISTS sql_bootcamp_students;
/* Create a table to store student information */
CREATE TABLE sql_bootcamp_students (
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30),
	age INT,
	job_title VARCHAR(50)
);

/* Now let's look at the tables available */
SHOW TABLES;
/* And let's look at a description of the table*/
DESCRIBE sql_bootcamp_students;



/******************************************************************************
***** ADDING, QUERYING, AND REMOVING DATA *****
******************************************************************************/

/* But what's a table without some data; let's insert some! */
INSERT INTO sql_bootcamp_students (first_name, last_name, age, job_title)
VALUES ('Brandon', 'Burroughs', 24, 'Associate Product Manager');

/* How do we look at the data?  With SELECT and FROM! 
SELECT specifies which columns (or other values) we want to get.
FROM specifies where the data is located, i.e. the table name. */
/* The following returns the data we just looked at */
SELECT first_name, last_name, age, job_title
FROM sql_bootcamp_students;
/* Notice that it not only returns you data, but also the number of 
rows and the query execution time. Most interfaces provide this. */
/* An alternative and often used syntax to look at all of the columns is the *
operator.  '*' means all of the columns. */
SELECT *
FROM sql_bootcamp_students;

/* But we forgot to add an extra column to denote private/public sector job.
We can use the ALTER TABLE command to add an extra column. */
ALTER TABLE sql_bootcamp_students
ADD sector VARCHAR(30);

/* This column will  be NULL until we explicitly add something to it.
This can be accomplished with the UPDATE function. */
UPDATE sql_bootcamp_students
SET sector = 'Private'
WHERE last_name = 'Burroughs';

/* Let's INSERT another row */
INSERT INTO sql_bootcamp_students
VALUES ("Faheem", "Khemani", 26, "Associate Product Manager", "Private");

/* Now try inserting another row with your own data by replacing the values. */
/* You can omit specific column names if you provide values for every column */
INSERT INTO sql_bootcamp_students
VALUES (first_name, last_name, age, job_title, sector);

/* Let's take a look at the job_title column */
SELECT job_title
FROM sql_bootcamp_students;

/* But what if we want to look at the DISTINCT values of job_title? */
SELECT DISTINCT job_title
FROM sql_bootcamp_students;

/* Now let's look at the two rows of data but put them in a particular order.
This can be accomplished with the ORDER BY clause.  Let's order by age. */
SELECT * 
FROM sql_bootcamp_students
ORDER BY age;

/* This defaults to ascending order but can be switched to descending order
with DESC. */
SELECT *
FROM sql_bootcamp_students
ORDER BY age DESC;

/* You want to delete the first entry with the instructor's name (Brandon). 
Use the DELETE function to get rid of specific values or a range of values
based upon a condition. */
DELETE FROM sql_bootcamp_students
WHERE last_name = 'Burroughs';

SELECT *
FROM sql_bootcamp_students;

/* But what if there are two people with the last name 'Burroughs'?  Maybe try
using the first and last name?  But there could still be two students with the
same first and last name.  This is why you'll often see that users are referred
to by an id.  You'll see an example of this in a future example. */

/* But we don't want that table anymore, so let's delete it */
DROP TABLE sql_bootcamp_students;
/* And let's look at the tables again to make sure it's gone. */
SHOW TABLES;

/* It's a bit slow to upload entire datasets one at a time.  There are several 
options to get your data in there quickly, but for our purposes, we'll talk 
about loading data from files on your local computer.  We'll load 3 CSV files
from the above mentioned link. These files represent user data from a
fictitious website. */
/* First, we need to create the empty tables we want to put data in, one for 
each of the 3 files. */
/* User log table logging the user behavior as they visit the website. 
NOTE:  Users not logged in are given a random id starting with 928 */
DROP TABLE IF EXISTS user_logs;
CREATE TABLE user_logs (
	event_id INT NOT NULL AUTO_INCREMENT,
	time_stamp TIMESTAMP NOT NULL,
	user_id INT NOT NULL,
	user_logged_in BOOLEAN,
	resolution_id INT,
	duration_on_page FLOAT(6,2),
	PRIMARY KEY (event_id)
);

/* Table containing user profile information for those users logged in */
DROP TABLE IF EXISTS user_profiles;
CREATE TABLE user_profiles (
	user_id INT NOT NULL,
	user_screen_name VARCHAR(25) NOT NULL,
	user_full_name VARCHAR(50),
	user_created_date TIMESTAMP NOT NULL,
	user_country VARCHAR(50),
	newsletter BOOLEAN NOT NULL,
	PRIMARY KEY (user_id)
);

/* Table containing information about the screen resolution of the user */
DROP TABLE IF EXISTS screen_resolutions;
CREATE TABLE screen_resolutions (
	resolution_id INT NOT NULL,
	screen_resolution VARCHAR(12) NOT NULL,
	PRIMARY KEY (resolution_id)
);

/* Now that we have empty tables created, we need to load the data from the CSV
files on our local computer.  This uses the "LOAD DATA" function of MySQL.  You
can refer to the documentation to learn more about all the options available,
but this is generally how you would import a CSV file with a header. */

/* Load data from a CSV file into user_logs */
/* NOTE:  I keep getting a warning saying data is trucated for duration on page.
I cannot figure out why this happens, but it doesn't seem to affect the data */
LOAD DATA LOCAL INFILE "/Users/brandonburroughs/Google Drive/General Assembly/SQL Boootcamp/sql_bootcamp/Data/user_logs.csv"
INTO TABLE user_logs 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(time_stamp, user_id, user_logged_in, resolution_id, duration_on_page);

/* Load data from a CSV file into user_profiles */
LOAD DATA LOCAL INFILE "/Users/brandonburroughs/Google Drive/General Assembly/SQL Boootcamp/sql_bootcamp/Data/user_profiles.csv"
INTO TABLE user_profiles 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/* Load data from a CSV file into screen_resolutions */
LOAD DATA LOCAL INFILE "/Users/brandonburroughs/Google Drive/General Assembly/SQL Boootcamp/sql_bootcamp/Data/screen_resolutions.csv"
INTO TABLE screen_resolutions 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;



/******************************************************************************
***** EXPLORING, DISCOVERING, AND AGGREGATING DATA *****
******************************************************************************/

/* Now that we have data uploaded, we can begin to explore it.  Let's just 
select data from each of the tables. */
SELECT * 
FROM user_profiles
LIMIT 15;

SELECT * 
FROM screen_resolutions;

/* We'll avoid returning all of the values for user_logs; there are 20,000 
rows.  Instead, we'll return the COUNT of rows in the table. */
SELECT COUNT(*)
FROM user_logs;

/* It would be nice to give that column a new name though.  Use 'AS' to do
just that. */
SELECT COUNT(*) AS 'row_count'
FROM user_logs;

/* Still, it would be nice to see what the user_log data looks likes, maybe
LIMIT the number of rows to 15. */
SELECT * 
FROM user_logs
LIMIT 15;

/* Let's get some basic stats on the "duration" column, maybe the min, max,
and average. */
SELECT MIN(duration_on_page) AS 'min_dur', MAX(duration_on_page) AS 'max_dur',
AVG(duration_on_page) AS 'avg_dur'
FROM user_logs;

/* It's good to get an overall picture of the data, but let's look at segments
of the data using the WHERE command. It allows you to segment the data based 
upon conditional logic.  With our data, let's look at the user_log data WHERE 
users were on our website for more than 20 minutes 
(i.e. duration_on _page > 20). */
SELECT *
FROM user_logs
WHERE duration_on_page > 20;

/* How many were there?  You could count them by hand, but let the computer 
do that work for you! */
SELECT COUNT(*)
FROM user_logs
WHERE duration_on_page > 20;

/* You can also combine conditions with OR (either one can be satisfied) or 
AND (both conditions have to be satisfied).  If we wanted to look at a count of
the users who spent between 10 and 15 minutes on our site, we would use the 
following. */
SELECT COUNT(*)
FROM user_logs
WHERE duration_on_page > 10 AND duration_on_page < 15;
/* If we wanted to look at a count of the users who spent less than 10 minutes
or greater than 15 minutes, we would use the following. */
SELECT COUNT(*)
FROM user_logs
WHERE duration_on_page < 10 OR duration_on_page > 15;

/* That's a good idea.  Now I want to get an idea of how many users logged in
vs. the number of users that didn't. You could do this in two steps, as shown
below. */
SELECT COUNT(*)
FROM user_logs
WHERE user_logged_in = 0;

SELECT COUNT(*)
FROM user_logs
WHERE user_logged_in = 1;

/* However, what happens when we try to run a COUNT or aggregation on the 
resolution_id column?  You'd have to think of every possible value!  This is 
where GROUP BY comes in.  This allows you to GROUP the dataset BY a specific 
value and then perform a COUNT or other aggregation on each each GROUP.  So if
we GROUP BY user_logged_in, we get two datasets, those corresponding to the 0 
value and those corresponding to the 1 value. The syntax*/
SELECT COUNT(*)
FROM user_logs
GROUP BY user_logged_in;

/* One last touch would be to see the value and the count in the same output
row.  You can do this by adding it to the select statement.  However, if it is
in the select statement, it must be in the GROUP BY statement. */
SELECT user_logged_in, COUNT(*)
FROM user_logs
GROUP BY user_logged_in;

/* GROUP BY works with other aggreations too.  Let's see some examples. */
/* Let's look at the average duration_on_page grouped by user_logged_in. */
SELECT user_logged_in, AVG(duration_on_page)
FROM user_logs
GROUP BY user_logged_in;
/* It seems that when users log in, they spend more time on each page. */

/* Let's look at the average duration_on_page grouped by resolution_id */
SELECT resolution_id, AVG(duration_on_page)
FROM user_logs
GROUP BY resolution_id;
/* There doesn't seem to be any major differences. */

/* Let's look at the max duration_on_page grouped by resolution_id */
SELECT resolution_id, MAX(duration_on_page)
FROM user_logs
GROUP BY resolution_id;
/* It seems that there are certain resolution_id's that correspond to a larger
max duration_on_page. */

/* It would be nice to see what the action resolution_id's are. We can just
run the query to look at the resolutions table. */
SELECT *
FROM screen_resolutions;



/******************************************************************************
***** JOINING TABLES *****
******************************************************************************/

/* But surely there's a better way to look at it all at once. This is where
JOIN's come in. As the name suggests, JOIN's allow you to JOIN two (or more)
tables together.  There are several types of joins:
-INNER JOIN: Returns all rows when there is at least one match in BOTH tables
-LEFT JOIN: Return all rows from the left table, and the matched rows from 
	the right table
-RIGHT JOIN: Return all rows from the right table, and the matched rows from 
	the left table
-FULL JOIN: Return all rows when there is a match in ONE of the tables
These have different use cases (please read more about them).  In our case, we
want to join the screen_resolutions table (with the ids and resolutions) to the
corresponding values in our user_logs table.  So, we want to LEFT JOIN 
screen_resolutions to user_logs based upon the matching resolution_id. 
I'll show you an example and then I'll break it down. */

SELECT *
FROM user_logs 
LEFT JOIN screen_resolutions
ON user_logs.resolution_id = screen_resolutions.resolution_id
LIMIT 15;
/* The first thing you'll notice is that the SELECT * FROM user_logs is like 
any other query we make.  Then, I add LEFT JOIN screen_resolutions to signify
the JOIN between the two tables.  But you have to tell it what to join the two
tables on.  That's what the "ON" keyword does.  It means JOIN these two tables
when you see that resolution_id is the same for both.  I added the LIMIT 15
just to limit the output.
Looking at the output, it looks just like user_logs did previously, but with
the addition of two new columns: resolution_id and screen_resolution.  You'll
notice that resolution_id appears twice, once from the user_log table and once 
from the screen_resolutions table.  */

/* NOTE:  It can often get tiresome to type out entire table names, so you can
give the table name an alias by including the alias after the table name. */
SELECT * 
FROM user_logs a
LEFT JOIN screen_resolutions b
ON a.resolution_id = b.resolution_id
LIMIT 15;
/* Notice we get the same results. */

/* What if I just want specific columns from certain tables. That can be 
accomplished by referencing each table-column pair explicitly. */
SELECT b.screen_resolution, a.duration_on_page
FROM user_logs a
LEFT JOIN screen_resolutions b
ON a.resolution_id = b.resolution_id
LIMIT 15;

/* Now back to our original problem.  Let's look max time spent on a page by
screen resolution. */
SELECT b.screen_resolution, MAX(a.duration_on_page)
FROM user_logs a
LEFT JOIN screen_resolutions b
ON a.resolution_id = b.resolution_id
GROUP BY a.resolution_id;



/******************************************************************************
***** MORE QUERIES AND AGGREGATIONS *****
******************************************************************************/

/* Now let's shift our attention to the user_profiles data. Look at the first
15 lines */
SELECT *
FROM user_profiles
LIMIT 15;

/* How many DISTINCT countries are there?  We can use COUNT and DISTINCT to 
find out. */
SELECT COUNT(DISTINCT user_country)
FROM user_profiles;

/* Let's look at those distinct country names. */
SELECT DISTINCT user_country
FROM user_profiles;

/* Let's also look at how many users are in each country. */
SELECT user_country, COUNT(user_country) 
FROM user_profiles
GROUP BY user_country;

/* It would be better to see these as a percentage.  First let's look at the 
total number of values. */
SELECT COUNT(*) 
FROM user_profiles;

/* We can take our previous query and divide the COUNT(user_country) by the
total number of values and multiple by 100 to get a percentage. */
SELECT user_country, COUNT(user_country)/1001*100
FROM user_profiles
GROUP BY user_country;

/* But we want to make this more dynamic in case we another user in the future
(and subsequently increase the total number of values).  We can insert the 
SELECT COUNT statement into the query in parentheses as follows. */
SELECT user_country, COUNT(user_country)/(SELECT COUNT(*) FROM user_profiles)*100
FROM user_profiles
GROUP BY user_country;
/* Instead of the hardcoded '1001', we have a dynamic SELECT COUNT statement */

/* Now let's look at how many users are signed up for our newsletter. are
There two ways to do this.  We could COUNT the values WHERE newsletter = 1. */
SELECT COUNT(newsletter)
FROM user_profiles
WHERE newsletter = 1;

/* We could also "SUM" the newsletter column since a '1' signifies that the
user is signed up for the newsletter and '0' otherwise. */
SELECT SUM(newsletter)
FROM user_profiles;
/* You can verify that you get the same number from both queries. */

/* Now what if we want to look at all of user in user_profiles whose name 
begins with b?  It seems like we'd want to use a WHERE condition as before, but
how do we get the first letter to equal 'b'?  There are several ways to do 
this, but the most straightforward way is to use the LIKE operator and the '%'
wildcard.  LIKE specifies a partial match while '%' signifies that there could
be any number of other characters in that position. Let's look at the query. */
SELECT * 
FROM user_profiles
WHERE user_full_name LIKE 'b%';

SELECT COUNT(*) 
FROM user_profiles
WHERE user_full_name LIKE 'b%';
/* While this specific example might not be something we really want to do, you
can see the utility in knowing how to search for partial matches in text. */

/* But not everyone enters a full name.  That value doesn't exist for some 
users.  Those are referred to as NULL values.  Note that they aren't strings;
they just don't exist.  This can get confusing in the case of numbers.  A '0'
isn't NULL; there's still a value.  NULL means doesn't exist.  Anyway, let's 
count the number of NULL values in our full name column.  This can be 
accomplished with IS and NULL. */
SELECT COUNT(*)
FROM user_profiles
WHERE user_full_name IS NULL;

/* How do you think we would count the "not NULL" values? */
SELECT COUNT(*)
FROM user_profiles
WHERE user_full_name IS NOT NULL;



/******************************************************************************
***** CASE STATEMENTS *****
******************************************************************************/

/* Now, back to our country names. As a refresher, let's look at them again. */
SELECT DISTINCT user_country
FROM user_profiles;
/* However, we want to get an idea of the bigger picture.  Let's create group
these into continents.  We know which countries go with which continent, but we
now want to make the output say the continent.  That's where the CASE statement
comes in.  The general framework is that you decalse a CASE, followed by a list 
of WHEN <condition> THEN <value> statements followed by an optional ELSE and
finally a END. For our example, it would look like the following. */
SELECT CASE
		WHEN user_country = 'USA' OR user_country = 'Canada' OR user_country = 'Mexico' THEN 'North America'
		WHEN user_country = 'England' OR user_country = 'France' OR user_country = 'Germany' THEN 'Europe'
		ELSE 'Not a continent!'
	END AS 'continent'
FROM user_profiles
LIMIT 15;

/* The multiple OR statements can be rewritten more concisely with IN.  IN
specifies a list of values that can be satisfied. */
SELECT CASE
		WHEN user_country IN ('USA','Canada','Mexico') THEN 'North America'
		WHEN user_country IN ('England','France','Germany') THEN 'Europe'
		ELSE 'Not a continent!'
	END AS 'continent'
FROM user_profiles
LIMIT 15;

/* Now we can look at the percentage of users in each continent */
SELECT CASE
		WHEN user_country IN ('USA','Canada','Mexico') THEN 'North America'
		WHEN user_country IN ('England','France','Germany') THEN 'Europe'
		ELSE 'Not a continent!'
	END AS 'continent', COUNT(*)/(SELECT COUNT(*) FROM user_profiles)*100
FROM user_profiles
GROUP BY continent;
/* NOTE:  MySQL nicely let's you use 'continent' in the GROUP BY statement
even though it's not a permanently defined column.  There are cases where you
can't do this.  Just be aware of them. */



/******************************************************************************
***** MORE JOINS *****
******************************************************************************/

/* Now let's join all of the three tables we have available. Let's look at all
of them to see what values we can join on. */
SELECT *
FROM user_logs
LIMIT 15;

SELECT *
FROM user_profiles
LIMIT 15;

SELECT *
FROM screen_resolutions;

/* With those in mind, let's LEFT JOIN user_profiles, screen_resolutions, and
user_action_definitions to user_logs. Try on your own before looking at mine */
SELECT *
FROM user_logs a
LEFT JOIN user_profiles b ON b.user_id = a.user_id
LEFT JOIN screen_resolutions c ON c.resolution_id = a.resolution_id
LIMIT 15;
/* Notice a few things.  There are several null values for user info.  Why is
that?  Because those users were not logged in, so we don't know who they are.
Also, note that certain columns are repeated more than once.  This is because
we used the * operator to return all columns for all tables. We could specify
column names to avoid the duplicate columns. */
SELECT a.*
	,b.user_screen_name, b.user_full_name, b.user_created_date, b.user_country, b.newsletter
	,c.screen_resolution
FROM user_logs a
LEFT JOIN user_profiles b ON b.user_id = a.user_id
LEFT JOIN screen_resolutions c ON c.resolution_id = a.resolution_id
LIMIT 15;

/* Now that we have this nice dataset, let's use it to do some analysis. 
Let's first look at the average duration on page by user_country, then by
newsletter, then by screen_resolution. */
SELECT b.user_country, AVG(a.duration_on_page)
FROM user_logs a
LEFT JOIN user_profiles b ON b.user_id = a.user_id
LEFT JOIN screen_resolutions c ON c.resolution_id = a.resolution_id
GROUP BY b.user_country;
/* NOTE:  The null values correspond to users who aren't logged in and which
there is no country information about. */
SELECT b.newsletter, AVG(a.duration_on_page)
FROM user_logs a
LEFT JOIN user_profiles b ON b.user_id = a.user_id
LEFT JOIN screen_resolutions c ON c.resolution_id = a.resolution_id
GROUP BY b.newsletter;

SELECT c.screen_resolution, AVG(a.duration_on_page)
FROM user_logs a
LEFT JOIN user_profiles b ON b.user_id = a.user_id
LEFT JOIN screen_resolutions c ON c.resolution_id = a.resolution_id
GROUP BY c.screen_resolution;

/* It looks like certain countries perfer us and people who read our newsletter
spend more time on our site overall.  Good to know! */



/******************************************************************************
***** ADVANCED QUERIES AND AGGREGATIONS *****
******************************************************************************/

/* Now let's segement our user_logs into year and see if the average 
duration on our page has changed over the years.  First let's figure out
what years we have data from by look at the MIN and MAX time_stamp.  */
SELECT MIN(time_stamp), MAX(time_stamp)
FROM user_logs;

/* Okay, now we know we need to segment the data into years 2012-2015. */
SELECT CASE
		WHEN time_stamp > '2012-01-01' AND time_stamp < '2013-01-01' THEN 2012
		WHEN time_stamp > '2013-01-01' AND time_stamp < '2014-01-01' THEN 2013
		WHEN time_stamp > '2014-01-01' AND time_stamp < '2015-01-01' THEN 2014
		WHEN time_stamp > '2015-01-01' AND time_stamp < '2016-01-01' THEN 2015
	END AS 'time_year', AVG(duration_on_page) AS 'avg_dur'
FROM user_logs
GROUP BY time_year;

/* That's interesting, but let's add another layer.  Let's look at the data
segmented by year and if the user is logged in. */
SELECT CASE
		WHEN time_stamp > '2012-01-01' AND time_stamp < '2013-01-01' THEN 2012
		WHEN time_stamp > '2013-01-01' AND time_stamp < '2014-01-01' THEN 2013
		WHEN time_stamp > '2014-01-01' AND time_stamp < '2015-01-01' THEN 2014
		WHEN time_stamp > '2015-01-01' AND time_stamp < '2016-01-01' THEN 2015
	END AS 'time_year', user_logged_in, AVG(duration_on_page) AS 'avg_dur'
FROM user_logs
GROUP BY time_year, user_logged_in
ORDER BY user_logged_in, time_year;

/* Another convenient thing to do (that we sort of did earlier) is to include a
subquery in your query.  This is where there is literally a complete query in
your primary query.  This is particular useful for including in the WHERE 
clause.  You may want to reference a list of values that are in another table.
The following example illustrates that exact use case. We want to look at the 
average time a user spend on a page, but only if they have been users since 
before 2010. The nested query returns all of the users who were created before
2010.  The WHERE clause then looks at user_id's IN the list of users returned
from the subquery.  It then calculates the average duration_on_page for those
users created before 2010. */
SELECT AVG(duration_on_page)
FROM user_logs
WHERE user_id IN (
	SELECT user_id
	FROM user_profiles
	WHERE user_created_date < '2010-01-01'
);

/* To reiterate this format, let's add another layer. Let's look at the average
duration_on_page for users who were created before the minimum time_stamp in 
our user_logs. */
SELECT AVG(duration_on_page)
FROM user_logs
WHERE user_id IN (
	SELECT user_id
	FROM user_profiles
	WHERE user_created_date < (
			SELECT MIN(time_stamp)
			FROM user_logs
		)
);
/* The inner most query returns the minimum time_stamp in user_logs.  The next
query returns user_ids from user_profiles where the user was created before 
that minimum.  The, finally, the average duration_on_page is calculated from
the users who were created before that minimum date. */

/* Let's say we want to find the person with the longest full name and output 
"Hi, I'm <user_full_name> from <user_country>!".  There are a couple of useful 
string functions to help accomplish this:
	-CONCAT: Join two values together; concatenate them.
	-LENGTH: Return the number of characters in a string.
We can use a combination of CONCAT and LENGTH to accomplish our task */
SELECT CONCAT("Hi, I'm ",user_full_name," from ",user_country,"!")
FROM user_profiles
WHERE LENGTH(user_full_name) = (
	SELECT MAX(LENGTH(user_full_name)) 
	FROM user_profiles
);
/* The nested query finds the maximum number of characters in a user's full
name.  The outer query returns the concatenated text for the user whose full
name is the same length as the maximum length. */



/******************************************************************************
***** Conclusion *****
******************************************************************************/

/* This is a wonderful start that covers many of things you'll probably
encounter on a regular basis.  Please feel free to contact me if you have any
questions or comments.  Thanks for reading! */