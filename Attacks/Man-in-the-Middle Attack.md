
A Man-in-the-Middle (MITM) attack occurs when a victim (A) believes they are communicating with a legitimate destination (B) but is unknowingly communicating with an attacker (E)

This attack is relatively simple to carry out if the two parties do not confirm the authenticity and integrity of each message. In some cases, the chosen protocol does not provide secure authentication or integrity checking; moreover, some protocols have inherent insecurities that make them susceptible to this kind of attack.

Any time you browse over [HTTPl](../Protocols/Hyper%20Text%20Transfer%20Protocol.md), you are susceptible to a MITM attack. Many tools would aid you in carrying out such an attack, such as [Ettercap](Ettercap.md) and [Bettercap](Bettercap.md).

MITM can also affect other cleartext protocols such as [FTP](File%20Transfer%20Protocol.md), [SMTP](Simple%20Mail%20Transfer%20Protocol.md), and [POP3](Post%20Office%20Protocol%20version%203.md). Mitigation against this attack requires the use of cryptography. The solution lies in proper authentication along with encryption or signing of the exchanged messages. With the help of [PKI](Public%20Key%20Infrastructure) and trusted root certificates, [SSL/TLS](Secure%20Sockets%20Layer%20and%20Transport%20Layer%20Security.md) protects from MITM attacks.

