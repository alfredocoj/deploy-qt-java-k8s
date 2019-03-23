#### Criação de permissões de usuários para dashboard

Aqui são encontrados os scripts para criação de usuários para determinados perfis: admin, edit, view.

#### Criação de conta de serviço administrativa e a vinculação de função do cluster

1. Crie um arquivo chamado eks-admin-service-account.yaml com o texto abaixo. Este manifesto define uma conta de serviço e uma vinculação da função do cluster chamadas eks-admin.

```sh
apiVersion: v1
kind: ServiceAccount
metadata:
  name: eks-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: eks-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: eks-admin
  namespace: kube-system
```

Aplique a conta de serviço e a vinculação da função do cluster ao cluster:
```sh
kubectl apply -f eks-admin-service-account.yaml
```

Resultado:
```sh
serviceaccount "eks-admin" created
clusterrolebinding.rbac.authorization.k8s.io "eks-admin" created
```

#### Crinado usuario de leitura para um namespace específico:

```sh
# kubectl create serviceaccount reader-user-qt-pro -n qt-pro
# kubectl create rolebinding reader-user-qt-pro -n qt-pro --clusterrole=view --serviceaccount=qt-pro:reader-user-qt-pro
```
#### Referências

[Tutorial - criação de usuário administrativo de cluster](https://unofficialism.info/posts/accessing-rbac-enabled-kubernetes-dashboard/)

[Doc Official -  Role and Clusterrole](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole)

[Doc Official - Service account tokens](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#service-account-tokens)

[Doc Official - Service account](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#service-account-permissions)

[Documentação oficial - Controle de acesso](https://github.com/kubernetes/dashboard/wiki/Access-control)

[Securança em dashboard K8s](https://blog.heptio.com/on-securing-the-kubernetes-dashboard-16b09b1b7aca)

[Documentação oficial - Criando usuário de exemplo](https://github.com/kubernetes/dashboard/wiki/Creating-sample-user)