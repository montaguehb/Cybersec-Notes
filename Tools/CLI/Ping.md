ping is a command that sends an ICMP Echo packet to a remote system. If the remote system is online, and the ping packet was correctly routed and not blocked by any firewall, the remote system should send back an ICMP Echo Reply. Similarly, the ping reply should reach the first system if appropriately routed and not blocked by any firewall.

The objective of such a command is to ensure that the target system is online before we spend time carrying out more detailed scans to discover the running operating system and services.

`ping MACHINE_IP` or `ping HOSTNAME`. if you don’t specify the count on a Linux system, you will need to hit `CTRL+c` to force it to stop. Hence, you might consider `ping -c 10 10.10.107.96` if you just want to send ten packets. This is equivalent to `ping -n 10 10.10.107.96` on a MS Windows system.

Generally speaking, when we don’t get a ping reply back, there are a few explanations that would explain why we didn’t get a ping reply, for example:

- The destination computer is not responsive; possibly still booting up or turned off, or the OS has crashed.
- It is unplugged from the network, or there is a faulty network device across the path.
- A firewall is configured to block such packets. The firewall might be a piece of software running on the system itself or a separate network appliance. Note that MS Windows firewall blocks ping by default.
- Your system is unplugged from the network.

# ICMP packet

| IPv4 datagram |
|---|---|---|---|---|
||Bits 0–7|Bits 8–15|Bits 16–23|Bits 24–31|
|[Header](https://en.wikipedia.org/wiki/IPv4_Header "IPv4 Header")  <br>(20 bytes)|Version/IHL|Type of service (ToS)|Length|   |
|Identification|   |_flags_ and _offset_|   |
|Time to live (TTL)|Protocol|Header checksum|   |
|Source IP address|   |   |   |
|Destination IP address|   |   |   |
|ICMP header  <br>(8 bytes)|Type of message|Code|Checksum|   |
|Header data|   |   |   |
|ICMP payload  <br>(_optional_)|Payload data|   |   |   |

|   |   |   | IPv6 datagram  |   |   |   |
|---|---|---|---|---|---|---|
||Bits 0–3|Bits 4–7|Bits 8–11|Bits 12–15|Bits 16–23|Bits 24–31|
|Header  <br>(40 bytes)|Version|Traffic class|   |Flow label|   |   |
|Payload length|   |   |   |Next header|Hop limit|
|Source address (128 bits)|   |   |   |   |   |
|Destination address (128 bits)|   |   |   |   |   |
|ICMP6 header  <br>(8 bytes)|Type of message|   |Code|   |Checksum|   |
|Header data|   |   |   |   |   |
|ICMP6 payload  <br>(_optional_)|Payload data|   |   |   |   |   |