#
# Makefile for more convenient building of the Linode CLI and its baked content
#

PYTHON ?= 3
SPEC ?= ../linode-api-docs-dbaas/openapi.yaml
DIST_DIR ?= ../linode-cli-dbaas/dist
GITHUB_SPEC ?= ../linode-cli-dbaas/openapi.yaml

PYCMD=python3
PIPCMD=pip3


install: check-prerequisites requirements build
	ls ${DIST_DIR}/ | xargs -I{} $(PIPCMD) install --force ${DIST_DIR}/{}

.PHONY: build
build: clean
	python3 -m linodecli bake ${SPEC} --skip-config
	cp data-3 linodecli/
	$(PYCMD) setup.py bdist_wheel -d ${DIST_DIR}
	cp ${SPEC} ${GITHUB_SPEC}

.PHONY: requirements
requirements:
	pip install -r requirements.txt
	pip3 install -r requirements.txt

.PHONY: check-prerequisites
check-prerequisites:
	@ pip3 --version >/dev/null
	@ python3 --version >/dev/null

.PHONY: clean
clean:
	rm -f linodecli/data-*
	rm -f linode-cli.sh
	rm -f ${DIST_DIR}/*
