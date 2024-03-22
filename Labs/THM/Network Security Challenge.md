We're asked to solve the following questions

1. What is the highest port number that is open and less than 10,000
	1.  Solvable by running the command `sudo nmap -sS 10.10.88.127 -p1-10000 -T4` and gives the answer of 8080; however the next questions require information from all ports so instead we can run the command `sudo nmap -sS 10.10.88.127 -p--10000 -T4`to quickly scan all ports
2. There is an open port outside the common 1000 ports; it is above 10,000. What is it?
	1. 10021
3. How many TCP ports are open?
	1. 6
4. What is the flag hidden in the HTTP server header?
	1. Running a packet sniffer like [[Wireshark]] and running the command `wget IP_ADDRESS` allows us to inspect the HTTP header giving the flag THM{web_server_25352}
5. What is the flag hidden in the SSH server header?
	1. Same thing that we did for question 4, but it's in the SSH header instead of HTTP. THM{946219583339}
6. We have an FTP server listening on a nonstandard port. What is the version of the FTP server?
	1. Most likely port for the FTP server is going to be 10021 which we can check the version of using `sudo nmap -sV 10.10.88.127 -p10021`. vsftpd 3.0.3
7. We learned two usernames using social engineering: `eddie` and `quinn`. What is the flag hidden in one of these two account files and accessible via FTP?
	1. Using hydra we can check the passwords among a list of common passwords for those 2 usernames `hydra -l usernames.txt -P /usr/share/wordlists/rockyou.txt ftp://10.10.88.127 -s 10021`. 
	2. eddie:jordan
	3. quinn:andrea
8. Browsing to `http://10.10.88.127:8080` displays a small challenge that will give you a flag once you solve it. What is the flag?
	1. Navigating to the site gives this challenge "Your mission is to use Nmap to scan 10.10.88.127 (this machine) as covertly as possible and avoid being detected by the IDS."
	2. `sudo nmap -sN 10.10.88.127`THM{f7443f99}