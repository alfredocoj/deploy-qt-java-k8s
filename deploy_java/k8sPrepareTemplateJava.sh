#!/bin/bash

AppEnv=$1
AppName=$2

DirBase=/usr/local/appjavaversion/release
AppDir=$DirBase/$AppEnv/$AppName
DockerImageVersionLatest=$(cat $AppDir/lastversiondocker.txt)
## Arquivo com as configurações da aplicação e release selecionada (porta, cpus, memoria, etc.)
FileConfig=$AppDir/app.conf
## Arquivo com o Template de configuracao base para deploy K8S
K8sFile=/usr/local/appjavaversion/k8sTemplateJava.yaml
## Arquivo com o template para deploy java em k8s
K8sFileTemplateService=/usr/local/appjavaversion/k8sTemplateJavaService.yaml
## Arquivo de deploy K8S da última versão da aplicação
K8sFileApp=$AppDir/$DockerImageVersionLatest/$AppName.yaml
## Arquivo de deploy K8S da última versão da aplicação
K8sFileAppService=$AppDir/$DockerImageVersionLatest/$AppName-service.yaml
## Nome da Image Docker para a release escolhida
DockerImageName=java-$AppEnv-$AppName
## Imagem docker para a última versao da aplicação
#DockerImage=192.168.6.184:5000/ithappens/$DockerImageName:$DockerImageVersionLatest
DockerImage=10.54.0.214:5001/ithappens/$DockerImageName:$DockerImageVersionLatest

# LENDO ARQUIVO DE CONFIGURACAO
declare -i DockerAppPort=`more $FileConfig | grep SERVER_PORT | awk -F= '{print $2}'`
DockerAppMaxCore=`more $FileConfig | grep CPUS | awk -F= '{print $2}'`
declare -i DockerAppHostPort=300${DockerAppPort: -2}
CONFIGSERVER_URI=`more $FileConfig | grep CONFIGSERVER_URI | awk -F= '{print $2}'`
ENCRYPT_KEY=`more $FileConfig | grep ENCRYPT_KEY | awk -F= '{print $2}'`
EUREKASERVER_URI=`more $FileConfig | grep EUREKASERVER_URI | awk -F= '{print $2}'`
HOST_NAME=`more $FileConfig | grep HOST_NAME | awk -F= '{print $2}'`
PROFILE=`more $FileConfig | grep PROFILE | awk -F= '{print $2}'`
SERVER_PORT=`more $FileConfig | grep SERVER_PORT | awk -F= '{print $2}'`
URL_TESTE=`more $FileConfig | grep URL_TESTE | awk -F= '{print $2}'`
REPLICAS=`more $FileConfig | grep REPLICAS | awk -F= '{print $2}'`

echo "copiando: cp $K8sFile $K8sFileApp ..."

cp $K8sFile $K8sFileApp
cp $K8sFileTemplateService $K8sFileAppService

echo "montando deploy file ..."

########################################################################################################################
paramSed="s/\${AppName}/"$AppName"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
sed -i $paramSed $K8sFileAppService

########################################################################################################################
paramSed="s/\${DockerAppPort}/"$DockerAppPort"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
sed -i $paramSed $K8sFileAppService

########################################################################################################################
paramSed="s/\${DockerAppHostPort}/"$DockerAppHostPort"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
sed -i $paramSed $K8sFileAppService

########################################################################################################################

#DockerImageParam="192\.168\.6\.184\:5000\/ithappens\/$DockerImageName\:$DockerImageVersionLatest"
DockerImageParam="10\.54\.0\.214\:5001\/ithappens\/$DockerImageName\:$DockerImageVersionLatest"
paramSed="s/\${DockerImage}/"$DockerImageParam"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp

########################################################################################################################
## preparando as variaveis do arquivo: app.conf
#CONFIGSERVER_URI
#ENCRYPT_KEY
#EUREKASERVER_URI
#HOST_NAME
#PROFILE
#SERVER_PORT

paramSed="s/\${CONFIGSERVER_URI}/"$CONFIGSERVER_URI"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
########################################################################################################################

paramSed="s/\${ENCRYPT_KEY}/"$ENCRYPT_KEY"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
########################################################################################################################

paramSed="s/\${EUREKASERVER_URI}/"$EUREKASERVER_URI"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
########################################################################################################################

paramSed="s/\${HOST_NAME}/"$HOST_NAME"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
########################################################################################################################

paramSed="s/\${PROFILE}/"$PROFILE"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
########################################################################################################################

paramSed="s/\${SERVER_PORT}/"$SERVER_PORT"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
########################################################################################################################

paramSed="s/\${DockerAppMaxCore}/"$DockerAppMaxCore"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
########################################################################################################################

paramSed="s/\${URL_TESTE}/"$URL_TESTE"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
########################################################################################################################
paramSed="s/\${REPLICAS}/"$REPLICAS"/g"

echo $paramSed

sed -i $paramSed $K8sFileApp
########################################################################################################################
