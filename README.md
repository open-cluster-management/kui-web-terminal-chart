# kui-web-terminal-chart
Helm chart for kui-web-terminal

## Prereqs
### Environment variables
```
export GITHUB_USER=<user>
export GITHUB_TOKEN=<token>
```

### Helm
Ensure you have `helm` available in your PATH.  If not you can run:
```
make tool
```
and helm will be installed in /usr/local/bin

## Building the chart TGZ for testing on a local OpenShift
When you make chart changes and need to test them prior to PR merge, follow these steps:
1. `oc login` to your OCP cluster
1. Run `helm package stable/kui-web-terminal` to build the *kui-web-terminal* tgz
1. checkout branch `chart-stuff` in repo https://github.com/open-cluster-management/multicloudhub-repo
1. ensure *multicloudhub-repo* directory multiclusterhub/charts is empty
1. Copy the *kui-web-terminal* tgz to *multicloudhub-repo* directory multiclusterhub/charts. For example:
  ```
  cp kui-web-terminal-3.6.0.tgz ../multicloudhub-repo/multiclusterhub/charts
  ```
1. From the *multiclusterhub-repo* repo run `make update-charts`
