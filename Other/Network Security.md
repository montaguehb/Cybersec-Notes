# Overview
A Computer network is a collection of computers and devices connected with each other. Network security focuses on protecting the security of the devices and links between them in an attempt to protect the CIA of a computer network and its data

Network security consists of different hardware and software solutions to achieve the security goal.

Hardware can include things like 
- Firewall appliance: The firewall allows and blocks connections based on a predefined set of rules. It restricts what can enter and what can leave a network.
- Intrusion Detection System (IDS) appliance: An IDS detects system and network intrusions and intrusion attempts. It tries to detect attackers’ attempts to break into your network.
- Intrusion Prevention System (IPS) appliance: An IPS blocks detected intrusions and intrusion attempts. It aims to prevent attackers from breaking into your network.
- Virtual Private Network (VPN) concentrator appliance: A VPN ensures that the network traffic cannot be read nor altered by a third party. It protects the confidentiality (secrecy) and integrity of the sent data.

Software solutions for network security can be things like:
- Antivirus software: You install an antivirus on your computer or smartphone to detect malicious files and block them from executing.
- Host firewall: Unlike the firewall appliance, a hardware device, a host firewall is a program that ships as part of your system, or it is a program that you install on your system. For instance, MS Windows includes Windows Defender Firewall, and Apple macOS includes an application firewall; both are host firewalls.

# Breaking into networks

In order for someone to gain unauthorized access to a network they need to have a plan of attack. According to Lockheed Martin, this generally follows 7 steps outlined in the "[Cyber Kill Chain](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html)"

## Cyber kill chain
1. Recon: Recon, short for reconnaissance, refers to the step where the attacker tries to learn as much as possible about the target. Information such as the types of servers, operating system, IP addresses, names of users, and email addresses, can help the attack’s success.
2. Weaponization: This step refers to preparing a file with a malicious component, for example, to provide the attacker with remote access.
3. Delivery: Delivery means delivering the “weaponized” file to the target via any feasible method, such as email or USB flash memory.
4. Exploitation: When the user opens the malicious file, their system executes the malicious component.
5. Installation: The previous step should install the malware on the target system.
6. Command & Control (C2): The successful installation of the malware provides the attacker with a command and control ability over the target system.
7. Actions on Objectives: After gaining control over one target system, the attacker has achieved their objectives. One example objective is Data Exfiltration (stealing target’s data).

# Lab

Follow the steps of the cyber kill chain to execute an attack on a target

1. Recon: We want to gather as much information about the target as possible, in this case we do so by running `nmap` against the target network. Doing so reveals 3 open ports (21, 22, and 80) that we can try to leverage to gain access to the network.
2. Weaponization: Knowing that ftp is open, we can try to login as an anon user to the ftp server. 
3. Seeing that there's a file called "secret.txt" we can attempt to access that file by downloading it to our system using `get secret.txt`
4. Viewing the content of the file we see "password: ABC789xyz123"
5. We can use this password to attempt to login to an account over ssh; in this case the root account
6. After a successful login we see another flag.txt file which contains the flag THM{FTP_SERVER_OWNED}
7. We can view and access the home directories of various users on the computer. Starting with librarian who's home directory also contains a flag THM{LIBRARIAN_ACCOUNT_COMPROMISED}