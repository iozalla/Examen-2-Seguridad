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
#                  1) CREAR CERT                          #
###########################################################
crearCertificado(){


sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/certificadoNuevo.key -out /etc/ssl/certs/certificadoNuevo.crt

}



###########################################################
#                  2) CONFIGURAR SSL                    #
###########################################################
configurarSSL(){
    sudo apt-get install apache2
    sudo rm /etc/apache2/conf-available/ssl-params.conf
    sudo \cp -r ssl-params.conf /etc/apache2/conf-available/
    sudo \cp -r /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak #por si algo va mal
    echo -e "${RED}EN EL ARCHIVO /etc/apache2/sites-available/default-ssl.conf TIENES QUE EDITAR LAS LINEAS DE SERVER ADMIN Y SERVER NAME CON LO QUE PUSISTRE EN EL CERTIFICADO ${NC}"
    sudo \cp -r default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
    #sudo \cp -r 000-default.conf /etc/apache2/sites-available/000-default.conf
    #read -p "IP externa de tu server: " IP
    #sudo awk "NR==3{print ${IP}}1" /etc/apache2/sites-available/000-default.conf
}


###########################################################
#                  3) GESTIONAR FIREWALL                  #
###########################################################

gestionarFirewall(){
  sudo ufw allow 'Apache Full'
  sudo ufw delete allow 'Apache'

}

###########################################################
#                  4) habilitarCambios                    #
###########################################################
habilitarCambios(){
sudo rm /var/www/html/index.html
sudo \cp -vr index.html /var/www/html
sudo a2enmod ssl
sudo a2enmod headers
sudo a2ensite default-ssl
sudo a2enconf ssl-params
sudo systemctl restart apache2
echo "ya puedes probar la web https://${IP}"
}


###########################################################
#                      SALIR                          #
###########################################################
function todo(){
  crearCertificado
  configurarSSL
  gestionarFirewall
  habilitarCambios
}
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
        echo -e "${YELLOW}1) crearCertificado "
        echo -e "2) configurarSSL "
        echo -e "3) gestionarFirewall    "
        echo -e "4) habilitarCambios    "



				echo -e "9) Fin  "

        echo ""
        read -p "Elige una opcion: " opcionmenuppal
                echo -e "${PURPLE}__________________________________________________________________________________________ ${NC}"

    	case $opcionmenuppal in

   		  1) crearCertificado;;
        2) configurarSSL;;
        3) gestionarFirewall;;
        4) habilitarCambios;;
        5) fin;;

        *) ;;

    	esac

    done

}
main
