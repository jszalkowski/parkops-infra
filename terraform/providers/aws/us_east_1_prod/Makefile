SHELL := $(SHELL) -e

# determine the correct terraform remote config location
PRJ_ROOT := $(shell git rev-parse --show-cdup)
BASE_PATH := $(shell cd $(PRJ_ROOT) && pwd)
FULL_PATH := $(shell pwd)
REL_PATH := $(shell echo $(FULL_PATH) | sed 's|'$(BASE_PATH)'/||')
#
BRANCH := $(shell cd $(PRJ_ROOT) && git rev-parse --abbrev-ref HEAD)
.PHONY: all init remote pull apply push output destroy graph

all: init remote pull plan apply push

init:

remote: init
	terraform remote config \
	-backend=atlas \
	-backend-config="name=parkops/us-east-1-prod" \
	-backup=-

pull: remote
	terraform get -update
	terraform remote pull

refresh:
	terraform refresh

plan:
	terraform plan -module-depth=-1

apply:
	terraform apply

push:
	terraform remote push

destroy:
	terraform plan -destroy
	terraform destroy

output:
	terraform output

graph:
	terraform graph -draw-cycles -module-depth=1 | neato -Goverlap=prism1000 -Gsplines=curved -Tsvg -o .terraform/terraform.svg
	google-chrome .terraform/terraform.svg

