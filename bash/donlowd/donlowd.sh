#!/bin/bash



x-terminal-emulator -e "rsync -avz -e ssh $1 $2"
 
