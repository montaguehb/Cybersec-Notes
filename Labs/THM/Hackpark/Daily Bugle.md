# Questions

1. Access the web server, who robbed the bank?
	1. spiderman
2. What is the Joomla version?
	1. 3.7.0
3. What is Jonah's cracked password?
	1. spiderman123
4. What is the user flag?
	5. 27a260fe3cba712cfdedb1c86d80442e
5. What is the root flag?
	1. eec3d53292b1821868266858d7fa6f79

# Write-up

## Enumeration

`ffuf -w /usr/share/seclists/Discovery/Web-Content/common.txt -u http://10.10.129.165/FUZZ -o ffuf.txt` gives information on various endpoints we can explore including an admin portal

`sudo nmap -sV -sC --version-all -T4 -v --script=vuln 10.10.129.165 -oN nmap.txt ` gives information on what ports are open, the version information of the server and what it may be vulnerable to

going to /language/en-GB/en-GB.xml gives us the full version info for Joomla!

## Exploit

Now that we have Joomla version information, we can search for various exploits for it. In this case we see that there's a SQLi vulnerability that we can exploit. 
`sqlmap -u "http://10.10.129.165/index.php?option=com_fields&view=fields&layout=modal&list[fullordering]=updatexml" --risk=3 --level=5 --random-agent --dbs -p list[fullordering]`

The sqlmap runs very slowly, and In this case we can search the CVE  2017-8917 to find a python script to exploit the same vulnerability. [Python script](https://raw.githubusercontent.com/stefanlucas/Exploit-Joomla/master/joomblah.py)

Running the above script gives us information from the users table including the username of jonah and a password hash. Using something like hashcat, we can easily crack the password

`hashcat -m 3200 ./hash.txt /usr/share/wordlists/rockyou.txt` gives us the password of spiderman123

Navigating to the admin portal and logging into it, we're able to modify the index.php script to give us a reverse shell. All we need to do is replace the code with our [reverse shell script](https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php) and start a nc listener.

## Privilege Escalation

After we've done the above, we just need to reload the main page and we should have shell. Once we do we can start a http server on our attacker machine to download linpeas to the target. Running the scripts, we see that there's a password stored in a php config file.

We can use the password to switch over to jjameson and read the content of the user flag. Re-running the linpeas script as jjameson shows us a high probability that we can exploit yum to gain root.

Checking out yum on [GTFObin](https://gtfobins.github.io), we see that we can generate a rpm package, upload it to the target machine, and run it using `sudo yum localinstall -y x-1.0-1.noarch.rpm` to gain root privileges. After installing the package and running `sudo su`, we can check that we've gained root using `whoami`. 

Finally we can read from the root flag file.