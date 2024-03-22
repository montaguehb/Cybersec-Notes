
A Man-in-the-Middle (MITM) attack occurs when a victim (A) believes they are communicating with a legitimate destination (B) but is unknowingly communicating with an attacker (E)

This attack is relatively simple to carry out if the two parties do not confirm the authenticity and integrity of each message. In some cases, the chosen protocol does not provide secure authentication or integrity checking; moreover, some protocols have inherent insecurities that make them susceptible to this kind of attack.

Any time you browse over [[Hyper Text Transfer Protocol|HTTP]], you are susceptible to a MITM attack. Many tools would aid you in carrying out such an attack, such as [[Ettercap]] and [[Bettercap]].

MITM can also affect other cleartext protocols such as [[File Transfer Protocol|FTP]], [[Simple Mail Transfer Protocol|SMTP]], and [[Post Office Protocol version 3|POP3]]. Mitigation against this attack requires the use of cryptography. The solution lies in proper authentication along with encryption or signing of the exchanged messages. With the help of [[Public Key Infrastructure|PKI]] and trusted root certificates, [[Secure Sockets Layer and Transport Layer Security|TLS]] protects from MITM attacks.