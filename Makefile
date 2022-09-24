
tinker-ubuntu:
	docker rm tinker-ubuntu || true
	docker build -t containers.monetr.local/ubuntu:20.04 -f $(PWD)/images/ubuntu/20.04/Dockerfile $(PWD)/images/ubuntu/20.04
	docker run -it \
		--name tinker-ubuntu \
		--mount type=bind,source="$(PWD)/",target=/build/build-characters \
		containers.monetr.local/ubuntu:20.04 \
		/bin/bash

tinker-debian:
	docker rm tinker-debian || true
	docker build -t containers.monetr.local/debian:11.5 -f $(PWD)/images/debian/11.5/Dockerfile $(PWD)/images/debian/11.5
	docker run -it \
		--name tinker-debian \
		--mount type=bind,source="$(PWD)/",target=/build/build-characters \
		containers.monetr.local/debian:11.5 \
		/bin/bash

DOCKER=$(shell which docker)

TARGETS=$(foreach dir,$(wildcard $(PWD)/images/*),$(notdir $(dir)))
$(TARGETS): TARGET=images/$@/$(notdir $(word 1,$(wildcard $(PWD)/images/$@/*)))/Dockerfile
$(TARGETS):
	$(MAKE) $(TARGET) -B

IMAGE_DESTINATION ?= containers.monetr.local
images/%: CONTAINER=$(shell echo "$(dir $(@D))" | cut -d "/" -f 2)
images/%: VERSION=$(notdir $(@D))
images/%: VERSION_ALT=$(VERSION)-$(shell git describe --tag | cut -d "-" -f 2,3)
images/%: NAME=$(IMAGE_DESTINATION)/$(CONTAINER)
images/%:
	$(DOCKER) build -t $(NAME):$(VERSION) -t $(NAME):$(VERSION_ALT) -f $(PWD)/$@ $(PWD)/$(@D)

