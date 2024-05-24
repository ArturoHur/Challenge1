#!/bin/bash

# Verifica que se hayan pasado suficientes argumentos
if [ "$#" -ne 8 ]; then
	echo "uso: $0 Nombre_SO Tipo_SO Num_CPUs Memoria_RAM(GB) Tamano_disco(GB) Nombre_SATA Nombre_IDE"
	exit 1
fi

name_MV=$1
type_SO=$2
num_CPUs=$3
memory_RAM_GB=$4
vram_MB=$5
size_Disc_GB=$6
name_Sata=$7
name_IDE=$8

#Crear Máquina Virtual
VBoxManage createvm --name "$name_MV" --ostype $type_SO --register

#Configurar CPUs y Memoria RAM y VRAM
VBoxManage modifyvm "$name_MV" --cpus "$num_CPUs"
VBoxManage modifyvm "$name_MV" --memory $(($memory_RAM_GB * 1024))
VBoxManage modifyvm "$name_MV" --vram "$vram_MB"

#Crear Disco Duro Virtual
VBoxManage createmedium disk --filename "$name_MV.vdi" --size $(($size_Disc_GB * 1024)) --format VDI

#Crear el Controlador SATA y Asociar el Disco Duro Virtual al Controlador Sata
VBoxManage storagectl "$name_MV" --name $name_Sata --add sata
VBoxManage storageattach "$name_MV" --storagectl $name_Sata --port 0 --device 0 --type hdd --medium "$name_MV.vdi"

#Crear el Controlador IDE
VBoxManage storagectl "$name_MV" --name $name_IDE --add ide
VBoxManage storageattach "$name_MV" --storagectl "$name_IDE" --port 0 --device 0 --type dvddrive --medium emptydrive

#Mostrar Configuración
echo "Configuración Creada y Configurada:"
echo "Nombre de la Máquina Virtual: $name_MV"
echo "Tipo de Sistema Operativo: $type_SO"
echo "Número de CPUs: $num_CPUs"
echo "Memoria RAM: $memory_RAM_GB GB"
echo "VRAM: $vram_MB MB"
echo "Tamaño del Disco Duro Virtual: $size_Disc_GB GB"
echo "Controlador SATA ($name_Sata) Creado y Asociado al Disco Duro Virtual."
echo "Controlador IDE ($name_IDE) Creado y asociado para CD/DVD."

# Mostrar la configuración final de la MV
VBoxManage showvminfo "$name_MV"