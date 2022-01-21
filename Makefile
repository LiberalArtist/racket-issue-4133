.PHONY: all
all: pkg-b-installed
	./layer-b/bin/racket --version

TMP_SYMLINK ::= /tmp/racket-issue-4133
INSTALLERS ::= https://pre-release.racket-lang.org/installers
TARBALL_URL ::= $(INSTALLERS)/racket-minimal-8.3.900-x86_64-linux-cs.tgz

pkg-%-installed: pkg-% layer-%/bin/racket
	./racket/bin/racket -G layer-$*/etc/racket -l raco pkg install -i ./$<
	touch $@

layer-b/bin/racket: pkg-a-installed
layer-%/bin/racket: layer-%/etc/racket/config.rktd racket/bin/racket | abslink
	./racket/bin/racket --config $(<D) -l raco setup --no-user

racket/bin/racket:
	wget $(TARBALL_URL) -O - | tar -xz

.PRECIOUS: $(patsubst a b, %, layer-%/etc/racket/config.rktd layer-%/bin/racket)
layer-%/etc/racket/config.rktd: config-%.rktd
	mkdir -p $(@D)
	cp $< $@

abslink:
	rm $(TMP_SYMLINK)
	ln -s $(realpath .) $(TMP_SYMLINK)
	touch $@
