.PHONY: upload

TARGETS = \
	xenial \
	bionic \
	disco \
	manylinux2014-cp36 \
	manylinux2014-cp37 \
	manylinux2014-cp38

IMAGES = $(foreach target,$(TARGETS),build-essentials-$(target))

build-essentials-%: %
	docker build -t "build-essentials:$*" -f "$*" .
	docker tag "build-essentials:$*" "eoshep/build-essentials:$*"
	touch $@

upload: $(IMAGES)
	for img in $^ ; do \
	    docker push eoshep/build-essentials ; \
	done
