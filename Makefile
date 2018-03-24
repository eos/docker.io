.PHONY: upload

TARGETS = \
	xenial \
	bionic

IMAGES = $(foreach target,$(TARGETS),build-essentials-$(target))

build-essentials-%: %
	docker build -t "build-essentials:$*" -f "$*" .
	docker tag "build-essentials:$*" "eoshep/build-essentials:$*"
	touch $@

upload: $(IMAGES)
	for img in $^ ; do \
	    docker push eoshep/build-essentials ; \
	done
