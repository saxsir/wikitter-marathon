BUNDLE := $(shell which bundle)

all:
	@$(BUNDLE) exec ruby wikitter_marathon.rb >> logs/$(shell date +"%y%m%d")_wikitter.log

install:
	$(BUNDLE) install --path vendor/bundle

show-stats:
	cat logs/*.log | awk '{print $$NF}' | sort | uniq -c | sort -nr

show-top:
	cat logs/*.log | awk '{print $$NF" - "$$0}' | sort -nr | head
