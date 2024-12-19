ROOT_DIR ?= $(CURDIR)
ACTIVATE := . $(ROOT_DIR)/venv/bin/activate &&
PROJECT := $(notdir $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST))))))

install: venv
	$(ACTIVATE) pip install -e .

venv:: $(ROOT_DIR)/requirements/local.txt
	python3 -m venv $(ROOT_DIR)/venv
	$(ACTIVATE) pip install -U pip
	$(ACTIVATE) pip install -r $(ROOT_DIR)/requirements/local.txt
	$(ACTIVATE) pip install -r $(ROOT_DIR)/requirements/test.txt
	touch -c venv

.PHONY: requirements
requirements:
	$(MAKE) -B -C requirements/

start: requirements install

test:
	$(ACTIVATE) pytest .

format:
	$(ACTIVATE) black $(PROJECT) tests
	$(ACTIVATE) ruff check --fix $(PROJECT) tests

what:
	echo