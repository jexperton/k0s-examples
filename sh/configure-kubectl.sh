#!/bin/sh
kubectl config set-cluster k0s --server=${KUBE_URL} --insecure-skip-tls-verify=true
kubectl config set-credentials gitlab --token=${KUBE_TOKEN}
kubectl config set-context ci --cluster=k0s
kubectl config set-context ci --user=gitlab 
kubectl config set-context ci --namespace=${KUBE_NAMESPACE}
kubectl config use-context ci