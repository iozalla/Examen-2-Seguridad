


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


crearClavesServidor(){
  sudo ssh-keygen
}

###########################################################
#                  1) CREAR CLAVE                         #
###########################################################
crearClave(){
  gpg --gen-key
}

###########################################################
#                  2) importar clave                     #
###########################################################
importKey(){
  read -p "Donde se encuentra la clave a importar?" clave
  gpg --import $clave
}
###########################################################
#                  3) DAR TRUST                    #
###########################################################
trust(){
    read -p "A que clave quieres dar trust <sample@mial.com>" clave
    echo -e "Si quieres darle trust a una clave puedes tienes que haber importado la clave publica "
    echo -e "Una vez hecho tendras que teclear 'trust', luego '5' para dar maximo trust, luego 'y' para confirmar y 'quit' para salir "
    gpg --edit-key clave
}



###########################################################
#                  3) VER CLAVES                  #
###########################################################

verClaves(){
  echo -e "${PURPLE}Public KEYS${NC}"
  gpg --list-keys
  echo -e "${PURPLE}Private KEYS${NC}"
  gpg --list-secret-keys --keyid-format=long
}
firmarArchivo(){
  read -p "que archivo quieres firmar? (path completo)" path
  read -p "que clave quieres usar? <sample@mail.com>" clave
  gpg --sign --default-key $clave $path
}

encriptar(){
  read -p "que archivo quieres encriptar? (path completo)" path
  read -p "para quien es el archivo?" remitente
  gpg --encrypt --sign --armor -r $remitente $path

}

desencriptar(){
  read -p "que archivo quieres desencriptar? (path completo)" path
  gpg --decrypt $path > decrypted.txt
}
verificarArchivo(){
  read -p "que archivo quieres verificar? (path completo)" path
  gpg --verify $path
}
#gpg --encrypt --sign --armor -u iozalla001@ikasle.ehu.eus -r iozallaPrueba@gmail.com /home/iozalla/Desktop/a
#gpg --encrypt --sign --armor -r iozalla001@ikasle.ehu.eus -u iozallaPrueba@gmail.com /home/iozalla/Desktop/a

###########################################################
#                      SALIR                          #
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
function export(){
read -p "¿Que clave quieres exportar?\n"
gpg --export -a iozalla001@ikasle.ehu.eus>~/Desktop/publi.asc
gpg --export-secret-key name > ~/Desktop/clavePriva.asc
echo-e "${GREEN}Exportado a ~/clavePrivada.asc"
echo-e "${GREEN}Exportado a ~/publi.asc${NC}"
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
        echo -e "${YELLOW}1) crearClaves "
        echo -e "2) trust "
        echo -e "3) verclaves    "
        echo -e "4) firmarArchivo    "
        echo -e "5) verificarArchivo"
        echo -e "6) encriptar"
        echo -e "7) desencriptar"


        echo -e "8) importar claves"
	echo -e "9) EXPORTAR claves"




				echo -e "10) Fin  "

        echo ""
        read -p "Elige una opcion: " opcionmenuppal
                echo -e "${PURPLE}__________________________________________________________________________________________ ${NC}"

    	case $opcionmenuppal in

   		  1) crearClave;;
        2) trust;;
        3) verClaves;;
        4) firmarArchivo;;
        5) verificarArchivo;;
        6) encriptar;;
        7) desencriptar;;
        8) importKey;;
	9) export;;
        10) fin;;

        *) ;;

    	esac

    done

}
main
