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
CHART_NAME ?= kui-web-terminal

default: build

.PHONY: tool
## Download helm for linting and packaging
tool:
	curl -fksSL https://get.helm.sh/helm-v3.1.2-linux-amd64.tar.gz | sudo tar --strip-components=1 -xvz -C /usr/local/bin/ linux-amd64/helm

.PHONY: lint
## Run lint with helm linting tool
lint: 
	helm lint stable/$(CHART_NAME)

.PHONY: cv-lint
cv-lint:
	$(SELF) cv:install
	$(SELF) cv:run

.PHONY: build
## Packages helm-api folder into chart archive
build: setup
	helm package --version $(CHART_VERSION) stable/$(CHART_NAME)
	@echo "ALSO PACKAGING AS VERSION 99.99.99 UNTIL COMMON SERVICES PIPELINE COMPLETE"
	helm package --version 99.99.99 stable/$(CHART_NAME)

