#!/bin/bash


x-terminal-emulator -e ssh $1@$2 "sleep .5s && echo \"delet $3\" && unlink $3 && echo \"Done\" && sleep .5s"
