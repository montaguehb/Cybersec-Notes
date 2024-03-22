
# Username Enumeration

A helpful exercise to complete when trying to find authentication vulnerabilities is creating a list of valid usernames, which we'll use later in other tasks.

Website error messages are great resources for collating this information to build our list of valid usernames.

we can go to the signup page and try entering a common username of admin. After doing so we get an error that the username already exists.

We can use this error message by sending a bunch of POST requests to the endpoint with a wordlist of potential usernames. In this case we can just use [[ffuf#Username Enumeration|ffuf]]

There's a couple of ways that the output could be handled, for example piping the output to a text file; or we can just manually copy the usernames over as there are very few.

# Brute Force

Using the list of usernames we got above, we can attempt to brute force passwords also using [[ffuf#Brute Force Passwords|ffuf]]

# Logic flaw

Sometimes authentication processes contain logic flaws. A logic flaw is when the typical logical path of an application is either bypassed, circumvented or manipulated by a hacker.

In this case, we're told that there's a logic flaw in the reset password function on the test website. We see a form asking for the email address associated with the account on which we wish to perform the password reset. If an invalid email is entered, you'll receive the error message Account not found from supplied email address

we'll use the email address robert@acmeitsupport.thm which is accepted. We're then presented with the next stage of the form, which asks for the username associated with this login email address. If we enter robert as the username and press the Check Username button, you'll be presented with a confirmation message that a password reset email will be sent to robert@acmeitsupport.thm.

```bash
curl 'http://10.10.45.7/customers/reset?email=robert%40acmeitsupport.thm' -H 'Content-Type: application/x-www-form-urlencoded' -d 'username=robert&email=attacker@hacker.com'
```

We use the `-H` flag to add an additional header to the request. In this instance, we are setting the `Content-Type` to `application/x-www-form-urlencoded`, which lets the web server know we are sending form data so it properly understands our request.  

In the application, the user account is retrieved using the query string, but later on, in the application logic, the password reset email is sent using the data found in the PHP variable `$_REQUEST`.

The PHP `$_REQUEST` variable is an array that contains data received from the query string and POST data. If the same key name is used for both the query string and POST data, the application logic for this variable favours POST data fields rather than the query string, so if we add another parameter to the POST form, we can control where the password reset email gets delivered.

we can create an account and redirect password resets to the new account. Doing so gives us a flag of

# Cookie Tampering

Examining and editing the [[cookies]] set by the web server during your online session can have multiple outcomes, such as unauthenticated access, access to another user's account, or elevated privileges

## Plain Text

The contents of some cookies can be in plain text, and it is obvious what they do.

We see one cookie (logged_in), which appears to control whether the user is currently logged in or not, and another (admin), which controls whether the visitor has admin privileges. Using this logic, if we were to change the contents of the cookies and make a request we'll be able to change our privileges.

sending a request to our given test website with a cookie who's values are modified to be logged in and true, we get back the flag THM{COOKIE_TAMPERING} 
## Hashing

Sometimes cookie values can look like a long string of random characters; these are called [[Hashing|hashes]] which are an irreversible representation of the original text.

for this lab, we're asked to find the value of a known md5 hash 3b2a1053e3270077456a79192070aa78. Looking it up in the database we get 463729
## Encoding

Encoding is similar to hashing in that it creates what would seem to be a random string of text, but in fact, the encoding is reversible.