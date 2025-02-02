SHELL := zsh
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: job

RUN = amogus.pl1
JOB = job.jcl
JOB_END = job_end.jcl

job: diff
diff:
	nc -4 localhost 3505 < $(JOB) < $(RUN) < $(JOB_END)
