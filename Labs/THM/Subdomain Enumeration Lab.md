Subdomain enumeration is the process of finding valid subdomains for a domain in order to expand your attack surface.

three different types of subdomain enumeration
- Brute Force
- [[Open-Source Intelligence|OSINT]]
- Virtual Host

# Brute Force

## DNS Brute force

Brute force DNS (Domain Name System) enumeration is the method of trying tens, hundreds, thousands or even millions of different possible subdomains from a pre-defined list of commonly used subdomains.

This process is usually automated using tools like [[dnsrecon]]
# OSINT

## SSL/TLS Certificates

When [[Secure Sockets Layer and Transport Layer Security|SSL/TLS]] certificates are created by a [[Certificate Authority|CA]] they create a publicly accessible entry in a log called a [[Certificate Authority#Certificate Transparency (CT) Log|Certificate Transparency (CT) Log]]. This is done to stop malicious or accidentally created certs from being used.

We can leverage this service to our advantage to discover subdomains belonging to a domain, sites like [crt.sh](http://crt.sh) and [ui.ctsearch.entrust.com](https://ui.ctsearch.entrust.com/ui/ctsearchui) offer a searchable database of certificates that shows current and historical results.

## Search Engines

Search engines contain trillions of links to more than a billion websites, which can be an excellent resource for finding new subdomains. Using advanced search methods on websites like Google, such as the site: filter, can narrow the search results.

## Sublist3r

To speed up the process of OSINT subdomain discovery, we can automate the above methods with the help of tools like [[Sublist3r]]

# Virtual Host

Some subdomains aren't always hosted in publicly accessible DNS results, such as development versions of a web application or administration portals. Instead, the DNS record could be kept on a private DNS server or recorded on the developer's machines

Because web servers can host multiple websites from one server when a website is requested from a client, the server knows which website the client wants from the Host header. We can utilize this host header by making changes to it and monitoring the response to see if we've discovered a new website.

We can automate this process using tools like [[ffuf]]
