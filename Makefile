ARTIFACTORY_HELM_REPO ?= hyc-cloud-private-integration-helm-local
TEST_ARTIFACTORY_HELM_REPO ?= hyc-cloud-private-scratch-helm-local/mcm-kui-pr-builds

GITHUB_USER := $(shell echo $(GITHUB_USER) | sed 's/@/%40/g')

.PHONY: init\:
init::
	@mkdir -p variables
ifndef GITHUB_USER
	$(info GITHUB_USER not defined)
	exit -1
endif
	$(info Using GITHUB_USER=$(GITHUB_USER))
ifndef GITHUB_TOKEN
	$(info GITHUB_TOKEN not defined)
	exit -1
endif

-include $(shell curl -fso .build-harness -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.v3.raw" "https://raw.github.ibm.com/ICP-DevOps/build-harness/master/templates/Makefile.build-harness"; echo .build-harness)


CHART_VERSION := $(SEMVERSION)
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
	helm package --version $(CHART_VERSION) $(CHART_NAME)
	@echo "ALSO PACKAGING AS VERSION 99.99.99 UNTIL COMMON SERVICES PIPELINE COMPLETE"
	helm package --version 99.99.99 $(CHART_NAME)

.PHONY: release-helm
## Push chart archive to integration (pushes to master only)
release-helm:
	@echo "CHART_NAME: $(CHART_NAME)"
	@echo "CHART_VERSION: $(CHART_VERSION)"
	curl -f -u$(ARTIFACTORY_USERNAME):$(ARTIFACTORY_APIKEY) -T $(CHART_NAME)-$(CHART_VERSION).tgz \
	"https://na.artifactory.swg-devops.com/artifactory/$(ARTIFACTORY_HELM_REPO)/$(CHART_NAME)-$(CHART_VERSION).tgz"
	@echo "ALSO DELIVERING AS VERSION 99.99.99 UNTIL COMMON SERVICES PIPELINE COMPLETE"
	curl -u$(ARTIFACTORY_USERNAME):$(ARTIFACTORY_APIKEY) -T $(CHART_NAME)-99.99.99.tgz \
	"https://na.artifactory.swg-devops.com/artifactory/$(ARTIFACTORY_HELM_REPO)/$(CHART_NAME)-99.99.99.tgz"

.PHONY: release-helm-test
## Push chart archive to scratch
release-helm-test:
	@echo "CHART_NAME: $(CHART_NAME)"
	@echo "CHART_VERSION: $(CHART_VERSION)"
	curl -f -u$(ARTIFACTORY_USERNAME):$(ARTIFACTORY_APIKEY) -T $(CHART_NAME)-$(CHART_VERSION).tgz \
	"https://na.artifactory.swg-devops.com/artifactory/$(TEST_ARTIFACTORY_HELM_REPO)/$(CHART_NAME)-$(CHART_VERSION).tgz"
	@echo "ALSO DELIVERING AS VERSION 99.99.99 UNTIL COMMON SERVICES PIPELINE COMPLETE"
	curl -u$(ARTIFACTORY_USERNAME):$(ARTIFACTORY_APIKEY) -T $(CHART_NAME)-99.99.99.tgz \
	"https://na.artifactory.swg-devops.com/artifactory/$(TEST_ARTIFACTORY_HELM_REPO)/$(CHART_NAME)-99.99.99.tgz"