#!/usr/bin/env -S make -f

help: ##- Print available commands
	@echo
	@echo "Contrôle qualité:"
	@sed -e '/#\{2\}-/!d; s/\\$$//; s/:[^#\t]*/:/; s/#\{2\}-*//; s/^/  /' $(MAKEFILE_LIST)

check-all: check-ruby ##- check ruby, css, js

self-check: self-check-ruby ##- Check tools versions

GEM_LIST=rubocop|slim_lint|bundler-audit|brakeman|i18n-tasks

self-check-ruby: ##- Check ruby tools versions
	@echo
	@echo "Checking gem versions"
	@echo
	@echo "Installed versions"
	@gem list | awk '/(${GEM_LIST}) / { print "- " $$0 }'
	@echo
	@echo "Checking for updates ..."
	@gem outdated | awk 'BEGIN { return_code = 0} /(${GEM_LIST}) / { print "- " $$0; return_code = 1 } END { exit return_code }'

###
## Ruby
#

check-ruby: ##- Check ruby code quality
check-ruby: rubocop slim-lint bundle-audit brakeman i18n-tasks-check-normalized

rubocop: ##- Ruby linter
	@echo "Checking ruby code quality"
	rubocop -f simple

slim-lint: ##- Slim linter
	@echo "Checking slim code quality"
	slim-lint .

bundle-audit: ##- Bundled gems vulnerability scanner
	@echo "Checking for vulnerabilities in bundled gems"
	bundle-audit check --update

brakeman: ##- Ruby vulnerability scanner
	@echo "Checking for vulnerabilities ruby code"
	brakeman --run-all-checks --no-progress --no-pager --quiet --ignore-config .brakeman.ignore

i18n-tasks-check-normalized: ##- Ruby translation tool
	@echo "Checking for translation normalization"
	i18n-tasks check-normalized
