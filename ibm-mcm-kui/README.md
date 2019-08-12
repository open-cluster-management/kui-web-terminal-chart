# Visual Web Terminal
* An interactive terminal that displays rich visualizations of command results.

## Introduction
The Visual Web Terminal is an enhanced version of Web Terminal.  In addition to displaying text output from user entered commands, it can also display richer visualizations, such as interactive tables of cluster resources in response to certain commands.

## Chart Details
This chart deploys a single instance of the Visual Web Terminal pod on the master node of Kubernetes cluster.

## Prerequisites
* Kuberenetes 1.11.0 or later, with beta APIs enabled
* IBM core services including auth-idp service and management-ingress

## Resources Required
* At least 128Mb of available memory with a limit of 512Mb of available memory
* At least 250m of available CPU with a limit of 500m CPU

## Installing the Chart
_NOTE: Visual Web Terminal is intended to be installed by the Installer for internal chart management, not by a user_

Only one instance of the Visual Web Terminal should be installed on a cluster.
To install the chart with release name `mcm-kui`:
```bash
$ helm install {chartname.tgz} -f {my-values.yaml} --name mcm-kui --namespace kube-system --tls
```
- Replace `{chartname.tgz}` with the packaged ibm-mcm-kui chart
- replace `{my-values.yaml}` with the path to a YAML file that specifies the values that are to be used with the install command

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
`proxy.clusterIP`                                | cluster IP                                                | icp-management-ingress
`proxy.clusterPort`                              | cluster port                                              | 8443                  
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


## Limitations
Only one instance of the Visual Web Terminal should run at a single time, and should be restricted to running only on the master node.
