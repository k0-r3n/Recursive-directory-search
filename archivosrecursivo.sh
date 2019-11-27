#! /bin/bash
declare -a arreglo
declare -a archivos
let cont=0
let total_sum=0
let contar=0
let total_sum_arch=0

echo " DIRECTORIOS Y SUBDIRECTORIOS CON ARCHIVOS  "

read -p "Introduzca el nombre de la carpeta :/" carpeta; 

#VARIABLE PARA LA CANTIDAD DE DIRECTORIOS DE FORMA RECURSIVA IGNORANDO ACCESOS
total_directorios=$(find /$carpeta -type d 2>&- | wc -l ) 
total_archivos=$(find /$carpeta -type f 2>&- | wc -l)

if [ "$total_directorios" -eq 1 ]
then
echo " "
echo "No hay subdirectorios."
elif [ "$total_directorios" -gt 1 ]
	then
		echo " "
		echo "El total de directorios en /$carpeta es de : $total_directorios "
		echo "Archivos dentro de /$carpeta : $total_archivos "

elif [ "$total_directorios" -eq 1 -a "$total_archivos" -ge 1 ]
then
	echo "No hay subdirectorios. Archivos dentro de /$carpeta : $total_archivos "
fi


# CASO ARCHIVOS

if [ "$total_archivos" -ge 1 ]
then
find /$carpeta -type f -exec du -sb {} \; 2>&- | sort -hr > lista_archivos.txt
elclipdeword="lista_archivos.txt"

while IFS=$'\n' read -r linea; do
archivos[i]="${linea}"
archivos[i]="$(echo -e "${archivos[i]}" | sed 's/\s.*$//')" 
#echo "${archivos[i]}"
((++i))
done < "$elclipdeword"

#	SUMA PARA SACAR PROMEDIO
for((x=1;x<"${#archivos[@]}";x++))
do
size=("${archivos[x]}")
total_sum_arch=$(bc<<<"${total_sum_arch}+${size}")
#echo "$total"
((contar++))
done

#PROMEDIO
promz=$(printf "%.2f" "$(bc -l <<<"(${total_sum_arch}/${contar})")") 
echo " "
echo "Peso promedio de los archivos : $promz bytes"
#MEDIANA
meda=("${#archivos[@]}")
if(( meda % 2 == 1 )); then
med_final_archivos="${archivos[ $((meda/2)) ]}"
else
med_final_archivos="$(( (archivos[$((meda/2))] + archivos[$((meda/2-1))] ) / 2 ))"
fi

echo "La mediana de tamaños (ARCHIVOS) es: $med_final_archivos bytes"
echo " "

rm lista_archivos.txt
fi


#CASO DIRECTORIOS

if [ "$total_directorios" -gt 1 ]
then
#SE GENERA UNA LISTA DE LOS DIRECTORIOS DE TIPO TEXTO IGNORANDO ACCESOS DENEGADOS
find /$carpeta -type d -exec du -sb {} \; 2>&- | sort -hr > lista.txt

heavybois="lista.txt"


#cat $heavybois

#QUITAR ENUNCIADO DESPUES DE ESPACIO
let i=1
while IFS=$'\n' read -r linea; do
    arreglo[i]="${linea}"
    arreglo[i]="$(echo -e "${arreglo[i]}" | sed 's/\s.*$//')" 
    #echo "${arreglo[i]}"
    ((++i))
done < "$heavybois"

#SUMA PARA SACAR PROMEDIO
for((x=1;x<"${#arreglo[@]}";x++))
do
size=("${arreglo[x]}")
total_sum=$(bc<<<"${total_sum}+${size}")
#echo "$total"
((cont++))
done

#PROMEDIO
promz=$(printf "%.2f" "$(bc -l <<<"(${total_sum}/${cont})")") 
echo " "
echo "Peso promedio de los directorios: $promz bytes"

#MEDIANA
med=("${#arreglo[@]}")
if(( med % 2 == 1 )); then
	med_final="${arreglo[ $((med/2)) ]}"
else
	med_final="$(( (arreglo[$((med/2))] + arreglo[$((med/2-1))] ) / 2 ))"
fi

echo "La mediana de tamaños (DIRECTORIOS) es: $med_final bytes"
echo " "

#BORRAMOS ARCHIVOS GENERADOS POR EL SCRIPT
rm lista.txt
fi
