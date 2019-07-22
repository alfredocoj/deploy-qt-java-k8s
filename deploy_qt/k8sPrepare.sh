#!/bin/bash

## Release selecionada: PRO, HOM, DEV
DockerAppEnv=$1
## Nome da aplicação selecionada
DockerAppName=$2
LastName=$3
## Nome do arquivo Dockerfile
DockerFile="Dockerfile"
## Nome do script para start da aplicação
k8sRun="k8sRun.sh"
## Dir base da aplicação e release selecionadas
DockerAppDir=/usr/local/appversion/release/$DockerAppEnv/$DockerAppName$LastName
## Nome da pasta com a última versão da aplicação e release selecionadas
DockerAppVersion=$(cat $DockerAppDir/lastversion.txt)
## Número da última versão da imagem docker para a aplicação e release selecionadas
DockerImageVersion=$(cat $DockerAppDir/lastversiondocker.txt)
## Número da última versão da imagem docker a ser disponibilizada para a aplicação e release selecionadas
DockerImageVersionLatest=$(($DockerImageVersion +1))
## Arquivo com o número da última versão da imagem docker a ser disponibilizada para a aplicação e release selecionadas
FileLastVersionDocker=$DockerAppDir/lastversiondocker.txt
## Arquivo .ini com as configurações para aplicação rodar na release selecionada
FileAppIni=$DockerAppDir/app.ini
## Alias da Dir base da aplicação e release selecionadas
DirAppRelease=$DockerAppDir
## Dir da última versão da aplicação e release selecionadas
DirAppReleaseVersion=$DockerAppDir/$DockerAppVersion
## Dir da pasta docker
DirDocker=$DirAppRelease/docker
## Dir de volume com os arquivos da aplicação que deversão subir
DirAppLast=$DirDocker/app
## Arquivo com o número da versão alterior a última versão que estão em release
FileOldVersionDocker=$DockerAppDir/$DockerAppVersion/appOldVersionDocker.txt
## Nome para imagem docker (auxiliar)
ImageNameDocker=${DockerAppName,,}
DockerImageName="qt-"$DockerAppEnv"-"$ImageNameDocker
## Última versão da imagem docker a ser disponibilizada para a aplicação e release selecionadas
DockerImage=192.168.6.184:5000/ithappens/$DockerImageName:$DockerImageVersionLatest

mkdir -p $DirDocker
mkdir -p $DirAppLast

rm -f $DirAppLast/gmcore_db.ini
rm -f $DirAppLast/app.ini
cp $FileAppIni $DirAppLast/gmcore_db.ini
cp $FileAppIni $DirAppLast/app.ini
cp $FileAppIni $DirAppLast/$DockerAppName.ini
cp $FileAppIni $DirAppLast/$DockerAppName"_db.ini"
cp -R $DirAppReleaseVersion/* $DirAppLast/

cp /usr/local/appversion/dockerfileTemplateK8s $DirDocker/$DockerFile
cp /usr/local/appversion/$k8sRun $DirDocker/
cp /usr/local/appversion/odbcinstfiles/odbc.ini $DirDocker/
cp /usr/local/appversion/odbcinstfiles/odbcinst.ini $DirDocker/

cd $DirDocker

docker build . -t qt-$ImageNameDocker #--build-arg DIR_APP_RELEASE="$DirAppReleaseVersion"

IdImage=$(docker images -q qt-$ImageNameDocker)

docker tag $IdImage 192.168.6.184:5000/ithappens/$DockerImageName:$DockerImageVersionLatest

docker push 192.168.6.184:5000/ithappens/$DockerImageName:$DockerImageVersionLatest

#rm -rf $DirDocker/$DockerFile
#rm -rf $DirDocker/$k8sRun
#rm -rf $DirAppLast

if [ -f $FileLastVersionDocker ]
then
	cp $FileLastVersionDocker $FileOldVersionDocker
	echo -e $(($DockerImageVersionLatest)) > $FileLastVersionDocker
else
    # se file lastversiondocker não existe para a aplicação, então é criado e setado valor 1
    touch $FileLastVersionDocker
	echo -e "1" > $FileLastVersionDocker
	DockerImageVersionLatest=1
fi

# docker run -v /opt/qt59:/usr/local/user/qtlibs/ -v /home/flavio/app:/usr/local/user/app -e PARAMS="" --name="debian_qt59" debian
# docker run -it -e DISPLAY=$DISPLAY -e XDG_RUNTIME_DIR=/tmp/runtime-developer -v /tmp/.X11-unix:/tmp/.X11-unix -v /usr/local/appversion/qtlibs/Qt5.9.6:/home/user/qtlibs --name="qt-gmcorewmscd" qt-gmcorewmscd:latest