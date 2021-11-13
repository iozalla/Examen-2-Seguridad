
#read -p "Mete la IP" ip
#read -p "Mete el usuario" usuario
ip="35.210.113.44"
usuario="iozalla"




function subirCompleta(){
	read -p "Donde estan los datos que quieres guardar? (direcciones absolutas)" dirCopia
	read -p "Donde quieres guardar la copia?" dirSubida
	#echo 	"-avh $dirCopia $usuario"@"$ip":"$dirSubida"
  rsync -avh $dirCopia $usuario"@"$ip":"$dirSubida
  exit 0
}

function copiaIncremental(){
		#se construye la copia en local una vez esta construida usaremos la funcion subirIncremental para subir la copia al servidor
		read -p "Donde estan los datos que quieres guardar? (direcciones absolutas)" dirCopia
		#read -p "Donde quieres guardar la copia?" dirSubida
		#read -p "Con que archivo comparar" dirComparar
    sudo mkdir -p /var/tmp/copia
    sudo rsync -avh --compare-dest=/var/tmp/copia/ $dirCopia /var/tmp/copia/
		echo "sudo rsync -avh /var/tmp/copia/ $usuario"@"$ip":"$dirSubida"
    rsync -avh /var/tmp/copia/ $usuario"@"$ip":"$dirSubida
    #sudo rm -r /var/tmp/copia
    exit 0
}
function subirIncremental() {
	rsync -avh /var/tmp/copia/ $usuario"@"$ip":"$dirSubida
	#statements
}




function main(){

    opcionmenuppal=0
    while test $opcionmenuppal -ne 1
    do
    	#Muestra el menu
        echo -e "1) Subir copia completa "
				echo -e "2) Crear copia Incremental en local (var/temp/copia)"
				echo -e "3) Subir la copia Incremental creada en 2)"

        echo ""
        read -p "Elige una opcion: " opcionmenuppal
                echo -e "__________________________________________________________________________________________ "

    	case $opcionmenuppal in

   		  1) copiaCompleta;;
				2) copiaIncremental;;
				3) subirIncremental;;
        *) ;;

    	esac

    done

}
main
