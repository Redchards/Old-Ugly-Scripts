#!/bin/bash
echo  "
                            ***************************************
                          *                                         *
                         *                 BIENVENUE                 *
                         *                                           *
    *****     ***        *     CE SCRIPT VOUS AIDERA A CONVERTIR     *
   **     ****   ***     *      DES FICHIERS AUDIOS ET VIDEOS A      *
  ***   Q         **    *       L'AIDE DU LOGICIEL AVCONV SANS       *
 *****            *    *        PASSER PAR LA LIGNE DE COMMANDE      *
******    *******    *        IL VOUS SUFFIRA SIMPLEMENT DE SUIVRE   *
******   *             *             LES ETAPES INDIQUEES            *
******   *       **     *                                            *
*****     ****  *  *     *                                           *
*****     ****  *  *     *      Pour en savoir plus sur avconv,      *
 ****        * *   *     *      se rendre a l'adresse suivante:      *
  ** *    * * *  **       *           http://libav.org/             *
      *   *  *  *           ***************************************
     *     *  *
     *         *

"

contains()
{
    local array="$1[@]"
    local seeking=$2
    local valid=1
    for element in "${!array}"
    do
	if [[ $element == $seeking ]]
	then
	    valid=0
	    break
	fi
    done
    echo $valid
    return $valid
}

#FORMAT_TO_CONVERT=$1
DEFAULT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
FINAL_PATH=$DEFAULT_PATH
NAUTILUS_DIRECTORIES=( '~/.gnome2/nautilus-scripts', '/home/'$USER'/.local/share/nautilus/scripts/' )
for DIRECTORY in ${NAUTILUS_DIRECTORIES[@]}
do
    if [ -d $DIRECTORY ]
    then
        NAUTILUS_WORKING_DIRECTORY=$DIRECTORY
    fi
done
if [ -z "$NAUTILUS_WORKING_DIRECTORY" ]
then
    echo "Impossible de trouver nautilus, le script s'effectura donc en mode texte seulement"
fi
echo -e "Le dossier par défaut est le dossier où se trouve celui-ci et est actuellement : $DEFAULT_PATH\nVoulez vous conserver le dossier par défaut [y/n] ?"
read keepDefault
while [[ ! $keepDefault =~ ^[y/n]+$ ]]; 
do 
    echo "La réponse n'est pas valide, veuillez répondre par 'y' ou par 'n'"; 
    read keepDefault; 
done
if [ $keepDefault == y ]
then
    echo -e "Le dossier par défaut sera conservé"
