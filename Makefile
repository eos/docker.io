TARGETS = \
	gitpod \
	ubuntu/bionic \
	ubuntu/focal \
	ubuntu/hirsute \
	ubuntu/impish \
	manylinux2014/cp36 \
	manylinux2014/cp37 \
	manylinux2014/cp38 \
	manylinux2014/cp39

IMAGES = $(foreach target,$(TARGETS),build-essentials-$(target))

.PHONY: build $(foreach targt,$(TARGETS),build-$(target))

build-%:
	docker \
	    build \
		$(DOCKER_BUILD_ARGS) \
		-t "build-essentials:$*" \
		-f $(subst -,/,$*)/Dockerfile \
		$(subst -,/,$*)
	docker \
		tag \
		"build-essentials:$(notdir $*)" \
		"eoshep/build-essentials:$(notdir $*)"

build: $(foreach target,$(TARGETS),build-$(subst /,-,$(target)))

upload-%: build-%
	docker push eoshep/build-essentials:$*

upload: $(foreach target,$(TARGETS),upload-$(subst /,-,$(target)))
