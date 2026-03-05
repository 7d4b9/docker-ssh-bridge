export 

REPOSITORY ?= dbndev
IMAGE := $(REPOSITORY)/ssh-bridge
VSCODE_SERVER_ARCH ?= linux-x64
VSCODE_SERVER_COMMIT ?= 0870c2a0c7c0564e7631bfed2675573a94ba4455
PWD = $(CURDIR)

server-upgrade: build server-down server-up ensure-vscode-server-commit
.PHONY: server-upgrade

server-up: $(SSH_PUBLIC_KEY)
	@echo Launching ssh server
	@-docker compose rm -f -s server
	@docker compose up -d server
	@until nc -z localhost 22022 ; do echo waiting server ; sleep 1 ; done
	@echo server is running.
	@echo use "make server-logs" or "make server-logs-follow" to view server logs
.PHONY: server-up

server-logs:
	@docker compose logs server
.PHONY: server-logs

server-logs-follow:
	@docker compose logs --follow server
.PHONY: server-logs-follow

server-sh:
	@echo Launching ssh server shell
	@docker compose exec -it server bash
.PHONY: server-sh

server-down:
	@echo Removing ssh server container
	@docker compose down server
.PHONY: server-down

docker-proxy: $(SSH_PRIVATE_KEY)
	@echo Launching ssh proxy
	@-docker compose rm -f -s docker-proxy
	@docker compose up docker-proxy
.PHONY: docker-proxy

docker-proxy-sh:
	@echo Launching ssh proxy shell
	@docker compose exec -it docker-proxy bash
.PHONY: docker-proxy-sh

client:
	@echo Launching ssh client
	@-docker compose rm -f -s docker-proxy-client
	@docker compose up consumer
.PHONY: client

client-sh:
	@echo Launching ssh client shell
	@docker compose exec -it consumer bash
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
	@docker build \
	-f server/Dockerfile \
	-t $(IMAGE) server
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
.PHONY: ssh-keys-rm

ensure-vscode-server-commit:
	@echo "Ensuring VSCode servers are installed"
	@docker exec \
	  -e VSCODE_SERVER_COMMIT \
	  -e VSCODE_SERVER_ARCH \
	  ssh-server \
	  /usr/local/bin/ensure-vscode-servers.sh
.PHONY: ensure-vscode-server-commit