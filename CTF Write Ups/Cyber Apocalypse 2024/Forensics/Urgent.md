# Description

In the midst of Cybercity's "Fray," a phishing attack targets its factions, sparking chaos. As they decode the email, cyber sleuths race to trace its source, under a tight deadline. Their mission: unmask the attacker and restore order to the city. In the neon-lit streets, the battle for cyber justice unfolds, determining the factions' destiny.

# Solution

We're given the email that was sent as part of the phishing attack. Examining it in a text editor gives us a base64 encoded html file as an attachment. Decoding this gives use URL encoded data which when decoded has the flag HTB{4n0th3r_d4y_4n0th3r_ph1shi1ng_4tt3mpT} hidden in it.