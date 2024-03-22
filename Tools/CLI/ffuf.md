# Content Discovery

running the command below returns various routes that the website uses

``` bash
ffuf -w {wordlist} -u {url}/FUZZ
```

output:

 :: Method           : GET
 :: URL              : {URL}/FUZZ
 :: Wordlist         : FUZZ: {wordlist}
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
________________________________________________

assets                  [Status: 301, Size: 178, Words: 6, Lines: 8, Duration: 162ms]
contact                 [Status: 200, Size: 3108, Words: 747, Lines: 65, Duration: 164ms]
customers               [Status: 302, Size: 0, Words: 1, Lines: 1, Duration: 169ms]
development.log         [Status: 200, Size: 27, Words: 5, Lines: 1, Duration: 170ms]
monthly                 [Status: 200, Size: 28, Words: 4, Lines: 1, Duration: 162ms]
news                    [Status: 200, Size: 2538, Words: 518, Lines: 51, Duration: 169ms]
private                 [Status: 301, Size: 178, Words: 6, Lines: 8, Duration: 167ms]
robots.txt              [Status: 200, Size: 46, Words: 4, Lines: 3, Duration: 161ms]
sitemap.xml             [Status: 200, Size: 1383, Words: 260, Lines: 43, Duration: 168ms]
:: Progress: [4727/4727] :: Job [1/1] :: 238 req/sec :: Duration: [0:00:20] :: Errors: 0 ::

# Subdomain Enumeration


```bash
ffuf -w {wordlist} -H "Host: FUZZ.{domain}" -u {url}
```

The above command uses the **-w** switch to specify the wordlist we are going to use. The **-H** switch adds/edits a header (in this instance, the Host header), we have the **FUZZ** keyword in the space where a subdomain would normally go, and this is where we will try all the options from the wordlist.  

Because the above command will always produce a valid result, we need to filter the output. We can do this by using the page size result with the **-fs** switch. {size} is just replaced with the largest occurring size value from the previous result


```bash
ffuf -w {wordlist} -H "Host: FUZZ.{domain}" -u {url} -fs {size}
```

output:

# Username Enumeration

we can use ffuf to automatically brute force usernames. An example is shown below

```bash
ffuf -w {wordlist} -X POST -d "username=FUZZ&email=x&password=x&cpassword=x" -H "Content-Type: application/x-www-form-urlencoded" -u {url} -mr "username already exists"
```

`-w` argument selects the file's location on the computer that contains the list of usernames that we're going to check exists. 
`-X` argument specifies the request method, this will be a GET request by default, but it is a POST request in our example. 
`-d` argument specifies the data that we are going to send. 
`-H` argument is used for adding additional headers to the request. 
`-u` argument specifies the URL we are making the request to
`-mr` argument is the text on the page we are looking for to validate we've found a valid username.

# Brute Force Passwords

Using ffuf and known good usernames, we can attempt to brute force passwords.

```bash
ffuf -w {wordlist1}:alias1,{wordlist2}:alias2 -X POST -d "username={alias1}&password={alias2}" -H "Content-Type: application/x-www-form-urlencoded" -u {url} -fc 200
```

alias1 and alias 2 are FUZZ keywords that you can use when you need multiple wordlists or otherwise.
`-fc` checks the http status code and returns any that are 200

