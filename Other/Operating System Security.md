# Intro to OS Security

What is an Operating System (OS)?
A layer of software sitting between hardware and applications and programs that a user may want to run. The OS allows programs to interface with hardware

When talking about security, the goal is to protect 3 things confidentiality, integrity, and availability of data [[CIA Triad]]

An OS should be secure against various attacks to ensure the CIA of data contained on a given computer e.g. private photos stored on a phone

## Examples of OS Security

3 weakness in an OS that can be targeted by a malicious actor are Authentication and weak passwords, Weak File Permissions, and Malicious Programs

1. Authentication and Weak Passwords: A user uses a weak password such as 1234 or qwerty to login to a computer. Passwords like this are common and very easy to guess
2. Weak File Permissions: Proper security has the principle of least privilege, failing to adhere to this can lead to things like files being publicly editable by anyone allowing an attacker to attack the confidentiality and integrity of said file
3. Access to Malicious Programs: Various malware can attack the CIA of data, for example ransomware encrypts files rendering them unusable preventing the access or availability of said files.

## Lab
After discovering a username for a service you want to guess the password to gain unauthorized access to the account and escalate privileges if we can

The user had written sammie and dragon onto sticky notes next to their monitor

guessing that "sammie" is their username, we can attempt to access their account via ssh and use "dragon" as a password

this grants us access which can be verified using the command ```whoami```  

We can test other uses as well to see if we can access their accounts in a similar manner.

switching to a new user, "johnny", with a password abc123; we can run `history` to view previous commands that the user has run. Having mistyped the password for the root user as a command we can attempt to elevate to the root account using the password happyHack!NG

we want to find the final flag which is hidden in a file in the home directory of the root user. Using `cat` ~/flag.txt we can print the content of the file to the console which happens to be THM{YouGotRoot}

