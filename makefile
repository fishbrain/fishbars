GIT_STATUS = $(shell git status --porcelain)
GIT_BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
MOCHA_PARAMS = --compilers coffee:coffee-script/register --recursive --grep "$(TESTS)" --timeout 100



## Creating files and folders
## ==========================================================================

.cov: src/*.coffee
	@jscov --expand --conditionals src .cov

lib: src/*.coffee
	@rm -rf lib
	@coffee -co lib src



## Tasks
## ==========================================================================

clobber:
	@rm -rf node_modules .cov lib

test-coverage: .cov
	@JSCOV=.cov mocha $(MOCHA_PARAMS) --reporter mocha-term-cov-reporter

test-coveralls: .cov
	@JSCOV=.cov mocha --reporter mocha-lcov-reporter $(MOCHA_PARAMS) | coveralls src

test-node:
	@coffee-jshint -o node src/*.coffee
	@mocha $(MOCHA_PARAMS) --reporter list

test: lib test/*
ifneq ($(CI),true)
	@make test-node
	@make test-coverage
else ifneq ($(TRAVIS_NODE_VERSION),0.10)
	@make test-node
else
	@make test-node
	@make test-coveralls
endif

release:
ifeq "$(VERSION)" ""
	@echo "You have to specify a version: 'make release VERSION=x.x.x'"
else ifneq "$(GIT_STATUS)" ""
	@echo "clean up your changes first"
else ifneq "$(GIT_BRANCH)" "master"
	@echo "You can only release from the master branch"
else
	@npm test
	@json -I -e "version='$(VERSION)'" -f package.json
	@git add package.json
	@git commit -m v$(VERSION)
	@git tag -a v$(VERSION) -m v$(VERSION)
	@git push --follow-tags
endif
