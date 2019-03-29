### Build e Deploy de projetos QT

Para enviar os scripts de configuração para o servidor, execute:

```
./dockerScp URL_SERVIDOR_KUBE_MASTER USUARIO_SERVIDOR_KUBE_MASTER
```

Exemplo:
```
./dockerScp 192.168.6.95 k8s-admin
```

Explicando os arquivos:


- *uploadqt.sh*: realiza um upload da aplicacao qt e chama automaticamente o script de deploy ou instalação da aplicação em ambiente kubernetes.
    
    Utilização:
    
    ```
    ./uploadqt.sh $DockerAppEnvi $DockerAppName $DockerAppLastName
    ```
    
    Exemplo: 
    ```
    ./k8sPrepare.sh hom wmscd app
    ``` 
    Para realizar um **restart** após **parar** a aplicação é só passar um quarto parâmetro 'restart'. Exemplo:
    ```
    ./k8sPrepare.sh hom wmscd app restart
    ```
    **Obs.:** Não esquecer de retirar o parâmetro **restart** para os **próximos deploys**.
    

- *installqt.sh*: realiza um deploy da aplicacao qt em ambiente kubernetes.
    
    Utilização:
    
    ```
    ./installqt.sh $DockerAppEnvi $DockerAppName $DockerAppLastName
    ```
    
    Exemplo: 
    ```
    ./k8sPrepare.sh hom wmscd app
    ``` 

- *k8sDirsQtPrepare.sh*: script que cria as pastar necessárias no servidor. Deve ser executado no servidor master do cluster.
    
    Utilização:
    
    ```
    ./k8sDirsQtPrepare.sh
    ```

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
- *k8sTemplateQt.yaml*: Template de arquivo .yaml para criação de deploy automático.

- *status.sh*: script para ver o status de algum deploy específico.
    Utilização:
            
        ```
        ./status.sh $BINARYEnv $BINARYApp $LastNameApp
        ```
            
        Exemplo: 
        ```
        ./status.sh hom wmscd app
        ```  

- *stop.sh*: script de parada para algum deploy específico.
    Utilização:
            
        ```
        ./stop.sh $BINARYEnv $BINARYApp $LastNameApp
        ```
            
        Exemplo: 
        ```
        ./stop.sh hom wmscd app
        ```    

- *roolback.sh*: script para executar roolback de algum deploy específico para a última versão.
    Utilização:
            
        ```
        ./roolback.sh $BINARYEnv $BINARYApp $LastNameApp
        ```
            
        Exemplo: 
        ```
        ./roolback.sh hom wmscd app
        ```  
