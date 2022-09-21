BOARD ?= icesugar

default: all

.PHONY:all
all: ## Run sys, pnr and bitstream generation for the given BOARD
	make -C board all BOARD=$(BOARD)

.PHONY: clean
clean: ## Deletes and recreates the build folder
	make -C board clean BOARD=$(BOARD)

.PHONY: sim
sim: ## Run simulations
	make -C sim all BOARD=$(BOARD)
 
.PHONY: program
program: ## Program the given BOARD
	make -C board program BOARD=$(BOARD)
 
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help: ## Print this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'