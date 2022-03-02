#!/bin/sh
# create namespace if doesn't exist 
kubectl create namespace ${KUBE_NAMESPACE} 2> /dev/null || true

# add credentials to pull image from gitlab
kubectl create secret docker-registry gitlab-registry \
    --docker-server="${CI_REGISTRY}" \
    --docker-username="${CI_DEPLOY_USER}" \
    --docker-password="${CI_DEPLOY_PASSWORD}" \
    --docker-email="${GITLAB_USER_EMAIL}" \
    -o yaml --dry-run=client | kubectl apply -f -

# replace __tokens__ in yaml files with real values
find manifests -type f -exec sed -i -e 's|__CI_REGISTRY_IMAGE__|'${CI_REGISTRY_IMAGE}'|g' {} \;
find manifests -type f -exec sed -i -e 's|__CI_COMMIT_SHORT_SHA__|'${CI_COMMIT_SHORT_SHA}'|g' {} \;
find manifests -type f -exec sed -i -e 's|__CI_PROJECT_NAME__|'${CI_PROJECT_NAME}'|g' {} \;
find manifests -type f -exec sed -i -e 's|__KUBE_INGRESS_HOST__|'${KUBE_INGRESS_HOST}'|g' {} \;

# deploy image to cluster
kubectl apply -f manifests/

# check if app is ready, timeout after 4 minutes
DURATION=0
while true; do
    if [ "$(wget --no-check-certificate -qO- https://${KUBE_INGRESS_HOST}/version)" = "${CI_COMMIT_SHORT_SHA}" ]; then
        echo "\nDeployment succeeded."
        echo "URL: https://${KUBE_INGRESS_HOST}/version\n"
        exit 0
    elif [ $DURATION -gt 240 ]; then
        echo -e "\nFailed to deploy.\n"
        exit 1
    else
        echo "Not ready, retrying in 15 seconds."
        DURATION=$((${DURATION}+15))
        sleep 15
    fi
done