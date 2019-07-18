CHART_NAME ?= mcm-kui

.PHONY: setup lint build 

default: build

setup:
	helm init -c

lint: setup
	helm lint $(CHART_NAME)

build: lint 
	helm package $(CHART_NAME)
