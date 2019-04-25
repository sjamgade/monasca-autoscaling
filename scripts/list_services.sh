#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

for service in `cat ~/scripts/services`
do
	active=`sudo systemctl is-active $service`
	if [ $active = "active" ]; then
		status="${green}active${reset}"
	else
		status="${red}inactive${reset}"
	fi
	echo "Service $service is $status."
done
