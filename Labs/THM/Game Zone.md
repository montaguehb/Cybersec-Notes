# Questions

1. What is the name of the large cartoon avatar holding a sniper on the forum?
	1. agent 47
2. When you've logged in, what page do you get redirected to?
	1. portal.php
3. In the users table, what is the hashed password?
	1. ab5db915fc9cea6c78df88106c6500c57f2b52901ca6c0c6218f04122c3efd14
4. What was the username associated with the hashed password?
	5. agent47
5. What was the other table name?
	1. post
6. What is the de-hashed password?
	1. videogamer124
7. What is the user flag?
	1. 649ac17b1480ac13ef1e4fa579dac95c
8. How many TCP sockets are running?
	1. 5
9. What is the name of the exposed CMS?
	1. webmin
10. What is the CMS version?
	1. 1.580
11. What is the root flag
	1. a4b945830144bdd71908d12d902adeee
# Write Up

## Obtaining access via SQLi

We're told that the website is vulnerable to [[SQL Injection]], in this case we use [[SQL Injection#Authentication Bypass]] to get around the login.

When logging in, the website directly inserts the user inputted text into the following query `SELECT * FROM users WHERE username = :username AND password := password` Because of this, we can bypass the login by using the following query as the username `' or 1=1 -- -`

## Using SQLMap

[[SQLMap]] is a popular open-source, automatic SQL injection and database takeover tool. Using it, we can quickly fuzz SQLi and dump the database. However, first we need to intercept a request using something like burpsuite and save it into a file to use with every request sent from SQLMap

`sqlmap -r request.txt --dbms=mysql --dump`

Doing this, there are a couple of questions that SQLMap will ask, in this case we can just use the deafults by hitting enter.

## Cracking Passwords with John

Using something like john, we can quickly check the password against other common passwords in a wordlist.

`john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt --format=raw-SHA256`

## Exposing Services with Reverse SSH Tunnels

Reverse SSH port forwarding specifies that the given port on the remote server host is to be forwarded to the given host and port on the local side.

If we run `ss -tulpn` it will tell us what socket connections are running

We can see that a service running on port 10000 is blocked via a firewall rule from the outside (we can see this from the IPtable list). However, Using an SSH Tunnel we can expose the port to us (locally)!

`ssh -L 10000:localhost:10000 agent47@10.10.227.60`

Once complete, in your browser type "localhost:10000" and you can access the newly-exposed webserver.

using nmap, we can figure out the version number `sudo nmap -sV -p10000 localhost`