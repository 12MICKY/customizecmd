.PHONY: help verify check dry-run install install-full uninstall

help:
	@printf '%s\n' \
	  'Targets:' \
	  '  make verify       Run syntax checks and dry-run smoke tests' \
	  '  make check        Inspect this machine without installing' \
	  '  make dry-run      Preview installation changes' \
	  '  make install      Install the auto-detected profile' \
	  '  make install-full Install dependencies, shell tools, and default shell' \
	  '  make uninstall    Restore latest backups'

verify:
	./verify.sh

check:
	./install.sh --check

dry-run:
	./install.sh --dry-run

install:
	./install.sh

install-full:
	./install.sh --install-deps --bootstrap --set-shell

uninstall:
	./uninstall.sh
