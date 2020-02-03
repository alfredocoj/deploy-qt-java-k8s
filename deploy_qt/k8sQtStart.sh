#!/bin/bash

## versao do Qt
DockerQtVersion=$1
## Release: PRO, HOM, OU DEV
DockerAppEnvi=$2
## Nome da aplicação
DockerAppName=$3
LastName=$4
ConfigName=$LastName
## Dir das Libs do Qt escolhida
DockerQtLibs=/usr/local/appversion/qtlibs/$DockerQtVersion
## Dir base do App
DockerAppDir=/usr/local/appversion/release/$DockerAppEnvi/$DockerAppName$LastName
## Nome da pasta Última versao da aplicação
DockerAppVersion=$(cat $DockerAppDir/lastversion.txt)
## Dir da última aplicação
DockerAppLibs=$DockerAppDir/$DockerAppVersion
## Nome da aplicação docker
##DockerName="$DockerAppName"_"$DockerAppParam"
## Arquivo de configuracao da aplicacao
##DockerAppConfigRun=$DockerAppDir/"$DockerAppParam".ini
## Arquivo com o Template de configuracao base para deploy K8S
K8sFile=/usr/local/appversion/k8sTemplateQt.yaml
K8sFileWithoutLimits=/usr/local/appversion/k8sTemplateQtWithoutLimits.yaml
## Arquivo com o template para deploy java em k8s
K8sFileTemplateService=/usr/local/appversion/k8sTemplateQtService.yaml
## Arquivo de deploy K8S da última versão da aplicação
K8sFileApp=$DockerAppDir/$DockerAppVersion/$DockerAppName.yaml
## Arquivo de deploy K8S da última versão da aplicação
K8sFileAppService=$DockerAppDir/$DockerAppVersion/$DockerAppName-service.yaml
## Número da Última versão da Imagem Docker da aplicação
DockerImageVersion=$(cat $DockerAppDir/lastversiondocker.txt)
## Arquivo que possui o número da última versão da Image Docker da aplicação e para a release selecionada
FileLastVersionDocker=$DockerAppDir/lastversiondocker.txt
## Arquivo com o número a versão alterior a última versão da imagem docker da aplicação e para a release selecionada
FileOldVersionDocker=$DockerAppDir/$DockerAppVersion/appOldVersionDocker.txt
## Arquivo com as configurações da aplicação e release selecionada (porta, cpus, memoria, etc.)

if [[ -z "$4" ]]
then
    ConfigName=app
fi

FileConfig=$DockerAppDir/conf/$ConfigName.conf

if [ ! -f $FileConfig ]
then
    FileConfig=$DockerAppDir/conf/app.conf
fi

# LENDO ARQUIVO DE CONFIGURACAO DA APLICAÇÃO
DockerAppParam=`more $FileConfig | grep param | awk -F= '{print $2}'`
if [[ "$DockerAppParam" == *"port"* ]]
then
    DockerAppPort=9094
else
    declare -i DockerAppPort=`more $FileConfig | grep port | awk -F= '{print $2}'`
fi
LastNameApp=`more $FileConfig | grep lastname | awk -F= '{print $2}'`
DockerAppMaxCore=`more $FileConfig | grep cpus | awk -F= '{print $2}'`
DockerAppMaxMemory=`more $FileConfig | grep memory | awk -F= '{print $2}'`
Node=`more $FileConfig | grep node | awk -F= '{print $2}'`
declare -i NumReplicas=`more $FileConfig | grep replicas | awk -F= '{print $2}'`
declare -i DockerAppHostPort=316${DockerAppPort: -2}

## Nome da Image Docker para a release escolhida
ImageNameDocker=${DockerAppName,,}
K8sAppName=${DockerAppName,,}-${LastNameApp,,}
DockerImageName="qt-$DockerAppEnvi-$ImageNameDocker"
## Imagem docker para a última versao da aplicação
DockerImage=10.54.0.214:5001/ithappens/$DockerImageName:$DockerImageVersion
## Imagem docker base para a última versao da aplicação
DockerImageBase=10.54.0.214:5001/ithappens/$DockerImageName
## Nome do container
containerName=$ImageNameDocker-container

#DockerAppParam=$4
#declare -i  DockerAppPort=$5
#DockerAppMaxCore=2


rm -rf $DockerAppLibs/*.ini;

echo "docker starting";
echo "docker CPU : " $DockerAppMaxCore
echo "docker memory : " $DockerAppMaxMemory

if [ "$DockerAppMaxCore" -eq "0" ]
then
    K8sFile=$K8sFileWithoutLimits
fi

echo "copiando: cp $K8sFile $K8sFileApp ..."

cp $K8sFile $K8sFileApp
cp $K8sFileTemplateService $K8sFileAppService

echo "montando deploy file ..."

########################################################################################################################

### setando parametro refetente ao nome da aplicação

paramSed="s/\${K8sAppName}/"$K8sAppName"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
sed -i $paramSed $K8sFileAppService

########################################################################################################################

### setando parametro refetente ao número de cores para a aplicação

paramSed="s/\${DockerAppMaxCore}/"$DockerAppMaxCore"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp

########################################################################################################################

### setando parametro refetente a quantidade de memória para a aplicação

paramSed="s/\${DockerAppMaxMemory}/"$DockerAppMaxMemory"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp

########################################################################################################################

### setando parametro refetente ao número de replicaspara a aplicação

paramSed="s/\${NumReplicas}/"$NumReplicas"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp

########################################################################################################################

### setando parametro refetente ao Node Agent de replicaspara a aplicação

paramSed="s/\${Node}/"$Node"/g"

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

DockerImageParam="10\.54\.0\.214\:5000\/ithappens\/$DockerImageName\:$DockerImageVersion"
paramSed="s/\${DockerImage}/"$DockerImageParam"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp

########################################################################################################################

# verificacao para criar ou atualizar o deploy

declare -i DockerImageVersionNumber=$(($DockerImageVersion))

if [ $DockerImageVersionNumber -eq 1 ]
then
    echo "Version Docker: $DockerImageVersionNumber"
    kubectl create -f $K8sFileApp --namespace=qt-$DockerAppEnvi --record=true
    #kubectl create -f $K8sFileAppService --namespace=qt-$DockerAppEnvi --record=true
else
	kubectl apply -f $K8sFileApp --namespace=qt-$DockerAppEnvi
	kubectl set image -f $K8sFileApp $K8sAppName-container=$DockerImage --namespace=qt-$DockerAppEnvi --record=true
fi

# verifica o status da aplicacao
kubectl rollout status deployment/$K8sAppName --namespace=qt-$DockerAppEnvi
# kubectl rollout undo deployment/$K8sAppName --namespace=qt-$DockerAppEnvi --revision 42

echo "container started on K8s";