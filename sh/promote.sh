#!/bin/sh
# create namespace if doesn't exist 
kubectl create namespace ${KUBE_NAMESPACE} 2> /dev/null || true

# delete existing ingress
kubectl delete ingress \
  --all-namespaces \
  --field-selector metadata.name=api-prod \
  -l app=${CI_PROJECT_NAME},tier=backend
  
# add new ingress
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-prod
  labels:
    app: ${CI_PROJECT_NAME}
    tier: backend
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
spec:
  tls:
    - hosts:
        - ${KUBE_INGRESS_HOST}
      secretName: ${CI_PROJECT_NAME}-api-prod-tls
  rules:
    - host: ${KUBE_INGRESS_HOST}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: api
                port:
                  number: 3000
  ingressClassName: nginx

EOF

echo "https://${KUBE_INGRESS_HOST} is now ${CI_COMMIT_SHORT_SHA}"