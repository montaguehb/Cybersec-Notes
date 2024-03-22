# Description

A giant stash of powerful weapons and gear have been dropped into the arena - but there's one item you have in mind. Can you filter through the stack to get to the one thing you really need?

# Solution

We're given a binary file with a flag buried inside of it. We can use grep to search for the flag as we know it starts with HTB `hexdump -C stash | grep -P HTB` HTB{n33dl3_1n_a_l00t_stack} 