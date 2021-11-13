#!/bin/bash
###########################################################
#                  INICIALIZACIONES PREVIAS          			#
###########################################################

rutaPrincipal=$( pwd )
RED='\033[0;31m'
NC='\033[0m' #COLOR ORIGINAL
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'

        echo -e "${PURPLE}__________________________________________________________________________________________ "




###########################################################
#                  1) INSTALL APACHE                     #
###########################################################
apacheInstall(){
  dpkg -s apache2 >&/dev/null 	#se mira si existe el paquete apache2 y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 					#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo -e "${GREEN}apache2 already installed${NC}"	#si el codigo es 0 significará que se ha encontrado el paquete y que ya esta instalado

  else 						#si no se instala
    echo "Installing apache2..."
    sudo apt-get --assume-yes install apache2>&/dev/null
    echo -e "${GREEN}Installed${NC}"
  fi							#cerrar el if

}




###########################################################
#                  2) START APACHE                     #
###########################################################
apacheStart(){
  service apache2 status|grep 'Active: active (running)'>&/dev/null 	#se mira si existe el paquete apache2 y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 							#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo -e "${GREEN}Already started${NC}"	#si el codigo es 0 significará que se ha iniciado el apache

  else 						#si no, se inicia
    echo -e "${CYAN}Starting apache${NC}"
    sudo service apache2 start
    echo -e "${GREEN}ApacheStarted${NC}"

  fi							#cerrar el if

}


###########################################################
#                  3) TEST APACHE                     #
###########################################################



###########################################################
#                  4) ABRIR INDEX                     #
###########################################################


###########################################################
#                  5) CREAR INDEX PERSONALIZADO           #
###########################################################
personalIndex(){
  sudo cp index.html /var/www/html/                 #se copia el index.html a la carpeta /var/www/html/
  echo -e "${GREEN}ficheros copiados a /var/www/html/ ${NC}"
  apacheIndex

}
###########################################################
#                  6) CREAR VIRTUALHOST                   #
###########################################################
createVirtualhost(){
  sudo mkdir /var/www/prueba
  sudo mkdir /var/www/prueba/public_html            #creamos las carpetas necesarias
  sudo cp index.html /var/www/prueba/public_html 	 #copiamos el index
  echo "Ficheros copiados a /var/www/prueba/public_html"
  echo "Creando localhost "
  sudo cp ports.conf /etc/apache2/				            #copiamos la configuracion de los puertos a su sitio
  sudo cp prueba.conf/etc/apache2/sites-available  #copiamos la configuracion de la web a su sitio
  sudo a2ensite prueba.conf                        #hacemos el link con la configuracion
  sudo service apache2 restart                        #reiniciamos apache2
  echo -e "${GREEN}LOCALHOST creado ${NC}"

}
###########################################################
#                  7) TEST VIRTUALHOST                   #
###########################################################
virtualhostTest(){
  firefox http://localhost:8888/index.html            #se abre firefox en la direccion http://localhost:8888/index.html

}



###########################################################
#                     20) SALIR                          #
###########################################################

function fin()
{
	echo -e "¿Quieres salir del programa?(S/N)\n"
        read respuesta
	if [ $respuesta == "N" ]
		then
			opcionmenuppal=0
	else
    echo -e "${PURPLE}Asier Astorquiza, Iñigo Ozalla, Iker Valcarcel, Endika Eiros"
    exit 0
  fi
}



###########################################################
#                   ### Main ###                          #
###########################################################

### Main ###
function main(){

    opcionmenuppal=0
    while test $opcionmenuppal -ne 9
    do
    	#Muestra el menu
                echo -e "${PURPLE}__________________________________________________________________________________________ ${NC}"
        echo -e "${YELLOW}1) Instala Apache "
        echo -e "2) Arrancar el servicio apache "
        echo -e "3) Informacion APACHE    "
        echo -e "4) Visualizar web por defecto     "
        echo -e "5) Personalizar index.html     "
        echo -e "6) Crear VIRTUALHOST     "
        echo -e "7) Test VIRTUALHOST     "


				echo -e "9) Fin  "

        echo ""
        read -p "Elige una opcion: " opcionmenuppal
                echo -e "${PURPLE}__________________________________________________________________________________________ ${NC}"

    	case $opcionmenuppal in

   		  1) apacheInstall;;
        2) apacheStart;;
        3) apacheTest;;
        4) apacheIndex;;
        5) personalIndex;;
        6) createVirtualhost;;
        7) virtualhostTest;;
        8) fin;;

        *) ;;

    	esac

    done

}
main
