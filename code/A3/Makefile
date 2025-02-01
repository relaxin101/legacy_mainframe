SHELL := zsh
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: all job

DS = dataset.jcl
RUN = amogus.pl1
JOB = job.jcl
JOB_END = job_end.jcl

job: all
all:
	nc -4 localhost 3505 < $(JOB) < $(RUN) < $(JOB_END)

ds: $(DS)
	nc -4 localhost 3505 < $(DS)

ftp:
	lftp -f ./lftp.txt

