As a penetration tester, your role when reviewing a website or web application is to discover features that could potentially be vulnerable and attempt to exploit them to assess whether or not they are.

# Exploring the website 

An example site review for the Acme IT Support website would look something like this:

|   |   |   |
|---|---|---|
|**Feature**|**URL**|**Summary**|
|Home Page|/|This page contains a summary of what Acme IT Support does with a company photo of their staff.|
|Latest News|/news|This page contains a list of recently published news articles by the company, and each news article has a link with an id number, i.e. /news/article?id=1|
|News Article|/news/article?id=1|Displays the individual news article. Some articles seem to be blocked and reserved for premium customers only.|
|Contact Page|/contact|This page contains a form for customers to contact the company. It contains name, email and message input fields and a send button.|
|Customers|/customers|This link redirects to /customers/login.|
|Customer Login|/customers/login|This page contains a login form with username and password fields.|
|Customer Signup|/customers/signup|This page contains a user-signup form that consists of a username, email, password and password confirmation input fields.|
|Customer Reset Password|/customers/reset|Password reset form with an email address input field.|
|Customer Dashboard|/customers|This page contains a list of the user's tickets submitted to the IT support company and a "Create Ticket" button.|
|Create Ticket|/customers/ticket/new|This page contains a form with a textbox for entering the IT issue and a file upload option to create an IT support ticket.|
|Customer Account|/customers/account|This page allows the user to edit their username, email and password.|
|Customer Logout|/customers/logout|This link logs the user out of the customer area.|

# Viewing the Page Source

The page source is the human-readable code returned to our browser/client from the web server each time we make a request.

The returned code is made up of HTML ( HyperText Markup Language), CSS ( Cascading Style Sheets ) and JavaScript, and it's what tells our browser what content to display, how to show it and adds an element of interactivity with JavaScript

At the top of the page is a comment "This page is temporary while we work on the new homepage @ /new-home-beta" Going to this page gives us the flag THM{HTML_COMMENTS_ARE_DANGEROUS}

There's also a hidden link to the route "/secret-page" which gives us the flag THM{NOT_A_SECRET_ANYMORE}

External files such as CSS, JavaScript and Images can be included using the HTML code. In this example, you'll notice that these files are all stored in the same directory. If you view this directory in your web browser, there is a configuration error. What should be displayed is either a blank page or a 403 Forbidden page with an error stating you don't have access to the directory. Instead, the directory listing feature has been enabled, which in fact, lists every file in the directory. Sometimes this isn't an issue, and all the files in the directory are safe to be viewed by the public, but in some instances, backup files, source code or other confidential information could be stored here. In this instance, we get a flag in the flag.txt file.

Navigating to the /assets directory gives us access to the next flag THM{INVALID_DIRECTORY_PERMISSIONS}

Viewing the page source can often give us clues into whether a framework is in use and, if so, which framework and even what version. Knowing the framework and version can be a powerful find as there may be public vulnerabilities in the framework, and the website might not be using the most up to date version.

Going to the website of the framework used, we discover that the website is using an outdated version with a vulnerability that allowed anyone to access the backup of the website. Back to the main site, we access this backup file by going to the route /tmp.zip Exctracting the zip file gives us the final flag THM{KEEP_YOUR_SOFTWARE_UPDATED}

# Dev Tools - Inspector

Navigating to the news sections, there's an article that's hidden behind a paywall.

Using the inspector, we can modify and interact with the DOM to hide the paywall by changing the css of the paywall from block to none. Doing so gives us the flag THM{NOT_SO_HIDDEN}

# Dev Tools - Debugger

Moving over to the Contact page, we notice a flashing red box that quickly disappears every time the page is loaded.

Going over to the debugger, we can view the assets and js scripts that the website is running. Clicking on flash.min.js gives us a minified and obfuscated view of one of the scripts. Scrolling to the bottom we see flash\['remove'](); which seems to be a likely candidate for what's removing the flashing box. We can add a breakpoint on that line to stop execution.

Refreshing the page gives us the flag THM{CATCH_ME_IF_YOU_CAN}

# Developer Tools - Network

We can trigger a network event in the contact page by filling out and sending the form. Doing so sends a POST request to the endpoint /contact-msg. Going to this endpoint gives the flag HM{GOT_AJAX_FLAG}