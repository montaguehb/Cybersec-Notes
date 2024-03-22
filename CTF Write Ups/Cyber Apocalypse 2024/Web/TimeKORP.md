# Description

Are you ready to unravel the mysteries and expose the truth hidden within KROP's digital domain? Join the challenge and prove your prowess in the world of cybersecurity. Remember, time is money, but in this case, the rewards may be far greater than you imagine.

# Solution

Looking at the file download for the docker container, we see a route on / that calls the TimeController function. The function takes in a URL param 'format' and constructs a timeModel object from that. The object takes in the format and constructs a string, when the getTime function is called on the object, it calls exec on the string.

We can leverage the lack of input validation to the exec call to run a terminal command passed into the url param and print out the flag format=';echo \`cat /flag\`' 

HTB{t1m3_f0r_th3_ult1m4t3_pwn4g3}.