#!/bin/bash

chartmuseum=https://git.vnmntn.com/api/packages/alexmalder/helm/api/charts

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
        curl --user $CHARTMUSEUM_USERNAME:$CHARTMUSEUM_PASSWORD -X POST --upload-file charts/$chart-$version.tgz $chartmuseum
        echo "[version $version] pushed!"
    done
}

#helm_clone bitnami https://charts.bitnami.com/bitnami postgresql
#helm_clone prometheus-community https://prometheus-community.github.io/helm-charts kube-prometheus-stack
#helm_clone drone https://charts.drone.io drone
#helm_clone drone https://charts.drone.io drone-runner-kube
#helm_clone gitea-charts https://dl.gitea.io/charts gitea
#helm_clone nginx-stable https://helm.nginx.com/stable nginx-ingress
#helm_clone superset https://apache.github.io/superset superset

helm_clone bitnami airflow                                                                   
helm_clone bitnami apache                                                                    
helm_clone bitnami appsmith                                                                  
helm_clone bitnami argo-cd                                                                   
helm_clone bitnami argo-workflows                                                            
helm_clone bitnami aspnet-core                                                               
helm_clone bitnami cassandra                                                                 
helm_clone bitnami cert-manager                                                              
helm_clone bitnami clickhouse                                                                
helm_clone bitnami common                                                                    
helm_clone bitnami concourse                                                                 
helm_clone bitnami consul                                                                    
helm_clone bitnami contour                                                                   
helm_clone bitnami contour-operator                                                          
helm_clone bitnami dataplatform-bp2                                                          
helm_clone bitnami discourse                                                                 
helm_clone bitnami dokuwiki                                                                  
helm_clone bitnami drupal                                                                    
helm_clone bitnami ejbca                                                                     
helm_clone bitnami elasticsearch                                                             
helm_clone bitnami etcd                                                                      
helm_clone bitnami external-dns                                                              
helm_clone bitnami fluentd                                                                   
helm_clone bitnami geode                                                                     
helm_clone bitnami ghost                                                                     
helm_clone bitnami gitea                                                                     
helm_clone bitnami grafana                                                                   
helm_clone bitnami grafana-loki                                                              
helm_clone bitnami grafana-operator                                                          
helm_clone bitnami grafana-tempo                                                             
helm_clone bitnami haproxy                                                                   
helm_clone bitnami haproxy-intel                                                             
helm_clone bitnami harbor                                                                    
helm_clone bitnami influxdb                                                                  
helm_clone bitnami jaeger                                                                    
helm_clone bitnami jasperreports                                                             
helm_clone bitnami jenkins                                                                   
helm_clone bitnami joomla                                                                    
helm_clone bitnami jupyterhub                                                                
helm_clone bitnami kafka                                                                     
helm_clone bitnami keycloak                                                                  
helm_clone bitnami kiam                                                                      
helm_clone bitnami kibana                                                                    
helm_clone bitnami kong                                                                      
helm_clone bitnami kube-prometheus                                                           
helm_clone bitnami kube-state-metrics                                                        
helm_clone bitnami kubeapps                                                                  
helm_clone bitnami kubernetes-event-exporter                                                 
helm_clone bitnami logstash                                                                  
helm_clone bitnami magento                                                                   
helm_clone bitnami mariadb                                                                   
helm_clone bitnami mariadb-galera                                                            
helm_clone bitnami mastodon                                                                  
helm_clone bitnami matomo                                                                    
helm_clone bitnami mediawiki                                                                 
helm_clone bitnami memcached                                                                 
helm_clone bitnami metallb                                                                   
helm_clone bitnami metrics-server                                                            
helm_clone bitnami minio                                                                     
helm_clone bitnami mongodb                                                                   
helm_clone bitnami mongodb-sharded                                                           
helm_clone bitnami moodle                                                                    
helm_clone bitnami mxnet                                                                     
helm_clone bitnami mysql                                                                     
helm_clone bitnami nats                                                                      
helm_clone bitnami nginx                                                                     
helm_clone bitnami nginx-ingress-controller                                                  
helm_clone bitnami nginx-intel                                                               
helm_clone bitnami node                                                                      
helm_clone bitnami node-exporter                                                             
helm_clone bitnami oauth2-proxy                                                              
helm_clone bitnami odoo                                                                      
helm_clone bitnami opencart                                                                  
helm_clone bitnami osclass                                                                   
helm_clone bitnami owncloud                                                                  
helm_clone bitnami parse                                                                     
helm_clone bitnami phpbb                                                                     
helm_clone bitnami phpmyadmin                                                                
helm_clone bitnami pinniped                                                                  
helm_clone bitnami postgresql                                                                
helm_clone bitnami postgresql-ha                                                             
helm_clone bitnami prestashop                                                                
helm_clone bitnami pytorch                                                                   
helm_clone bitnami rabbitmq                                                                  
helm_clone bitnami rabbitmq-cluster-operator                                                 
helm_clone bitnami redis                                                                     
helm_clone bitnami redis-cluster                                                             
helm_clone bitnami redmine                                                                   
helm_clone bitnami schema-registry                                                           
helm_clone bitnami sealed-secrets                                                            
helm_clone bitnami solr                                                                      
helm_clone bitnami sonarqube                                                                 
helm_clone bitnami spark                                                                     
helm_clone bitnami spring-cloud-dataflow                                                     
helm_clone bitnami suitecrm                                                                  
helm_clone bitnami tensorflow-resnet                                                         
helm_clone bitnami thanos                                                                    
helm_clone bitnami tomcat                                                                    
helm_clone bitnami wavefront                                                                 
helm_clone bitnami wavefront-adapter-for-istio                                               
helm_clone bitnami wavefront-hpa-adapter                                                     
helm_clone bitnami wavefront-prometheus-storage-adapter                                      
helm_clone bitnami wildfly                                                                   
helm_clone bitnami wordpress                                                                 
helm_clone bitnami wordpress-intel                                                           
helm_clone bitnami zookeeper                                                                 
helm_clone drone drone                                                                       
helm_clone drone drone-kubernetes-secrets                                                    
helm_clone drone drone-runner-docker                                                         
helm_clone drone drone-runner-kube                                                           
helm_clone gitea-charts gitea                                                                
helm_clone k8s-dashboard kubernetes-dashboard                                                
helm_clone nginx-stable nginx-appprotect-dos-arbitrator                                      
helm_clone nginx-stable nginx-devportal                                                      
helm_clone nginx-stable nginx-ingress                                                        
helm_clone nginx-stable nginx-service-mesh                                                   
helm_clone nginx-stable nms                                                                  
helm_clone nginx-stable nms-acm                                                              
helm_clone nginx-stable nms-hybrid                                                           
helm_clone prometheus-community alertmanager                                                 
helm_clone prometheus-community jiralert                                                     
helm_clone prometheus-community kube-prometheus-stack                                        
helm_clone prometheus-community kube-state-metrics                                           
helm_clone prometheus-community prom-label-proxy                                             
helm_clone prometheus-community prometheus                                                   
helm_clone prometheus-community prometheus-adapter                                           
helm_clone prometheus-community prometheus-blackbox-exporter                                 
helm_clone prometheus-community prometheus-consul-exporter                                   
helm_clone prometheus-community prometheus-couchdb-exporter                                  
helm_clone prometheus-community prometheus-druid-exporter                                    
helm_clone prometheus-community prometheus-fastly-exporter                                   
helm_clone prometheus-community prometheus-json-exporter                                     
helm_clone prometheus-community prometheus-kafka-exporter                                    
helm_clone prometheus-community prometheus-mongodb-exporter                                  
helm_clone prometheus-community prometheus-mysql-exporter                                    
helm_clone prometheus-community prometheus-nats-exporter                                     
helm_clone prometheus-community prometheus-nginx-exporter                                    
helm_clone prometheus-community prometheus-node-exporter                                     
helm_clone prometheus-community prometheus-operator                                          
helm_clone prometheus-community prometheus-operator-crds                                     
helm_clone prometheus-community prometheus-pingdom-exporter                                  
helm_clone prometheus-community prometheus-postgres-exporter                                 
helm_clone prometheus-community prometheus-pushgateway                                       
helm_clone prometheus-community prometheus-rabbitmq-exporter                                 
helm_clone prometheus-community prometheus-redis-exporter                                    
helm_clone prometheus-community prometheus-smartctl-exporter                                 
helm_clone prometheus-community prometheus-snmp-exporter                                     
helm_clone prometheus-community prometheus-statsd-exporter                                   
helm_clone prometheus-community prometheus-to-sd                                             
helm_clone superset superset                                                                 
helm_clone vector vector                                                                     
helm_clone vector vector-agent                                                               
helm_clone vector vector-aggregator                                                          
helm_clone vector vector-shared                                                              
