#!/bin/bash

for service in `cat ~/scripts/services`
do
	echo "Starting $service"
	sudo systemctl start $service
done

