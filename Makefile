# This is for local docker build testing

REGISTRY=docker-registry.tslcloud.com
USERNAME=guidesmiths
IMAGE_NAME=repocop
IMAGE_ID=$(shell docker images --no-trunc | grep "\b$(USERNAME)/$(IMAGE_NAME)\b" | grep "\blatest\b" | awk '{print $$3}')
IMAGE_FQN=$(REGISTRY)/$(USERNAME)/$(IMAGE_NAME)
BRANCH=master
TODAY=$(shell date +%Y%m%d)

docker-ps:
	docker ps --all | grep "\b$(USERNAME)/$(IMAGE_NAME)\b" || true

docker-images:
	docker images --no-trunc | grep "\b$(USERNAME)/$(IMAGE_NAME)\b" || true

docker-build:	
	cp Dockerfile build/Dockerfile	
	sed -e 's/RUN echo TODAY/RUN echo $(TODAY)/' -i '' build/Dockerfile || true
	docker build --tag $(IMAGE_FQN):latest build

docker-kill:
	docker rm -f $(IMAGE_NAME) || true

docker-run-daemon: docker-kill
	docker run -p 8080:8080 -p 127.0.0.1::22 -d --name $(IMAGE_NAME) $(IMAGE_FQN):latest

docker-run-interactive: docker-kill
	docker run -p 8080:8080 -p 127.0.0.1::22 -i -t --name $(IMAGE_NAME) $(IMAGE_FQN):latest $(CMD)

docker-run-bash: docker-kill
	docker run -p 8080:8080 -p 127.0.0.1::22 -i -t --name $(IMAGE_NAME) $(IMAGE_FQN):latest /bin/bash

docker-publish:
	docker push $(IMAGE_FQN)

build: docker-build

publish: docker-publish