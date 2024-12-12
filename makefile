
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -o errexit -o nounset -o pipefail -c  
MAKEFLAGS += --warn-undefined-variables
.DELETE_ON_ERROR:

SIFS=$(addprefix sifs/,$(addsuffix .sif,$(notdir $(basename $(wildcard defs/*.def)))))

APPTAINER=singularity

BUILDDIR=sifs
LOGDIR=logs

all: $(SIFS)
clean:
	- rm sifs/*

$(BUILDDIR):
	mkdir $(BUILDDIR)
$(LOGDIR):
	mkdir $(LOGDIR)

$(BUILDDIR)/%.sif : defs/%.def $(BUILDDIR) $(LOGDIR) apptainer
	$(APPTAINER) build --force $@ $< 2>&1 | tee $(addprefix $(LOGDIR)/,$(notdir $@)).`date +\%Y%m%d`.log
.PHONY: all
