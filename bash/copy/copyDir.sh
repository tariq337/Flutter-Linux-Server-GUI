#!/bin/bash


x-terminal-emulator -e ssh $1@$2 "echo \" copy $3 => $4\" && cp -r $3 $4 && echo \"Done\" && sleep 2s"


