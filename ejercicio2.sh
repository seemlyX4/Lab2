#!/bin/bash
comando=$1
#Verficar que se ingreso un argumento
if [ $# -ne 1 ];then
	echo "ERROR: Ingresar comando del proceso que desea monitorear"
	exit 1
fi

#Archivo para guardar los datos del monitoreo
LOG_FILE="monitor.log"
echo "Fecha,Hora,CPU(%),Memoria(%)" > "$LOG_FILE"

#Ejecutador el comando en segundo plano y guardado el PID (ID del proceso) para despues
"$@" &
PROCESS_PID=$!
echo "Precione Ctrl + C para salir"
#Bucle de monitoreo

while ps -p "$PROCESS_PID" > /dev/null; do
	USAGE=$(ps -p "$PROCESS_PID" -o %cpu,%mem --no-headers)
	echo "$(date +"%Y-%m-%d,%H:%M:%S"),$USAGE" >> "$LOG_FILE"
	sleep 1 #toma 1 medicion por segundo
done

#Grafica
gnuplot -e "set terminal png; set output 'monitor.png'; plot '$LOG_FILE' using 2:3 with lines title 'CPU (%)' , '' using 2:4 with lines title 'Memoria (%)'"


