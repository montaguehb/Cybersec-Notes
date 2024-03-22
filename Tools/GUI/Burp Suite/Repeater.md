# Overview

Burp Suite Repeater enables us to modify and resend intercepted requests to a target of our choosing. It allows us to take requests captured in the Burp Proxy and manipulate them, sending them repeatedly as needed. Alternatively, we can manually create requests from scratch, similar to using a command-line tool like cURL.

The Repeater interface consists of six main sections:

1. **Request List**: Located at the top left of the tab, it displays the list of Repeater requests. Multiple requests can be managed simultaneously, and each new request sent to Repeater will appear here.
2. **Request Controls**: Positioned directly beneath the request list, these controls allow us to send a request, cancel a hanging request, and navigate through the request history.
3. **Request and Response View**: Occupying the majority of the interface, this section displays the **Request** and **Response** views. We can edit the request in the Request view and then forward it, while the corresponding response will be shown in the Response view.
4. **Layout Options**: Located at the top-right of the Request/Response view, these options enable us to customize the layout of the Request and Response views. The default setting is a side-by-side (horizontal) layout, but we can also choose a vertical layout or combine them in separate tabs.
5. **Inspector**: Positioned on the right-hand side, the Inspector allows us to analyze and modify requests in a more intuitive manner than using the raw editor. We will explore this feature in a later task.
6. **Target**: Situated above the Inspector, the Target field specifies the IP address or domain to which the requests are sent. When requests are sent to Repeater from other Burp Suite components, this field is automatically populated.

# Basic Usage

Once a request has been captured in the Proxy module, we can send it to Repeater by either right-clicking on the request and selecting **Send to Repeater**, or by utilizing the keyboard shortcut `Ctrl + R`.

# Message Analysis Toolbar

Repeater provides us with various request and response presentation options, ranging from hexadecimal output to a fully rendered page.

Each possible option and what it does is listed as follows:

- **Pretty**: This is the default option, which takes the raw response and applies slight formatting enhancements to improve readability.
    
- **Raw**: This option displays the unmodified response directly received from the server without any additional formatting.
    
- **Hex**: By selecting this view, we can examine the response in a byte-level representation, which is particularly useful when dealing with binary files.
    
- **Render**: The render option allows us to visualize the page as it would appear in a web browser. While not commonly utilised in Repeater, as our focus is usually on the source code, it still offers a valuable feature. For most scenarios, the **Pretty** option is generally sufficient. However, it is beneficial to be acquainted with the usage of the other three options.

Adjacent to the view buttons, on the right-hand side, we find the **Show non-printable** characters button (`\n`). This functionality enables the display of characters that may not be visible with the **Pretty** or **Raw** options.

# Inspector

Inspector is a supplementary feature to the Request and Response views in the Repeater module. It is also used to obtain a visually organized breakdown of requests and responses, as well as for experimenting to see how changes made using the higher-level Inspector affect the equivalent raw versions.

Sections available for editing include: 

1. **Request Query Parameters:** These refer to data sent to the server via the URL. For example, in a GET request like `https://admin.tryhackme.com/?redirect=false`, the query parameter **redirect** has a value of "false".
2. **Request Body Parameters:** Similar to query parameters, but specific to POST requests. Any data sent as part of a POST request will be displayed in this section, allowing us to modify the parameters before resending.
3. **Request Cookies:** This section contains a modifiable list of cookies sent with each request.
4. **Request Headers:** It enables us to view, access, and modify (including adding or removing) any headers sent with our requests. Editing these headers can be valuable when examining how a web server responds to unexpected headers.
5. **Response Headers:** This section displays the headers returned by the server in response to our request. It cannot be modified, as we have no control over the headers returned by the server. Note that this section becomes visible only after sending a request and receiving a response.
6. **Request Attributes** we can alter elements related to the location, method, and protocol of the request. This includes modifying the desired resource to retrieve, changing the HTTP method from GET to another variant, or switching the protocol from HTTP/1 to HTTP/2

# Challenge Lab

Your objective in this challenge is to identify and exploit a Union [[SQL Injection]] vulnerability present in the ID parameter of the `/about/ID` endpoint. By leveraging this vulnerability, your task is to launch an attack to retrieve the notes about the CEO stored in the database.

Because we know that the vulnerability is present and at the /about/id endpoint, we can navigate to the about page, select a random employee, and forward the captured request to the repeater.

Changing the endpoint from just the ID to the id + some SQL character will give an internal server error with a message like so `Invalid statement: SELECT firstName, lastName, pfpLink, role, bio FROM people WHERE id = 4'`

Because of this we know that the SQL statement they're using to retrieve information from the DB is `SELECT firstName, lastName, pfpLink, role, bio FROM people WHERE id = {id}`. We also know that it's retrieving 5 columns from whatever database it's going to.

The next thing we want to do is get information on the database schema and individual tables. We do this by first updating the endpoint to something like this `7 UNION SELECT database(),2,3,4,5;--` replacing the id of an actual employee with something that won't return data. This allows the data from our other columns to show on the webpage. In this instance the database name of "site" is returned

Next step is to get information on the tables present in the database, which can be done with this query `7 UNION SELECT 1,2,3,4,group_concat(table_name) FROM information_schema.tables WHERE table_schema = "site";--` This tells us that there's 1 table in the database called "people"

Next we want to see what all of the column names are within the table. `7 UNION SELECT 1,2,3,4,group_concat(column_name) FROM information_schema.columns WHERE table_name = 'people';--`

So we now know that the information we want is in the table people under the column note so we need to create a query to grab it. `7 UNION SELECT 1,2,3,4,notes FROM people WHERE id = 1;--` which returns the flag THM{ZGE3OTUyZGMyMzkwNjJmZjg3Mzk1NjJh}