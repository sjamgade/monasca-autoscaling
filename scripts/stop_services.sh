#!/bin/bash

for service in `tac ~/monasca-autoscaling/scripts/services`
do
	echo "Stopping $service"
	sudo systemctl disable $service
	sudo systemctl stop $service
done
