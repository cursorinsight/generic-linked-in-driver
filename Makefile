# Copyright (c) 2012-2014 Martin Donath <md@struct.cc>
#               2018      Bence Golda <bence@cursorinsight.com>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

# Common developers' settings
ELVIS_FLAGS := -c $(TOP_DIR)config/elvis.config --output-format plain

# Build tools
REBAR := $(shell which rebar3)
ELVIS := $(shell which elvis)

# Common directories and paths
TOP_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
BUILD_DIR := $(TOP_DIR)/_build

.PHONY: all deps test

# Default targets
all: compile
fresh: clean all
everything: mrproper compile test

# Check for missing build tools
ifeq "$(strip $(REBAR))" ""
REBAR := rebar
endif

ifeq "$(strip $(ELVIS))" ""
ELVIS := elvis
endif

$(REBAR):
	@echo Please install \`$@\' manually!
	@exit 1

$(ELVIS):
	@echo Please install \`$@\' manually!
	@exit 1

#------------------------------------------------------------------------------
# Targets
#------------------------------------------------------------------------------

mrproper:
	rm -rf $(BUILD_DIR)

clean:
	$(REBAR) clean

deps: $(REBAR)
	$(REBAR) upgrade

compile: $(REBAR)
	$(REBAR) compile

test: compile
	$(REBAR) do eunit, ct, dialyzer

check: $(ELVIS)
	$(ELVIS) $(ELVIS_FLAGS) rock

shell:
	$(REBAR) shell

docs: doc
doc: $(REBAR)
	$(REBAR) doc
