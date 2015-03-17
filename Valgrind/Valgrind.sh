#!/bin/bash
ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
#/`basename "${BASH_SOURCE[0]}"`
PROJECT_NAME=$( basename $ABSOLUTE_PATH )
i=0
Dirlist=()
for dir in `find $ABSOLUTE_PATH'/bin' -type d`; do
Dirlist[i++]=$dir
done
#$ ls -l $ABSOLUTE_PATH'/bin' | grep “^d”
ListRange=${#Dirlist[@]}
BuildNumber=$((ListRange - 1))
echo 'Il y a' $BuildNumber  'types de build disponibles'
echo "Veuillez indiquer le type de build à tester"
for((i=1;i<=$BuildNumber;i++))
do
    echo $i $(basename ${Dirlist[i]})
done
read BuildMod
if [[ $BuildMod =~ ^[0-9]+$ ]]
then
	if [ $BuildMod -ge $ListRange ]
	then
		Default=$( basename ${Dirlist[1]})
		BUILD_MODE=$Default
		echo "Impossible de trouver le type de build, utilisation de $Default par défaut"
	else
		BUILD_MODE=$( basename ${Dirlist[BuildMod]})
	fi
else
	echo "La saisie n'est pas valide, veuillez saisir un nombre entre 1 et "$BuildNumber"/n/nSaisie ayant provoquée l'erreur : "$BuildMod
fi
FULL_PATH=$ABSOLUTE_PATH'/bin/'$BUILD_MODE'/'$PROJECT_NAME 
if [ ! -f $FULL_PATH ]
then
	echo "Impossible de trouver l'executable, arrêt du script"
	exit 1
fi
G_SLICE=always-malloc G_DEBUG=gc-friendly  valgrind -v --tool=memcheck --leak-check=full --track-origins=yes --trace-children=yes --time-stamp=yes --xml=yes --xml-file=$FULL_PATH' memcheck.xml' --read-var-info=yes --num-callers=40 --log-file=$FULL_PATH' memcheck.log' $FULL_PATH

sed '1d' $FULL_PATH' memcheck.xml' > $FULL_PATH' memchecktemp.xml'
mv $FULL_PATH' memchecktemp.xml' $FULL_PATH' memcheck.xml'

echo "$(echo '<?xml-stylesheet href="valgrind.xsl" type="text/xsl" ?>' | cat - $FULL_PATH' memcheck.xml')" > $FULL_PATH' memcheck.xml'


echo "$(echo '<?xml version="1.0"?>' | cat - $FULL_PATH' memcheck.xml')" > $FULL_PATH' memcheck.xml'

