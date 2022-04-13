DOCKER_TAG ?= latest
export DOCKER_TAG
DOCKER_IMAGE = camptocamp/geowebcache
ROOT = $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: pull build

pull:
	for image in `find -name Dockerfile | xargs grep --no-filename FROM | awk '{print $$2}'`; do docker pull $$image; done

build:
	docker build --tag=$(DOCKER_IMAGE):$(DOCKER_TAG) .
