
Insecure Direct Object Reference (IDOR) is a type of access control vulnerability.

This type of vulnerability can occur when a web server receives user-supplied input to retrieve objects (files, data, documents), too much trust has been placed on the input data, and it is not validated on the server-side to confirm the requested object belongs to the user requesting it.

The vulnerable endpoint you're targeting may not always be something you see in the address bar. It could be content your browser loads in via an AJAX request or something that you find referenced in a JavaScript file. 

Sometimes endpoints could have an unreferenced parameter that may have been of some use during development and got pushed to production. 

# IDOR in Encoded ID

It's common to encode data as things like base64 before sending data to a webserver.

In some cases you can change the data being sent and encode it in the same format so that it's not rejected by the webserver.   

# IDOR in Hashed IDs

It's worthwhile putting any discovered hashes through a web service such as [https://crackstation.net/](https://crackstation.net/) to see if there are any matches.