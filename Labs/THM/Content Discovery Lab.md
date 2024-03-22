What is Content Discovery?
In order to define this we need to understand what content is. Content is basically anything sent to your computer/browser by a server. This can include things users see like images and videos, but can also include things that are normally hidden like backups, config files, and staff portals.

Thus content discovery is simply the act of finding as much content as you can from a website. This can be done either manually, automatically, or through [[Open-Source Intelligence|OSINT]]

# Manual Discovery

## Robots.txt

The robots.txt file is a document that tells search engines which pages they are and aren't allowed to show on their search engine results or ban specific search engines from crawling the website altogether. Accessing this file can give information on what routes the website owners might not want people publicly accessing.

Viewing the file at the endpoint shows us that the route /staff-portal is disallowed

## Favicon

The favicon is a small icon displayed in the browser's address bar or tab used for branding a website.

[[OWASP]] hosts a database of common framework icons that you can use to check against the targets favicon [OWASP Favicon DB](https://wiki.owasp.org/index.php/OWASP_favicon_database).

Once we know the framework stack, we can use external resources to discover more about it.

Navigating to https://static-labs.tryhackme.cloud/sites/favicon/ and viewing the page source we see that a default framework favicon is being used. We can run `curl https://static-labs.tryhackme.cloud/sites/favicon/images/favicon.ico | md5sum` to get the md5 hash of the favicon (f276b19aabcb4ae8cda4d22625c6735f). Looking the hash up in the DB shows us that cgiirc is being used.

## Sitemap.xml

Unlike the robots.txt file, which restricts what search engine crawlers can look at, the sitemap.xml file gives a list of every file the website owner wishes to be listed on a search engine.

Navigating to /sitemap.xml we see that there's various routes for the website that can all be easily accessed, but there's also a "/s3cr3t-area" route.

## HTTP Headers

When we make requests to the web server, the server returns various HTTP headers. These headers can sometimes contain useful information such as the webserver software and possibly the programming/scripting language in use.

There are a couple of different ways to view the headers used. One of them is the network tab of the dev tools. The other is by using curl passing in the verbose flag. In either case we can see a flag, THM{HEADER_FLAG}, hidden in the headers

## Framework Stack

Once you've established the framework of a website, either from the above favicon example or by looking for clues in the page source such as comments, copyright notices or credits, you can then locate the framework's website. From there, we can learn more about the software and other information, possibly leading to more content we can discover.

Looking at the page source of our Acme IT Support website, there's a comment at the end of every page with a page load time and also a link to the framework's website, which is [https://static-labs.tryhackme.cloud/sites/thm-web-framework](https://static-labs.tryhackme.cloud/sites/thm-web-framework). Viewing the documentation page of the framework website gives the path of the framework's administration portal. Accessing this portal on the main site and using the default login gives a flag THM{CHANGE_DEFAULT_CREDENTIALS}.

# Automated Discovery

Automated discovery is the process of using tools to discover content rather than doing it manually. This process is automated as it usually contains hundreds, thousands or even millions of requests to a web server. These requests check whether a file or directory exists on a website, giving us access to resources we didn't previously know existed. This process is made possible by using a resource called [[wordlists]].

## ffuf

[[ffuf#Content Discovery|ffuf]] can be used with a wordlist to brute force website and api routes/endpoints

## dirb
Similar to ffuf, very slow!!

`dirb {url} /usr/share/seclists/Discovery/Web-Content/common.txt`

## Gobuster
similar to ffuf and dirb

`gobuster dir --url {url} -w /usr/share/SecLists/Discovery/Web-Content/common.txt`

# OSINT

There are also external resources available that can help in discovering information about your target website; these resources are often referred to as OSINT.

## Google Hacking / Dorking

Google hacking / Dorking utilizes Google's advanced search engine features, which allow you to pick out custom content.

|**Filter**|**Example**|**Description**|
|---|---|---|
|site|site:tryhackme.com|returns results only from the specified website address|
|inurl|inurl:admin|returns results that have the specified word in the URL|
|filetype|filetype:pdf|returns results which are a particular file extension|
|intitle|intitle:admin|returns results that contain the specified word in the title|

More information about google hacking can be found here: [https://en.wikipedia.org/wiki/Google_hacking](https://en.wikipedia.org/wiki/Google_hacking)

## Wappalyzer

Wappalyzer ([https://www.wappalyzer.com/](https://www.wappalyzer.com/)) is an online tool and browser extension that helps identify what technologies a website uses, such as frameworks, Content Management Systems (CMS), payment processors and much more, and it can even find version numbers as well.

## Wayback Machine

The Wayback Machine ([https://archive.org/web/](https://archive.org/web/)) is a historical archive of websites that dates back to the late 90s.

## Github

GitHub is a hosted version of Git on the internet. Repositories can either be set to public or private and have various access controls. You can use GitHub's search feature to look for company names or website names to try and locate repositories belonging to your target. Once discovered, you may have access to source code, passwords or other content that you hadn't yet found.

## S3 Buckets

S3 Buckets are a storage service provided by Amazon AWS, allowing people to save files and even static website content in the cloud accessible over HTTP and HTTPS. The owner of the files can set access permissions to either make files public, private and even writable. Sometimes these access permissions are incorrectly set and inadvertently allow access to files that shouldn't be available to the public.

S3 buckets can be discovered in many ways, such as finding the URLs in the website's page source, GitHub repositories, or even automating the process. One common automation method is by using the company name followed by common terms such as **{name}**-assets, **{name}**-www, **{name}**-public, **{name}**-private, etc.