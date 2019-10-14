#!/bin/bash

#configuracao do servidor
BINARYEnv=$1
BINARYApp=$2
LastName=$3
extraParam=$4

## verifica se terceiro parametro é igual a "restart", "roolback" ou "status"
if [ "$3" == "restart" ];
then
    LastName=""
    extraParam=$3
elif [ "$3" == "roolback" ]; then
    LastName=""
    extraParam=$3
elif [ "$3" == "status" ]; then
    LastName=""
    extraParam=$3
elif [ "$3" == "stop" ]; then
    LastName=""
    extraParam=$3
fi

while :
do
  case $extraParam in
	restart)
		echo "reiniciando aplicação..."
		break
		;;
	status)
		echo "Status da aplicação..."
		/usr/local/appversion/status.sh $BINARYEnv $BINARYApp $LastName
		exit 0
		;;
	stop)
		echo "Stop da aplicação..."
		/usr/local/appversion/stop.sh $BINARYEnv $BINARYApp $LastName
		exit 0
		;;
	roolback)
		echo "Roolback da aplicação..."
		/usr/local/appversion/roolback.sh  $BINARYEnv $BINARYApp $LastName
		exit 0
		;;
	*)
		echo "Iniciando deploy ..."
		break
		;;
  esac
done

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
BINARYInstallApp=$BINARYInstallApp' '$extraParam

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


find -iname '*.so' -exec chmod -x {} \;
find -iname '*.so' -exec cp {} $BINARYBuildDirAPP \;
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