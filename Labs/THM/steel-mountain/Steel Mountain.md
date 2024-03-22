# Questions

1. Who is the employee of the month?
	1. Bill harper
2. Scan the machine with nmap. What is the other port running a web server on?
	1. 8080
3. Take a look at the other web server. What file server is running?
	1. Rejetto HTTP File Server
4. What is the CVE number to exploit this file server?
	1. CVE-2014-6287
5. Use Metasploit to get an initial shell. What is the user flag?
	1. b04763b6fcf51fcd7c13abc7db4fd365
6. Take close attention to the CanRestart option that is set to true. What is the name of the service which shows up as an _unquoted service path_ vulnerability?
7. What is the root flag?
8. What powershell -c command could we run to manually find out the service name?

# Write-up

Access the website running on the server, and reverse image search to find the employee

Scan for open ports on the target machine using either [[nmap]] or [[Metasploit]] `nmap -sV --version-all $TARGET_IP` this gives answers to 3, and 4.

Using Metasploit, run the exploit for CVE-2014-6287. Once you have access, search for the user.txt flag.