.PHONY: all
all: pkg-b-installed
	./layer-b/bin/racket --version

TMP_SYMLINK ::= /tmp/racket-issue-4133
INSTALLERS ::= https://pre-release.racket-lang.org/installers
TARBALL_URL ::= $(INSTALLERS)/racket-minimal-8.3.900-x86_64-linux-cs.tgz
RKT ::= ./racket/bin/racket
.PRECIOUS: $(patsubst a b, %, catalog-% pkg-%-installed \
		layer-%/etc/racket/config.rktd layer-%/bin/racket)

pkg-b-installed: catalog-b-extended
pkg-%-installed: catalog-%
	$(RKT) -G layer-$*/etc/racket -l raco pkg \
		install -i --auto --catalog catalog-$* pkg-$*
	touch $@

catalog-b-extended: catalog-b
	$(RKT) -l raco pkg catalog-copy --merge $(INSTALLERS)/../catalog/ $<
	touch $@

catalog-%: pkg-% layer-%/bin/racket
	mkdir -p layer-$*/lib/racket/pkgs
	cp -r $< layer-$*/lib/racket/pkgs/pkg-$*
	$(RKT) -l- pkg/dirs-catalog --link catalog-$* layer-$*/lib/racket/pkgs

layer-b/bin/racket: pkg-a-installed
layer-%/bin/racket: layer-%/etc/racket/config.rktd racket/bin/racket | abslink
	$(RKT) --config $(<D) -l raco setup --no-user

racket/bin/racket:
	wget $(TARBALL_URL) -O - | tar -xz

layer-%/etc/racket/config.rktd: config-%.rktd
	mkdir -p $(@D)
	cp $< $@

abslink:
	-rm $(TMP_SYMLINK)
	ln -s $(realpath .) $(TMP_SYMLINK)
	touch $@
