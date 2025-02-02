SHELL := zsh
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: all job SAMPCLG.jcl

DS = dataset.jcl
FTP = lftp.txt

job: setup
setup: ds ftp SAMPCLG.jcl
ds: $(DS)
	nc -4 localhost 3505 < $(DS)
ftp:
	lftp -f $(FTP)


*.jcl: 
	nc -4 localhost 3505 < $@

