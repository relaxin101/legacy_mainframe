SHELL := zsh
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: all setup_job taxdiff_job readoutput_job

all: setup_job taxdiff_job readoutput_job

*_job:
	cd $@ && make job
