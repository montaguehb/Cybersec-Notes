# Description

As the preparations come to an end, and The Fray draws near each day, our newly established team has started work on refactoring the new CMS application for the competition. However, after some time we noticed that a lot of our work mysteriously has been disappearing! We managed to extract the SSH Logs and the Bash History from our dev server in question. The faction that manages to uncover the perpetrator will have a massive bonus come competition!

We're given a bash history and sshd log.

# Solution

Connecting to the docker container provided to us, we're asked the following questions about the logs. All of them are fairly easy to answer by examining the logs.

1. What is the IP Address and Port of the SSH Server (IP:PORT)
	1. 100.107.36.130:2221
2. What time is the first successful Login
	1. 2024-02-13 11:29:50
3. What is the time of the unusual Login
	1. 2024-02-19 04:00:14
4. What is the fingerprint of the attacker's public key
	1. OPkBSs6okUKraq8pYo4XwwBg55QSo210F09FCe1-yj4
5. What is the first command the attacker executed after logging in
	1. `whoami`
6. what is the final command the attacker executed before logging out
	1. `./setup`

answering all of the questions gives the flag HTB{B3sT_0f_luck_1n_th3_Fr4y!!}