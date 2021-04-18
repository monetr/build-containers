
tinker-ubuntu:
	docker rm tinker-ubuntu || true
	docker build -t containers.monetr.local/ubuntu:20.04 -f $(PWD)/images/ubuntu/20.04/Dockerfile $(PWD)/images/ubuntu/20.04
	docker run -it \
		--name tinker-ubuntu \
		--mount type=bind,source="$(PWD)/",target=/build/build-characters \
		containers.monetr.local/ubuntu:20.04 \
		/bin/bash
