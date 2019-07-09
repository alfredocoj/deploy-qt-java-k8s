```
openssl genrsa -out financiero-ws.key 2048

openssl req -new -key financiero-ws.key -out financiero-ws.csr \
    -subj "/CN=financeirows.grupomateus.com.br"

openssl x509 -req -days 365 -in financiero-ws.csr -signkey financiero-ws.key \
    -out financiero-ws.crt

kubectl create secret tls financeiro-secret -n java-pro \
  --cert financiero-ws.crt --key financiero-ws.key
```

`nano financeiro-ws-ingress.yaml`

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: financeiro-ws-ingress
spec:
  tls:
  - secretName: financeiro-secret
  rules:
  - host: financeirows.grupomateus.com.br
    http:
      paths:
      - backend:
          serviceName: financeiro-ws-service
          servicePort: 30080
```

```
kubectl apply -f financeiro-ws-ingress.yaml -n java-pro

kubectl describe ingress financeiro-ws-ingress -n java-pro

```

### Referências

https://developer.ibm.com/articles/configuring-ssl-on-private-ingress-for-chain-certificates/

https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-multi-ssl

https://matthewpalmer.net/kubernetes-app-developer/articles/kubernetes-ingress-guide-nginx-example.html

https://kubernetes.io/docs/concepts/services-networking/ingress/

https://cloud.google.com/solutions/configuring-jenkins-kubernetes-engine

https://github.com/kubernetes-sigs/kubespray/issues/3005

https://github.com/kubernetes/ingress-nginx/issues/1242

https://kubernetes.io/docs/concepts/cluster-administration/certificates/#certificates-api

### tutorial 

https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-multi-ssl

https://blacktourmaline.com.br/pt_BR/blog/seu-blog-1/post/kubernetes-cert-manager-let-s-encrypt-12