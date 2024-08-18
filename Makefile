export 

REPOSITORY ?= dbndev
IMAGE := $(REPOSITORY)/ssh-bridge
PWD = $(CURDIR)

server: $(SSH_PUBLIC_KEY)
	@echo Launching ssh server
	@-docker compose rm -f -s ssh-bridge-server
	@docker compose up ssh-bridge-server
.PHONY: server

server-sh:
	@echo Launching ssh server shell
	@docker compose exec -it ssh-bridge-server bash
.PHONY: server-sh

proxy: $(SSH_PRIVATE_KEY)
	@echo Launching ssh proxy
	@-docker compose rm -f -s ssh-bridge-proxy
	@docker compose up ssh-bridge-proxy
.PHONY: proxy

proxy-sh:
	@echo Launching ssh proxy shell
	@docker compose exec -it ssh-bridge-proxy bash
.PHONY: proxy-sh

client:
	@echo Launching ssh client
	@-docker compose rm -f -s ssh-bridge-proxyd-client
	@docker compose up ssh-bridge-client
.PHONY: client

client-sh:
	@echo Launching ssh client shell
	@docker compose exec -it ssh-bridge-client bash
.PHONY: client-sh

SSH_PRIVATE_KEY ?= $(CURDIR)/id_rsa
SSH_PUBLIC_KEY ?= $(CURDIR)/id_rsa.pub

SSH_KEYS = $(SSH_PRIVATE_KEY) $(SSH_PUBLIC_KEY)

$(SSH_KEYS): generate-ssh-keys

generate-ssh-keys: ssh-keys-rm 
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

ssh-keys-rm:
	@rm -rf $(SSH_KEYS)
.PHONY: ssh-keys-clean