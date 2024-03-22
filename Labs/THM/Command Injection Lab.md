There's a website with a text box that pings the ip address that we put into it. We're told to use command injection to find a flag located at "/home/tryhackme/flag.txt"

We can check to see if the input is being filtered at all by passing in any ip address and appending another command, in this case `whoami` using `&&` 

This returns the name of the user running the webserver. Because it returned that information we know that there is likely no filtering for the input and we can attempt to read the content of the flag file using either `cat` for linux or `type` for windows