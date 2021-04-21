# kui-web-terminal-chart
Helm chart for kui-web-terminal

## Building the chart locally
### Export a few environment Variables
```
export GITHUB_TOKEN=<your github personal access token>
export GITHUB_USER=<your github id>
```

### Build the chart
helm package stable/kui-web-terminal

## Testing the chart on an existing OpenShift environment

### Clone the repo that manages the Open Cluster Management charts

- [open-cluster-management/multiclusterhub-repo](https://github.com/open-cluster-management/multiclusterhub-repo/tree/main/multiclusterhub/charts)
### Copy the new helm tgz to multiclusterhub-repo
```
cp kui-web-terminal-3.6.0.tgz ../multiclusterhub-repo/multiclusterhub/charts
```

### Modify the multiclusterhub deployment to allow writing of new Helm tgz
```
oc edit deployment multiclusterhub-repo
```

Change **FROM**:
```
securityContext: {}
```

**TO**:
```
securityContext:
  runAsUser: 0
```
save changes


### Disable multiclusterhub-operator
```
oc scale deployments/multiclusterhub-operator --replicas=0
```
NOTE: As of June 12, 2020 on the master (2.0) build, the ability to pause the operator was added, see https://github.com/open-cluster-management/multicloudhub-operator#disabling-multiclusterhub-operator.  This means you would no longer need to perform this step or the scaling back up of relicas to 1.

### Delete kui-web-terminal-subscription
```
oc delete appsub/kui-web-terminal-sub
```
You will notice that the helmRelease object for kui-web-terminal deleted, and the deployment pods deleted as well.

### Copy over the new helm tgz files
In the multiclusterhub-repo, run:
```
make update-charts
```
For more info see https://github.com/open-cluster-management/multiclusterhub-repo#updating-chart-in-cluster

### Re-enable the multiclusterhub-operator
This will re-create subscription. The controller for subscription is helm operator and it will re-deploy kui-web-terminal chart.
```
oc scale deployments/multiclusterhub-operator --replicas=1
```


## Getting the new chart picked up by an official build
Once the changes are merged into this repo, see the information at https://github.com/open-cluster-management/multiclusterhub-repo#updating-charts-in-multiclusterhubcharts
