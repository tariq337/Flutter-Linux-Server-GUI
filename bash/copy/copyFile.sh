#!/bin/bash


x-terminal-emulator -e ssh $1@$2 "echo \"run copy $3 => $4\" && cp -P $3 $4 && echo \"Done\" && sleep 2s"


