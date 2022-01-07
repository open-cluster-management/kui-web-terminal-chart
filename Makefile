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
-include $(shell curl -H 'Authorization: token ${GITHUB_TOKEN}' -H 'Accept: application/vnd.github.v4.raw' -L https://api.github.com/repos/stolostron/build-harness-extensions/contents/templates/Makefile.build-harness-bootstrap -o .build-harness-bootstrap; echo .build-harness-bootstrap)

CHART_VERSION := $(SEMVERSION)
CHART_NAME ?= kui-web-terminal

.PHONY: tool
## Download helm for linting and packaging
tool:
	curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

.PHONY: setup
setup:

.PHONY: lint
## Run lint with helm linting tool
lint: tool
	helm lint stable/$(CHART_NAME)

.PHONY: build
## Packages helm-api folder into chart archive
build: setup
	helm package stable/$(CHART_NAME)
