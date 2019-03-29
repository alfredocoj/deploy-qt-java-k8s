#!/bin/bash


usage="$(basename "$0") [-h] [k] [-s n] -- script for upload QT development environment of It Happens (Grupo Mateus).

where:
    -h  show this help text
    -k  create key ssh
    -s  set the seed value (default: 142)"

seed=142

while getopts ':hks:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    s) seed=$OPTARG
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

#configuracao do servidor
BINARYEnv=$1
BINARYApp=$2
LastName=$3
restart=$4
## verifica se terceiro parametro é igual a restart
if [ "$3" == "restart" ];
then
    LastName=""
    restart=$3
fi
BINARYSERVER=192.168.6.95
BINARYSERVERUSER=k8s-admin
BINARYSERVERPASS=!coalizao
BINARYBuildDir=/home/$(whoami)/build/docker
BINARYBuildDirAPP=$BINARYBuildDir/$BINARYApp$LastName
BINARYBuildDirAPPZip=$BINARYBuildDir/$BINARYApp$LastName.zip
BINARYBuildDirAPPZipRemote=/usr/local/appversion/release/$BINARYEnv/$BINARYApp$LastName.zip
BINARYBuildDirAPPBin=$BINARYBuildDirAPP/$BINARYApp
BINARYBuildDirAPPBinApp=$BINARYBuildDirAPP/$BINARYApp
BINARYInstallApp='/usr/local/appversion/installqtteste '$BINARYEnv
BINARYInstallApp=$BINARYInstallApp' '$BINARYApp
BINARYInstallApp=$BINARYInstallApp' '$LastName
BINARYInstallApp=$BINARYInstallApp' '$restart
#BINARYInstallApp=$BINARYInstallApp' '$DockerAppParam
#BINARYInstallApp=$BINARYInstallApp' '$DockerAppPort
# SCRIPT DE LOGS
#IP="127.0.0.1"
##IP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep -v '172.*'`
#LOG="IP: $IP - usuario: $(whoami) - data/hora: $(date +"%Y%m%d/%H%M%S")"
#LogsDIR="/usr/local/appversion/release/$BINARYEnv/$BINARYApp/logs"
#LogFilePath="$LogsDIR/$BINARYApp_logs_$(date +'%Y%m%d').log"
#CommandWriteLog="echo '$LOG' >> $LogFilePath"
#
### verifica se pasta de logs não existe.
#if ! ssh $BINARYSERVERUSER@$BINARYSERVER stat $LogsDIR \> /dev/null 2\>\&1
#then
#    # cria a pasta de logs
#	ssh $BINARYSERVERUSER@$BINARYSERVER eval "mkdir $LogsDIR"
#
#fi

#BINARYInstallApp=pwd

if [ "$BINARYEnv" == "pro" ]; then
	AppVersionDirEnv=$AppVersionDir/pro
elif [ "$BINARYEnv" == "PRO" ]; then
	AppVersionDirEnv=$AppVersionDir/pro
elif [ "$BINARYEnv" == "hom" ]; then
	AppVersionDirEnv=$AppVersionDir/hom
elif [ "$BINARYEnv" == "HOM" ]; then
	AppVersionDirEnv=$AppVersionDir/hom
elif [ "$BINARYEnv" == "dev" ]; then
	AppVersionDirEnv=$AppVersionDir/dev
elif [ "$BINARYEnv" == "DEV" ]; then
	AppVersionDirEnv=$AppVersionDir/dev
else
	printf 'Erro: ambiente não reconhecido, escolha pro(produção), hom(homologação), dev(desenvolvimento) \n\r \n\r';
	exit 2;
fi

if [ -d $BINARYBuildDir ]
then
	rm -rf $BINARYBuildDir/*.*
else
	mkdir -p $BINARYBuildDir;
fi

if [ -d $BINARYBuildDirAPP ]
then
	rm -rf $BINARYBuildDirAPP/*.*
else
	mkdir -p $BINARYBuildDirAPP;
fi

#printf "docker build dir: %s\n" $BINARYBuildDir;
#printf "docker lib dir: %s\n" $BINARYBuildDirAPP;
#printf "docker app path: %s\n" $BINARYBuildDirAPPBin;
#printf "\n";
#printf "Log:Remove +x\n\r"
find -iname '*.so' -exec chmod -x {} \;
#printf "Log:Copy App.libs: %s\n\r " $BINARYBuildDirAPP
find -iname '*.so' -exec cp {} $BINARYBuildDirAPP \;
#printf "Log:Copy App: %s\n\r " $BINARYBuildDirAPP
find -executable -type f -exec cp {} $BINARYBuildDirAPP \;

if ! [ -f $BINARYBuildDirAPPBin ]
then
	printf "ERROR - Binario [%s] não foi encontrado\n" $BINARYBuildDirAPPBin;
	printf "ERROR - Binario [%s] não foi encontrado\n" $BINARYBuildDirAPPBin;
	printf "ERROR - Binario [%s] não foi encontrado\n" $BINARYBuildDirAPPBin;
	printf "ERROR - Binario [%s] não foi encontrado\n" $BINARYBuildDirAPPBin;
    exit 2;
fi

mv $BINARYBuildDirAPPBin $BINARYBuildDirAPPBinApp
chmod +x $BINARYBuildDirAPPBinApp;

echo "Preparando binários"
export var=$(zip -r $BINARYBuildDirAPPZip $BINARYBuildDirAPP)

if ! [ -f $BINARYBuildDirAPPZip ]
then
	printf "impossivel comprimir\n" $BINARYBuildDirAPPZip;
	printf "impossivel comprimir\n" $BINARYBuildDirAPPZip;
	printf "impossivel comprimir\n" $BINARYBuildDirAPPZip;
	printf "impossivel comprimir\n" $BINARYBuildDirAPPZip;
    exit 2;
else
	echo "Enviando binários"
	scp $BINARYBuildDirAPPZip $BINARYSERVERUSER@$BINARYSERVER:$BINARYBuildDirAPPZipRemote;
	export cmd="bash $BINARYInstallApp";
	echo "Instalando binários"
	echo "$cmd"
	export var=$(ssh $BINARYSERVERUSER@$BINARYSERVER eval "$cmd");
	echo "Reiniciando Jobs"
	echo "Processo concluído"
fi

rm -rf $BINARYBuildDirAPP;
rm -rf $BINARYBuildDirAPPZip;