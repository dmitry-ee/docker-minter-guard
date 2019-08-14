.EXPORT_ALL_VARIABLES:
APP_VERSION     = $(shell git describe --abbrev=0 --tags)
APP_NAME        = minter-guard
DOCKER_ID_USER  = dmi7ry

.ONESHELL:

all: build

build:
	docker build --squash -t $(DOCKER_ID_USER)/$(APP_NAME):$(APP_VERSION) .

build-nc:
	docker build --squash --no-cache -t $(DOCKER_ID_USER)/$(APP_NAME):$(APP_VERSION) .

run:
	docker run -it $(DOCKER_ID_USER)/$(APP_NAME):$(APP_VERSION)

bash:
	docker run -it $(DOCKER_ID_USER)/$(APP_NAME):$(APP_VERSION) bash

run-env:
	docker run --rm -it --name=minter-guard \
		--env-file ./.env \
		--net=host \
		$(DOCKER_ID_USER)/$(APP_NAME):$(APP_VERSION)

configure:
	docker run --rm -it --name=minter-guard \
		--env-file ./.env \
		--net=host \
		$(DOCKER_ID_USER)/$(APP_NAME):$(APP_VERSION) txgenerator

publish: build push

push:
	docker push $(DOCKER_ID_USER)/$(APP_NAME):$(APP_VERSION)
