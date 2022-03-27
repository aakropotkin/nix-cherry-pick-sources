
.PHONY: install
.DEFAULT_GOAL = install

# Include any `cfg.mk' file which may have been produced by `configure'
-include cfg.mk

DESTDIR      ?=
prefix       ?= $(CURDIR)/output
MKDIR        ?= mkdir
MKDIR_P      ?= $(MKDIR) -p
TAR          ?= tar
CP           ?= cp
INSTALL_DATA ?= $(CP) -p --reflink=auto --

$(DESTDIR)$(prefix):
	$(MKDIR_P) $@

$(CURDIR)/msg:
	echo "Howdy"     >  $@;  \
	echo ''          >> $@;  \
	echo '$$ ls'     >> $@;  \
	ls               >> $@;  \
	echo ''          >> $@;  \
	echo '$$ ls ../*' >> $@;  \
	ls ../*          >> $@

install: $(CURDIR)/msg $(DESTDIR)$(prefix)
	$(INSTALL_DATA) "$<" "$(DESTDIR)$(prefix)/msg"

$(CURDIR)/sources-test.tar.gz: $(CURDIR)/sources-test/baz
	$(TAR) czf "$@" "$<"
