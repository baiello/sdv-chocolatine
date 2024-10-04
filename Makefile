# Executables (local)
DOCKER_COMP = docker compose

# Docker containers
WEB_CONT = $(DOCKER_COMP) exec web

# Executables
WEB      = $(WEB_CONT) php
COMPOSER = $(WEB_CONT) composer
SYMFONY  = $(WEB_CONT) bin/console

# Misc
.DEFAULT_GOAL = help
.PHONY        : help build up start down logs sh composer vendor sf cc test

## —————————————————————————————————————————————————————————————————————————————
## ⭐ The Chocolatine Makefile ⭐
## —————————————————————————————————————————————————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9\./_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————————————————————————————————
build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

up: ## Start the docker stack in detached mode (no logs)
	@$(DOCKER_COMP) up --detach

start: build up ## Build and start the containers

down: ## Stop the docker stack
	@$(DOCKER_COMP) down --remove-orphans

clean: ## Clean the docker stack
	@$(DOCKER_COMP) down --remove-orphans --volumes
	docker system prune --all --volumes --force

## —— Composer 🧙 ——————————————————————————————————————————————————————————————
composer: ## Run composer, pass the parameter "c=" to run a given command, example: make composer c='req symfony/orm-pack'
	@$(eval c ?=)
	@$(COMPOSER) $(c)

vendor: ## Install vendors according to the current composer.lock file
vendor: c=install --prefer-dist --no-dev --no-progress --no-scripts --no-interaction
vendor: composer
