# Description

The Fray: The Video Game is one of the greatest hits of the last... well, we don't remember quite how long. Our "computers" these days can't run much more than that, and it has a tendency to get repetitive...

# Solution

Connecting to the game through nc gives us some basic information on how the game works. 

===== THE FRAY: THE VIDEO GAME =====
Welcome!
This video game is very simple
You are a competitor in The Fray, running the GAUNTLET
I will give you one of three scenarios: GORGE, PHREAK or FIRE
You have to tell me if I need to STOP, DROP or ROLL
If I tell you there's a GORGE, you send back STOP
If I tell you there's a PHREAK, you send back DROP
If I tell you there's a FIRE, you send back ROLL
Sometimes, I will send back more than one! Like this: 
GORGE, FIRE, PHREAK
In this case, you need to send back STOP-ROLL-DROP!

To get the flag we likely have to beat the game, because we don't know how long it will take to do so. it's probably best to write a script to play the game for us.

```python
from nclib.netcat import Netcat

import sys

  

fray_dict = {

    "GORGE": "STOP",

    "PHREAK": "DROP",

    "FIRE": "ROLL"

}

  

def dict_replace(response:list[str]) -> str:

    reply_list = []

    for word in response:

        word = word.strip()

        reply_list.append(fray_dict[word])

    reply = "-".join(reply_list)

    return reply

nc = Netcat((sys.argv[1], int(sys.argv[2])), verbose=True)

  
  

nc.recv_until("(y/n)")

nc.send_line("y")

response = nc.recv_until("What do you do?").decode().splitlines()[1].split(", ")

reply = dict_replace(response)

nc.send_line(reply)

  

while not nc.eof:

    response = nc.recv_until("What do you do?").decode().splitlines()[0].split(", ")

    if nc.eof:

        break

    reply = dict_replace(response)

    nc.send_line(reply)
```

Running this against the given ip and port gives the flag HTB{1_wiLl_sT0p_dR0p_4nD_r0Ll_mY_w4Y_oUt!}