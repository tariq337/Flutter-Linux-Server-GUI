#!/bin/bash



x-terminal-emulator -e ssh $1@$2 "echo \"delet $3\" && rm -r $3 && echo \"Done\" && sleep .5s"