else
    echo -e "Veuillez indiquer le nouveau chemin du fichier sous la forme d'une chaîne de caractère entourée par des guillemets ( ' ' ) si votre chemin contient des espaces :\n"
    read newPath
    FINAL_PATH=${newPath//[\']/}
    while [ ! -d $FINAL_PATH ]
    do
	echo -e "Impossible de trouver le dossier spécifié, veuillez réessayer en vérifiant que le dossier existe et que vous avez bien les droits nécessaires pour lire et écrire à l'intérieur\n"
	read newPath
	FINAL_PATH={newPath//[\']/}
    done
    echo -e "Le dossier "$FINAL_PATH" a été trouvé avec succès"
fi
	    
AUDIO_FORMATS=( 'ac3'
		'au'
		'dts'
		'flac'
		'ipod'
		'mp3'
		'oma'
		'oss'
		'wma')
AUDIO_FILES=( Aucun )


VIDEO_FORMATS=( '3gp'
		'3g2'
		'a64'
		'avi'
		'avm2'
		'dv'
		'dvd'
		'flv'
		'gif'
		'gxf'
		'mjpeg'
		'mov'
		'mp4'
		'mpeg'
		'mxf'
		'ogg'
		'rm'
		'wav')
VIDEO_FILES=( Aucun )

CONVERTIBLES_FILES=()
i=0
#  diff "$file" "/some/other/path/$file"
#  read line </dev/tty
IFS='
'
set -f
echo -e "Recherche des fichiers audios disponibles dans le dossier en cours\n"
for format in "${AUDIO_FORMATS[@]}"
do
    for audioFile in $(find $FINAL_PATH -maxdepth 1 -type f -iname "*.$format" -exec sh -c 'file="$0"
  echo "$file"

' {} ';')
    do
    	AUDIO_FILES[i++]=$audioFile
    done
done
numberAudioFound=${#AUDIO_FILES[@]} 
if [ $AUDIO_FILES = "Aucun" ]
then
    numberAudioFound=0
fi
i=0
echo -e "Recherche des fichiers audios terminée, "$numberAudioFound" trouvés\n\n"
echo -e "Recherche des fichiers vidéos disponibles dans le dossier en cours\n"
for format in "${VIDEO_FORMATS[@]}"
do
    for videoFile in $(find $FINAL_PATH -maxdepth 1 -type f -iname "*.$format" -exec sh -c 'file="$0"
  echo "$file"

' {} ';')
    do
    	VIDEO_FILES[i++]=$videoFile
    done
done
i=0
numberVideoFound=${#VIDEO_FILES[@]} 
if [ $VIDEO_FILES = "Aucun" ]
then
    numberVideoFound=0
fi
echo -e "Recherche des fichiers vidéos terminée, "$numberVideoFound" trouvés\n"
if [  $numberVideoFound = "0" ] && [ $numberAudioFound = "0" ]
then
    echo -e "Aucun fichier audio ou vidéo connus dans ce dossier, le script va donc s'arrêter"
    exit
else
    while true
    do
        echo "Voici une liste des fichiers disponibles à la conversion :
-Fichiers audios :
"
	for convertible in ${AUDIO_FILES[@]}
	do
	    i=$(expr $i + 1 )
	    echo "    -"$i" : "$( basename $convertible)
	    CONVERTIBLE_FILES[$(expr $i - 1)]=$convertible
	done
echo "
-Fichiers videos :
"
	for convertible in ${VIDEO_FILES[@]}
	do
	    i=$(expr $i + 1 )
	    echo "    -"$i" : "$( basename $convertible)
	    CONVERTIBLE_FILES[$(expr $i - 1)]=$convertible
	done
	echo -e "Veuillez choisir le numéro du fichier à convertir"
	read chosenIndex
	while [[ ( ! $chosenIndex =~ ^[0-9]+$ ) || ( "$chosenIndex" -gt "$i" ) ]]; do 
	    echo "L'index du fichier que vous demandez n'existe pas, veuillez réessayer avec un index valide"; 
	    read chosenIndex; 
	done
	echo "Choisissez le format dans lequel convertir le fichier ( tapez help pour obtenir la list des formats )"
	read userFormat
	
	while [[ $(contains AUDIO_FORMATS $userFormat) != "0" && $(contains VIDEO_FORMATS $userFormat) != "0" ]] 
	do 
	    if [ $userFormat = "help" ]
	    then
		echo "Les formats audio disponibles sont les suivants :\n"
	        for audioFormat in ${AUDIO_FORMATS[@]}
		do
		    echo "-"$audioFormat
		done
		echo "Les formats videos disponibles sont les suivants :\n"
		for videoFormat in ${VIDEO_FORMATS[@]}
		do
		    echo "-"$videoFormat
		done
		echo -e "ATTENTION, Il est possible que certains formats ne soient pas compatibles !\n Saississez le format vers lequel convertir"
	    else
	   # echo $(contains VIDEO_FORMATS $userFormat) != "0"
	        echo "Le format que vous avez choisis semble être invalide, avez vous écrit correctement le nom de l'extension ?"; 
	    fi
	    read userFormat; 
	done 
	formatType=""
	if [ $(contains AUDIO_FORMATS $userFormat) = "0" ]
	then
	    formatType="audio"
	elif [ $(contains VIDEO_FORMATS $userFormat) = "0" ]
	then
	    formatType="video"
	fi
	CURRENT_FILE=${CONVERTIBLE_FILES[$(expr $chosenIndex - 1)]}
	echo $CURRENT_FILE
	avconv -i $CURRENT_FILE ${CURRENT_FILE%%.*}"."$userFormat
	i=$(expr $i + 1 )
	if [ $formatType = "audio" ]
	then
	    if [ $AUDIO_FILES != "Aucun" ] #Rajouter un test pour voir si le fichier existe déjà
	    then
	    	AUDIO_FILES[${#AUDIO_FILES[@]}]=$( basename ${CURRENT_FILE%%.*}"."$userFormat )
	    else
		AUDIO_FILES["0"]=${CURRENT_FILE%%.*}"."$userFormat
	    fi
	else
	    if [ $VIDEO_FILES != "Aucun" ]
	    then
	        VIDEO_FILES[${#VIDEO_FILES[@]}]=$( basename ${CURRENT_FILE%%.*}"."$userFormat )
	    else
		VIDEO_FILES["0"]=${CURRENT_FILE%%.*}"."$userFormat
	    fi
	fi
	echo -e "Fichier converti vers le format '"$userFormat"'. Il y a cependant malgré tout put y avoir des erreurs ( indications données par avconv ) \n\nVoulez vous continuer à convertir des fichiers dans ce dossier ? [y/n]\n"
	read exitChoice
	while [[ ! $exitChoice =~ ^[y/n]+$ ]] 
	do 
	    echo "La réponse n'est pas valide, veuillez répondre par 'y' ou par 'n'"; 
	    read exitChoice; 
	done
	if [ $exitChoice = "n" ]
	then
	    exit
	fi
	i=0
    done
fi
