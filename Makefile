
-include cfg.mk

DESTDIR ?=
prefix  ?= $(CURDIR)/output
MKDIR   ?= mkdir
MKDIR_P ?= $(MKDIR) -p
CP      ?= cp
TAR     ?= tar

$(DESTDIR)$(prefix):
	$(MKDIR_P) $@

$(CURDIR)/msg:
	echo "Howdy"     >  $@;  \
	echo '$$ ls'     >> $@;  \
	ls               >> $@;  \
	echo ''          >> $@;  \
	echo '$$ ls../*' >> $@;  \
	ls ../*          >> $@

.DEFAULT_GOAL = install

.PHONY: install

install: $(CURDIR)/msg $(DESTDIR)$(prefix)
	$(CP) -p --reflink=auto $< $(DESTDIR)$(prefix)/msg

sources-test.tar.gz: sources-test/baz
	$(TAR) czf $@ $<
