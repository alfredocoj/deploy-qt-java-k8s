### Build e Deploy de projetos Java

Para enviar os scripts de configuração para o servidor, execute:

```
./k8sJavaScp URL_SERVIDOR_KUBE_MASTER USUARIO_SERVIDOR_KUBE_MASTER
```

Exemplo:
```
./k8sJavaScp 10.0.0.95 k8s-admin
```

Explicando os arquivos:

- *k8sDirsJavaPrepare.sh*: script que cria as pastar necessárias no servidor. Deve ser executado no servidor master do cluster.
    
    Utilização:
    
    ```
    ./k8sDirsJavaPrepare.sh
    ```

- *deployjava.sh*: script que deverá ser executado pelo servidor do jenkins para chamar remotamente o script de deploy (`k8sDeployJava.sh`).
    
    Utilização:
    
    ```
    ./deployjava.sh $APPENV $APPNAME $APP_NOME_IMAGE_DOCKER
    ```
    
    Exemplo: 
    ```
    ./deployjava.sh hom ithappens-report report_ithappens_main
    ```    
- *k8sDeployJava.sh*: Executa o deploy da aplicação java (última versão) com base no arquivo de configuração `app.conf` (número de cpus, porta do container, etc.).
    
    Utilização:
            
    ```
    ./k8sDeployJava.sh $APPENV $APPNAME $APP_NOME_IMAGE_DOCKER
    ```
        
    Exemplo: 
    ```
    ./k8sQtStart.sh hom ithappens-report report_ithappens_main
    ```
- *k8sPrepareTemplate.sh*: Prepara o template de deploy `k8sTemplateJava.yaml`.
    
    Utilização:
        
    ```
    ./k8sPrepareTemplate.sh $APPENV $APPNAME
    ```
        
    Exemplo: 
    ```
    ./k8sPrepareTemplate.sh hom ithappens-report 
    ```    
- *k8sTemplateJava.yaml*: Template de arquivo .yaml para criação de deploy automático para aplicação selecionada.

- *k8sTemplateJavaService.yaml*: Template de arquivo .yaml para criação de service para o deploy automático.
