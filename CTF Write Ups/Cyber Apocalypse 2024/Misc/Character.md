# Description

Security through Induced Boredom is a personal favourite approach of mine. Not as exciting as something like The Fray, but I love making it as tedious as possible to see my secrets, so you can only get one character at a time!

# Solution

They aren't lying when they say that the flag is very long, easiest way to do this is to write a script that constructs a file with each number between 0 and the length of the flag. You can then pipe the message into netcat to get each line and just take the last character of each line to construct the flag

Bash Script used to construct message
```bash
#!/bin/bash

for i in {1..105}
do
        echo "$i"
done
```

```bash
nc IP_ADDRESS PORT < numbers.txt
```

