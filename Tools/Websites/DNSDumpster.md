
DNS lookup tools, such as [[nslookup]] and [[Dig]], cannot find subdomains on their own. The domain you are inspecting might include a different subdomain that can reveal much information about the target.

We can consider using multiple search engines to compile a list of publicly known subdomains. One search engine won’t be enough; moreover, we should expect to go through at least tens of results to find interesting data. After all, you are looking for subdomains that are not explicitly advertised, and hence it is not necessary to make it to the first page of search results. Another approach to discover such subdomains would be to rely on brute-forcing queries to find which subdomains have DNS records.

To avoid such a time-consuming search, one can use an online service that offers detailed answers to DNS queries, such as [DNSDumpster](https://dnsdumpster.com/).