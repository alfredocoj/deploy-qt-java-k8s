#!/bin/bash
#!/bin/bash

## Release: PRO, HOM, OU DEV
env=$1
## exemplo SpeedAppService
mainName=$2
## update
lastName=$3

K8sAppName=${mainName,,}-${lastName,,}

ssh k8s-admin@192.168.6.95 eval "kubectl delete deployment/$K8sAppName --namespace=qt-$env"
#ssh k8s-admin@192.168.6.95 eval "kubectl delete service/$K8sAppName-service --namespace=qt-$env"
ssh k8s-admin@192.168.6.95 eval "kubectl rollout status deployment/$K8sAppName --namespace=qt-$env"

echo "Para realizar o restart, você deve chamar o script uploadqt.sh e passar um quarto parametro chamado 'restart'";

echo "Após o deploy, retire o quarto parametro chamado 'restart'";