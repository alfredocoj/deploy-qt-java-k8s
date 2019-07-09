#!/bin/bash
#!/bin/bash

## Release: PRO, HOM, OU DEV
env=$1
## exemplo SpeedAppService
mainName=$2
## update
lastName=$3

K8sAppName=${mainName,,}-${lastName,,}
if [ "$lastName" == "" ];
then
    K8sAppName=${mainName,,}
fi

ssh k8s-admin@192.168.6.95 eval "kubectl delete service/$K8sAppName-service --namespace=qt-$env"
ssh k8s-admin@192.168.6.95 eval "kubectl delete deployment/$K8sAppName --namespace=qt-$env"

DockerAppDir=/usr/local/appversion/release/$env/$mainName$lastName

echo "$DockerAppDir"
## Arquivo com a última versão da aplicação e release selecionadas
ssh k8s-admin@192.168.6.95 eval "rm -rf $DockerAppDir/lastversion.txt"
## Arquivo com a última versão da imagem docker para a aplicação e release selecionadas
ssh k8s-admin@192.168.6.95 eval "rm -rf $DockerAppDir/lastversiondocker.txt"

echo "Parada de aplicação realizado com sucesso!"

#echo "Para reinciar a aplicação, você deve chamar o script uploadqt.sh passando um último parametro chamado 'restart'";

#echo "Após o restart da aplicação, não se esqueça de retirar o parâmetro 'restart'";