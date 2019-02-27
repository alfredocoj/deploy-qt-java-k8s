#!/bin/bash

## release (PRO, HOM ou DEV)
AppEnv=$1
## Nome da aplicação
AppName=$2
## Nome imagem docker
DockerImageNameLatest=$3

BINARYSERVER=192.168.6.95
BINARYSERVERUSER=k8s-admin
BINARYSERVERPASS=!coalizao

scriptDeployAppJava='/usr/local/appjavaversion/k8sDeployJava '$AppEnv
scriptDeployAppJava=$scriptDeployAppJava' '$AppName
scriptDeployAppJava=$scriptDeployAppJava' '$DockerImageNameLatest

## validacao de parametro env
if [ "$AppEnv" == "pro" ]; then
	AppEnv=pro
elif [ "$AppEnv" == "PRO" ]; then
	AppEnv=pro
elif [ "$AppEnv" == "hom" ]; then
	AppEnv=hom
elif [ "$AppEnv" == "HOM" ]; then
	AppEnv=hom
elif [ "$AppEnv" == "dev" ]; then
	AppEnv=dev
elif [ "$AppEnv" == "DEV" ]; then
	AppEnv=dev
else
	printf 'Erro: ambiente não reconhecido, escolha pro(produção), hom(homologação), dev(desenvolvimento) \n\r \n\r';
	exit 2;
fi

echo "Processando deploy"
export cmd="bash $scriptDeployAppJava";
echo "$cmd"
export var=$(ssh $BINARYSERVERUSER@$BINARYSERVER eval "$cmd");
echo "Deploy finalizado"
