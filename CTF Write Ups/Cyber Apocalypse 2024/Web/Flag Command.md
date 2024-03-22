# Description

Embark on the "Dimensional Escape Quest" where you wake up in a mysterious forest maze that's not quite of this world. Navigate singing squirrels, mischievous nymphs, and grumpy wizards in a whimsical labyrinth that may lead to otherworldly surprises. Will you conquer the enchanted maze or find yourself lost in a different dimension of magical challenges? The journey unfolds in this mystical escape!

# My Solution

Going to the webpage, we're presented with a text based game with seemingly no solution. We can inspect the source of the webpage and see that there's a secret command. Putting the secret command in gives us the flag
HTB{D3v3l0p3r_t00l5_4r3_b35t_wh4t_y0u_Th1nk??!}

# Others solution

Looking at the network tab of the dev console, there's a request made to the options API. Expanding that gives all of the available options. Inputting the secret option gives the flag HTB{D3v3l0p3r_t00l5_4r3_b35t_wh4t_y0u_Th1nk??!}