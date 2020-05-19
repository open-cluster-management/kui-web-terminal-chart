###############################################################################
# Copyright (c) 2020 Red Hat, Inc.
###############################################################################
GITHUB_USER := $(shell echo $(GITHUB_USER) | sed 's/@/%40/g')
GITHUB_TOKEN ?=

ifndef GITHUB_USER
	$(info GITHUB_USER not defined)
	exit -1
endif
ifndef GITHUB_TOKEN
	$(info GITHUB_TOKEN not defined)
	exit -1
endif

# Bootstrap (pull) the build harness
-include $(shell curl -H 'Authorization: token ${GITHUB_TOKEN}' -H 'Accept: application/vnd.github.v4.raw' -L https://api.github.com/repos/open-cluster-management/build-harness-extensions/contents/templates/Makefile.build-harness-bootstrap -o .build-harness-bootstrap; echo .build-harness-bootstrap)

CHART_VERSION := $(SEMVERSION)
CHART_NAME ?= kui-web-terminal

.PHONY: tool
## Download helm for linting and packaging
tool:
	curl -fksSL https://get.helm.sh/helm-v3.1.2-linux-amd64.tar.gz | sudo tar --strip-components=1 -xvz -C /usr/local/bin/ linux-amd64/helm

.PHONY: tool
## Run lint with helm linting tool
lint: setup
	helm lint stable/$(CHART_NAME)
