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

ssh k8s-admin@192.168.6.95 "kubectl rollout status deployment/$K8sAppName --namespace=qt-$env"

echo "Após o restart da aplicação, não se esqueça de retirar o parâmetro 'status'";