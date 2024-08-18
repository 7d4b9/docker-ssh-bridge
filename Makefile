REPOSITORY ?= dbndev

IMAGE := $(REPOSITORY)/ssh-bridge

server: $(SSH_PUBLIC_KEY)
	@echo Launching ssh server
	@docker compose up ssh-docker-server
.PHONY: server

client: $(SSH_PRIVATE_KEY)
	@echo Launching ssh client
	@docker compose up ssh-docker-client
.PHONY: client

SSH_PRIVATE_KEY ?= $(CURDIR)/id_rsa
SSH_PUBLIC_KEY ?= $(CURDIR)/id_rsa.pub

SSH_KEYS = $(SSH_PRIVATE_KEY) $(SSH_PUBLIC_KEY)

$(SSH_KEYS): generate-ssh-keys

generate-ssh-keys: clean 
	@echo Generating ssh keys
	@ssh-keygen -t rsa -b 4096 -f $(SSH_PRIVATE_KEY) -q -N ""
.PHONY: generate-ssh-keys

build:
	@echo Building image:
	@docker build -t $(IMAGE) .
.PHONY: build

push:
	@echo pushing image:
	@docker push $(IMAGE)
.PHONY: push

pull:
	@echo pulling image:
	@docker pull $(IMAGE)
.PHONY: pull

clean:
	@rm -f $(SSH_KEYS)
.PHONY: clean