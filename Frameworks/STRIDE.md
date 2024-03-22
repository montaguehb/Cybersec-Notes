A framework for threat modelling that stands for Spoofing identity, Tampering with data, Repudiation threats, Information Disclosure, Denial of Service, and Elevation of Privileges.

Authored by two Microsoft security researchers in 1999 and contains six main principles.

|   |   |
|---|---|
|**Principle**|**Description**|
|Spoofing | This principle requires you to authenticate requests and users accessing a system. Spoofing involves a malicious party falsely identifying itself as another.<br><br>Access keys (such as API keys) or signatures via encryption helps remediate this threat.|
|Tampering | By providing anti-tampering measures to a system or application, you help provide integrity to the data. Data that is accessed must be kept integral and accurate.<br><br>For example, shops use seals on food products.|
|Repudiation | This principle dictates the use of services such as logging of activity for a system or application to track.|
|Information Disclosure | Applications or services that handle information of multiple users need to be appropriately configured to only show information relevant to the owner.|
|Denial of Service | Applications and services use up system resources, these two things should have measures in place so that abuse of the application/service won't result in bringing the whole system down.|
|Elevation of Privilege| This is the worst-case scenario for an application or service. It means that a user was able to escalate their authorization to that of a higher level i.e. an administrator. This scenario often leads to further exploitation or information disclosure.|