#!/bin/bash



x-terminal-emulator -e ssh $1@$2 "echo \" mov $3 => $4\" && mv $3 $4 && echo \"Done\" && sleep .5s"
   


