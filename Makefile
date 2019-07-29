ARTIFACTORY_HELM_REPO ?= hyc-cloud-private-integration-helm-local
TEST_ARTIFACTORY_HELM_REPO ?= hyc-cloud-private-scratch-helm-local/mcm-kui-pr-builds
CHART_VERSION := $(shell cat ibm-mcm-kui/Chart.yaml | grep version | awk '{print $$2}')
CHART_NAME ?= ibm-mcm-kui


default: build

.PHONY: tool
## Download helm for linting and packaging
tool:
	curl -fksSL https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz | sudo tar --strip-components=1 -xvz -C /usr/local/bin/ linux-amd64/helm

.PHONY: setup
## Initialize helm 
setup:
	helm init -c

.PHONY: lint
## Run lint with helm linting tool
lint: setup
	helm lint $(CHART_NAME)

.PHONY: build
## Packages helm-api folder into chart archive
build: setup
	helm package $(CHART_NAME)

.PHONY: release-helm
## Push chart archive to integration (pushes to master only)
release-helm:
	@echo "CHART_NAME: $(CHART_NAME)"
	@echo "CHART_VERSION: $(CHART_VERSION)"
	curl -f -u$(ARTIFACTORY_USERNAME):$(ARTIFACTORY_APIKEY) -T $(CHART_NAME)-$(CHART_VERSION).tgz \
	"https://na.artifactory.swg-devops.com/artifactory/$(ARTIFACTORY_HELM_REPO)/$(CHART_NAME)-$(CHART_VERSION).tgz"

.PHONY: release-helm-test
## Push chart archive to scratch
release-helm-test:
	@echo "CHART_NAME: $(CHART_NAME)"
	@echo "CHART_VERSION: $(CHART_VERSION)"
	curl -f -u$(ARTIFACTORY_USERNAME):$(ARTIFACTORY_APIKEY) -T $(CHART_NAME)-$(CHART_VERSION).tgz \
	"https://na.artifactory.swg-devops.com/artifactory/$(TEST_ARTIFACTORY_HELM_REPO)/$(CHART_NAME)-$(CHART_VERSION).tgz"