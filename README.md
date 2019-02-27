## Build e Deploy de projetos QT

Para enviar os scripts de configuração para o servidor, execute:

```
./dockerScp URL_SERVIDOR_KUBE_MASTER USUARIO_SERVIDOR_KUBE_MASTER
```

Exemplo:
```
./dockerScp 192.168.6.95 servervm-ithappens
```

### Build e Deploy de projetos QT

Explicando os arquivos:

- *k8sPrepare.sh*: Constrói última versão de imagem docker, a versiona e sobe para o repositório oficial de imagens do Grupo Mateus.
    
    Utilização:
    
    ```
    ./k8sPrepare.sh $DockerAppEnvi $DockerAppName
    ```
    
    Exemplo: 
    ```
    ./k8sPrepare.sh hom wmscd
    ```    
- *k8sQtStart.sh*: Executa o deploy da aplicação, definindo pasta do app (última versão), libs, número de cpus, porta do container, porta do hostserver.
    
    Utilização:
            
    ```
    ./k8sQtStart.sh $QTVERSION $BINARYEnv $BINARYApp
    ```
        
    Exemplo: 
    ```
    ./k8sQtStart.sh 5.9.6 hom wmscd 
    ```
- *k8sQt59Start.sh*: Atalho do script *k8sQtStart.sh*, com Lib default do Qt 5.9.6.
    
    Utilização:
        
    ```
    ./k8sQt59Start.sh $BINARYEnv $BINARYApp 
    ```
        
    Exemplo: 
    ```
    ./k8sQt59Start.sh hom wmscd 
    ```    
- *k8sTemplate.sh*: Template de arquivo .yaml para criação de deploys automáticos.



...