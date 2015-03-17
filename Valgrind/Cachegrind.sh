#!/bin/bash
ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
#/`basename "${BASH_SOURCE[0]}"`
PROJECT_NAME=$( basename $ABSOLUTE_PATH )
DATETIME=$(eval date +%Y%m%d%H%M%s)
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
G_SLICE=always-malloc G_DEBUG=gc-friendly  valgrind -v  --tool=cachegrind --branch-sim=yes --simulate_cache=yes --cachegrind-out-file=$FULL_PATH'cachegrindoutput.'$DATETIME --log-file=$FULL_PATH' cachecheck.log' $FULL_PATH
