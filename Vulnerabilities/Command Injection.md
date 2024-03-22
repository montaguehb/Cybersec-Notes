Command injection is the abuse of an application's behaviour to execute commands on the operating system, using the same privileges that the application on a device is running with.

Command injection is also often known as [[Remote Code Execution|RCE]] because of the ability to remotely execute code within an application.

This vulnerability exists because applications often use functions in programming languages such as PHP, Python and NodeJS to pass data to and to make system calls on the machine’s operating system.

# Discovering Command Injection

Command Injection can be detected in mostly two ways:

|**Method**|**Description**|
|---|---|
|Blind|This type of injection is where there is no direct output from the application when testing payloads. You will have to investigate the behaviours of the application to determine whether or not your payload was successful.|
|Verbose|This type of injection is where there is direct feedback from the application once you have tested a payload. For example, running the `whoami` command to see what user the application is running under. The web application will output the username on the page directly.|

## Blind Injection

Blind command injection is when command injection occurs; however, there is no output visible, so it is not immediately noticeable. For example, a command is executed, but the web application outputs no message.

For this type of command injection, we will need to use payloads that will cause some time delay. For example, the `ping` and `sleep` commands are significant payloads to test with. Using `ping` as an example, the application will hang for _x_ seconds in relation to how many _pings_ you have specified.

Another method of detecting blind command injection is by forcing some output. This can be done by using redirection operators such as `>`. We can then use a command such as `cat` to read this newly created file’s contents.

The `curl` command is a great way to test for command injection. This is because you are able to use `curl` to deliver data to and from an application in your payload.

## Verbose Injection

Detecting command injection this way is arguably the easiest method of the two. Verbose command injection is when the application gives you feedback or output as to what is happening or being executed.

For example, the output of commands such as `ping` or `whoami` is directly displayed on the web application.

## Payloads

Linux

|**Payload**|**Description**|
|---|---|
|whoami|See what user the application is running under.|
|ls|List the contents of the current directory. You may be able to find files such as configuration files, environment files (tokens and application keys), and many more valuable things.|
|ping|This command will invoke the application to hang. This will be useful in testing an application for blind command injection.|
|sleep|This is another useful payload in testing an application for blind command injection, where the machine does not have `ping` installed.|
|nc|Netcat can be used to spawn a reverse shell onto the vulnerable application. You can use this foothold to navigate around the target machine for other services, files, or potential means of escalating privileges.|

  

Windows

|**Payload**|**Description**|
|---|---|
|whoami|See what user the application is running under.|
|dir|List the contents of the current directory. You may be able to find files such as configuration files, environment files (tokens and application keys), and many more valuable things.|
|ping|This command will invoke the application to hang. This will be useful in testing an application for blind command injection.|
|timeout|This command will also invoke the application to hang. It is also useful for testing an application for blind command injection if the `ping` command is not installed.|

# Remediating Command Injection

Command injection can be prevented in a variety of ways. Everything from minimal use of potentially dangerous functions or libraries in a programming language to filtering input without relying on a user’s input.

## Vulnerable Functions

In PHP, many functions interact with the operating system to execute commands via shell; these include:

- Exec
- Passthru
- System

Other languages have their own ways of interacting with the OS. Below is a code snippet containing one such function.

```php
<?php

echo passthru("/bin/ping -c 4 "$_GET["ping"].');

?>
```

These functions take input such as a string or user data and will execute whatever is provided on the system. Any application that uses these functions without proper checks will be vulnerable to command injection.

## Input Sanitization

Sanitising any input from a user that an application uses is a great way to prevent command injection. This is a process of specifying the formats or types of data that a user can submit.

Things like [[Regular Expressions|regex]] can do just that through pattern matching. The below function shows an updated version of the previous function, but uses regex to ensure that only numbers can be passed in

```php
<input type="text" id="ping" name="ping" pattern="[0-9]+"</input>
<?php

echo passthru("/bin/ping -c 4 "$_GET["ping"].');

?>
```

PHP and most other languages also have built in methods to filter strings. The below example uses the `filter_input` function to do just that.

```php
<?php

if (!filter_input(INPUT_GET, "ping", FILTER_VALIDATE_NUMBER)) {

	echo passthru("/bin/ping -c 4 "$_GET["ping"].');

}
```

# Bypassing Filters

Applications will employ numerous techniques in filtering and sanitising data that is taken from a  user's input. These filters will restrict you to specific payloads; however, we can abuse the logic behind an application to bypass these filters. For example, an application may strip out quotation marks; we can instead use the hexadecimal value of this to achieve the same result.