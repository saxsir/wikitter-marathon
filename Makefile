BUNDLE := $(shell which bundle)

all:
	@$(BUNDLE) exec ruby wikitter_marathon.rb >> logs/$(shell date +"%y%m%d")_wikitter.log

install:
	$(BUNDLE) install --path vendor/bundle


