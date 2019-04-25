#!/bin/bash

for service in `cat ~/monasca-autoscaling/scripts/services`
do
	echo "Starting $service"
	sudo systemctl enable $service
	sudo systemctl start $service
done
