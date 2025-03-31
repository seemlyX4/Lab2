#!/bin/bash

#Paths del directorio y log
Log="/tmp/log_cambios.txt"
Path="/tmp"
echo "Monitoreando /tmp, los cambios se guardaran en $Log"

#Monitoreo
inotifywait -m "$Path" -e create,modify,delete --exclude "$Log" | while read evento
do
	echo "$(date '+%H:%M:%S') $evento" >> "$Log"
	echo "$evento"
done
