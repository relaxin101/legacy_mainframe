SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: all job

PL1 = job.jcl
COB = cob.jcl
DS = dataset.jcl
RUN = fibonacci.jcl

job: pl1

pl1: $(PL1)
	nc -4 localhost 3505 < $(PL1)

ds: $(DS)
	nc -4 localhost 3505 < $(DS)

ftp:
	lftp HERC01:CUL8TR@localhost:2121
run:
	nc -4 localhost 3505 < $(RUN)

