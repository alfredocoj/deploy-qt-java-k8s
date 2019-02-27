#!/bin/bash

## versao do Qt
DockerQtVersion=$1
## Release: PRO, HOM, OU DEV
DockerAppEnvi=$2
## Nome da aplicação
DockerAppName=$3
## Dir das Libs do Qt escolhida
DockerQtLibs=/usr/local/appversion/qtlibs/$DockerQtVersion
## Dir base do App
DockerAppDir=/usr/local/appversion/release/$DockerAppEnvi/$DockerAppName
## Nome da pasta Última versao da aplicação
DockerAppVersion=$(cat $DockerAppDir/lastversion.txt)
## Dir da última aplicação
DockerAppLibs=$DockerAppDir/$DockerAppVersion
## Nome da aplicação docker
DockerName="$DockerAppName"_"$DockerAppParam"
## Arquivo de configuracao da aplicacao
DockerAppConfigRun=$DockerAppDir/"$DockerAppParam".ini
## Arquivo com o Template de configuracao base para deploy K8S
K8sFile=/usr/local/appversion/k8sTemplateQt.yaml
## Arquivo com o template para deploy java em k8s
K8sFileTemplateService=/usr/local/appversion/k8sTemplateQtService.yaml
## Arquivo de deploy K8S da última versão da aplicação
K8sFileApp=$DockerAppDir/$DockerAppVersion/$DockerAppName.yaml
## Arquivo de deploy K8S da última versão da aplicação
K8sFileAppService=$DockerAppDir/$DockerAppVersion/$DockerAppName-service.yaml
## Número da Última versão da Imagem Docker da aplicação
DockerImageVersion=$(cat $DockerAppDir/lastversiondocker.txt)
## Nome da Image Docker para a release escolhida
DockerImageName=qt-$DockerAppEnvi-$DockerAppName
## Imagem docker para a última versao da aplicação
DockerImage=192.168.6.184:5000/ithappens/$DockerImageName:$DockerImageVersion
## Imagem docker base para a última versao da aplicação
DockerImageBase=192.168.6.184:5000/ithappens/$DockerImageName
## Arquivo que possui o número da última versão da Image Docker da aplicação e para a release selecionada
FileLastVersionDocker=$DockerAppDir/lastversiondocker.txt
## Arquivo com o número a versão alterior a última versão da imagem docker da aplicação e para a release selecionada
FileOldVersionDocker=/usr/local/appversion/release/$DockerAppEnvi/$DockerAppName/$DockerAppVersion/appOldVersionDocker.txt
## Arquivo com as configurações da aplicação e release selecionada (porta, cpus, memoria, etc.)
FileConfig=$DockerAppDir/app.conf
## Nome do container
containerName=$DockerAppName-container

# LENDO ARQUIVO DE CONFIGURACAO DA APLICAÇÃO
DockerAppParam=`more $FileConfig | grep param | awk -F= '{print $2}'`
declare -i DockerAppPort=`more $FileConfig | grep port | awk -F= '{print $2}'`
DockerAppMaxCore=`more $FileConfig | grep cpus | awk -F= '{print $2}'`
declare -i DockerAppHostPort=300${DockerAppPort: -2}

#DockerAppParam=$4
#declare -i  DockerAppPort=$5
#DockerAppMaxCore=2


rm -rf $DockerAppLibs/*.ini;

echo "docker starting";
echo "docker CPU : " $DockerAppMaxCore


echo "copiando: cp $K8sFile $K8sFileApp ..."

cp $K8sFile $K8sFileApp
cp $K8sFileTemplateService $K8sFileAppService

echo "montando deploy file ..."

########################################################################################################################

### setando parametro refetente ao nome da aplicação

paramSed="s/\${DockerAppName}/"$DockerAppName"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
sed -i $paramSed $K8sFileAppService

########################################################################################################################

### setando parametro refetente ao número de cores para a aplicação

paramSed="s/\${DockerAppMaxCore}/"$DockerAppMaxCore"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp

########################################################################################################################

### setando parametro refetente porta da aplicação

paramSed="s/\${DockerAppPort}/"$DockerAppPort"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
sed -i $paramSed $K8sFileAppService

########################################################################################################################

### setando parametro refetente a porta da aplicação que ficará exposta através do cluster

paramSed="s/\${DockerAppHostPort}/"$DockerAppHostPort"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
sed -i $paramSed $K8sFileAppService

########################################################################################################################
paramSed="s/\${DockerAppParam}/"$DockerAppParam"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp


########################################################################################################################

### setando parametro refetente a pasta das Libs do Qt para criacao de volume

DockerQtLibsParam="\/usr\/local\/appversion\/qtlibs\/"$DockerQtVersion
paramSed="s/\${DockerQtLibs}/"$DockerQtLibsParam"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp

########################################################################################################################

### setando parametro refetente a imagem da aplicação

DockerImageParam="192\.168\.6\.184\:5000\/ithappens\/$DockerImageName\:$DockerImageVersion"
paramSed="s/\${DockerImage}/"$DockerImageParam"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp

########################################################################################################################

# verificacao para criar ou atualizar o deploy

declare -i DockerImageVersionNumber=$(($DockerImageVersion - 1))

if [ $DockerImageVersionNumber -eq 1 ]
then
    kubectl create -f $K8sFileApp --namespace=qt-$DockerAppEnvi --record=true
    kubectl create -f $K8sFileAppService --namespace=qt-$DockerAppEnvi --record=true
else
	kubectl set image -f $K8sFileApp $DockerAppName-container=$DockerImage --namespace=qt-$DockerAppEnvi --record=true
fi

# verifica o status da aplicacao
kubectl rollout status deployment/$DockerAppName --namespace=qt-$DockerAppEnvi
# kubectl rollout undo deployment/$DockerAppName --namespace=qt-$DockerAppEnvi --revision 42

echo "container started on K8s";