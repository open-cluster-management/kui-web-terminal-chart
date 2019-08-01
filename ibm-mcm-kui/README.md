# mcm-kui-chart

## Prerequisites
* ICP 3.2.0 

## Installing the Chart

To install the chart:

```console
$ helm install <chartname>.tgz --name mcm-kui --namespace kube-system --tls
```

## Uninstalling the Chart

To uninstall/delete the deployment:

```console
$ helm delete mcm-kui --purge --tls
```


## Configuration
The following table lists the configurable parameters of the chart and their default values.

Parameter                                        | Description                                               | Default
------------------------------------------------ | --------------------------------------------------------- | --------------------
`name`                                           | name of app                                               | mcm-kui                   
`replicaCount`                                   | number of pod replications                                | 1                   
`clusterIP`                                      | cluster IP                                                | icp-management-ingress
`clusterPort`                                    | cluster port                                              | 8443                  
`proxy.name`                                     | name of the proxy container                               | kui-proxy                   
`proxy.ingressPath`                              | path of the proxy ingress                                 | kui
`proxy.service.port`                             | port of the proxy service                                 | 8081                  
`proxy.image.repository`                         | image repository of the proxy container                   | ibmcom/kui-proxy
`proxy.image.tag`                                | image tag of the proxy container                          | latest
`proxy.image.pullPolicy`                         | image pull policy of the proxy container                  | IfNotPresent
`proxy.resources.limits.cpu`                     | kui-proxy cpu limits                                      | 500m
`proxy.resources.limits.memory`                  | kui-proxy memory limits                                   | 512Mi
`proxy.resources.requests.cpu`                   | kui-proxy cpu requests                                    | 250m
`proxy.resources.requests.memory`                | kui-proxy memory requests                                 | 128Mi
`tolerations`                                    | kubernetes pod tolerations                                | 
                
