#!/bin/bash

for service in `tac ~/scripts/services`
do
	echo "Stopping $service"
	sudo systemctl stop $service
done

