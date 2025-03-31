#!/bin/bash

#Comprobar que el usuario sea root
if [ "$(whoami)" != "root" ]; then
	echo "ERROR: Este script solo puede ejecutarse como root" >&2
	exit 1
fi
echo "Eres root. Continuando..."

#Verificar que el numero de entradas sea 3
if [ $# -ne 3 ]; then
	echo "Faltan argumentos"
	exit 1
fi

#Asignar variableles
User=$1
Group=$2
Path=$3
#Comprobar el Usuario
if ! grep -q "^$User:" /etc/passwd; then
	useradd "$User"
	usermod -aG "$Group" "$User" 
	echo "ERROR: El usuario $User no existe" >&2
	echo "Usuario: $User, creado"
else
	echo "Usuario: $User, ya esxiste" 
fi
#Comprobar el Grupo
if ! grep -q "^$Group:" /etc/group; then
	groupadd "$Group"
	echo "ERROR: El grupo $Group no existe" >&2
	echo "Grupo: $Group, creado"
else
	echo "Grupo: $Group, ya existe"
fi
#Comprobar la Ruta
if [ ! -f "$Path" ]; then
	echo "ERROR: El archivo $Path no existe" >&2
	exit 1
fi

#Propiedad del archivo
chown "$User:$Group" "$Path"
echo "La propiedad de $Path cambiara a $User:$Group"

#Permisos del archivo
chmod 740 "$Path" #-rwxr-----
echo "Permisos de $Path cambiados a 740"
