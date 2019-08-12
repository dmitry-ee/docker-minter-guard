.EXPORT_ALL_VARIABLES:
APP_VERSION     = 0.1.0
APP_NAME        = minter-guard
DOCKER_ID_USER  = dmi7ry

.ONESHELL:

all: build

build:
	docker build -t $(DOCKER_ID_USER)/$(APP_NAME):$(APP_VERSION) .

run:
	docker run -it $(DOCKER_ID_USER)/$(APP_NAME):$(APP_VERSION)

bash:
	docker run -it $(DOCKER_ID_USER)/$(APP_NAME):$(APP_VERSION) bash

run-env:
	source .env
	export $(cut -d= -f1 .env)
	docker run --rm -it --name=minter-guard \
		-v PUB_KEY=$(PUB_KEY) \
		-v SET_OFF_TX=$(SET_OFF_TX) \
		-v MISSED_BLOCKS=$(MISSED_BLOCKS) \
		$(DOCKER_ID_USER)/$(APP_NAME):$(APP_VERSION)

configure:
	source .env
	export $(cut -d= -f1 .env)
	docker run --rm -it --name=minter-guard \
		-v PUB_KEY=$(PUB_KEY) \
		$(DOCKER_ID_USER)/$(APP_NAME):$(APP_VERSION) txgenerator

publish: build push

push:
	docker push $(DOCKER_ID_USER)/$(APP_NAME):$(APP_VERSION)
