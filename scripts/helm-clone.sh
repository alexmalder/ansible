#!/bin/bash

chart_host=https://gitlab.vnmntn.com
chart_endpoint="api/v4/projects/8/packages/helm/api/stable/charts"

helm_clone() {
    name=$1
    chart=$2
    #chart=$3
    echo "[$name $repo $chart] processing..."
    #helm repo add $name $repo
    #helm repo update
    versions=$(helm search repo $name/$chart -l | awk '(NR>1)' | awk '{ print $2 }')
    for version in $versions; do
        helm pull $name/$chart --version $version -d charts
        #curl --request POST --form 'chart=@charts/$chart-$version.tgz' --user $GIT_USERNAME_PUBLIC:$GIT_PASSWORD_PUBLIC $chart_host/$chart_endpoint
        echo "[version $version of chart $chart from repo $name pulled]"
    done
}

helm_clone gitlab gitlab
helm_clone gitlab gitlab-runner
