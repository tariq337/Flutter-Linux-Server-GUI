#!/bin/bash


x-terminal-emulator -e ssh -t $1@$2 " cd $3 ; exec $SHELL"

