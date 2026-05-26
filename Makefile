.PHONY: help verify check dry-run install install-server install-full uninstall

help:
	@printf '%s\n' \
	  'Targets:' \
	  '  make verify          Run syntax checks and dry-run smoke tests' \
	  '  make check           Inspect this machine without installing' \
	  '  make dry-run         Preview installation changes' \
	  '  make install         Install auto-detected profile (linux or macos)' \
	  '  make install-server  Install linux-server profile' \
	  '  make install-full    Install deps, shell tools, and set default shell' \
	  '  make uninstall       Restore latest backups'

verify:
	./verify.sh

check:
	./install.sh --check

dry-run:
	./install.sh --dry-run

install:
	./install.sh

install-server:
	./install.sh linux-server --install-deps --bootstrap --set-shell

install-full:
	./install.sh --install-deps --bootstrap --set-shell

uninstall:
	./uninstall.sh
