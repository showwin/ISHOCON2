WORKLOAD = 3
ifeq ($(UNAME),)
	UNAME = $(shell whoami)
endif

ARCH = $(shell uname -m)

UBUNTU_VERSION = 18.04
ifeq ($(ARCH), arm64)
	BASE_IMAGE = arm64v8/ubuntu:$(UBUNTU_VERSION)
else
	BASE_IMAGE = ubuntu:$(UBUNTU_VERSION)
endif

LOCAL_ISHOCON_BASE_IMAGE = ishocon2-app-base:latest

build-base:
	docker build \
	--build-arg BASE_IMAGE=$(BASE_IMAGE) \
	-f ./docker/app/base/Dockerfile \
	-t $(LOCAL_ISHOCON_BASE_IMAGE) \
	-t $(UNAME)/ishocon2-app-base:latest .;

build-bench:
	docker build \
	--build-arg BASE_IMAGE=$(BASE_IMAGE) \
	-f ./docker/benchmarker/Dockerfile \
	-t ishocon2-bench:latest \
	-t $(UNAME)/ishocon2-bench:latest .;

build-app: change-lang build-base
	ISHOCON_APP_LANG=$(ISHOCON_APP_LANG:python)
	docker build \
	--build-arg BASE_IMAGE=$(LOCAL_ISHOCON_BASE_IMAGE) \
	-f ./docker/app/$(ISHOCON_APP_LANG)/Dockerfile \
	-t ishocon2-app-$(ISHOCON_APP_LANG):latest \
	-t $(UNAME)/ishocon2-app-$(ISHOCON_APP_LANG):latest .;

build: build-bench build-app
	docker compose -f ./docker-compose.yml build;

pull:
	docker pull $(UNAME)/ishocon2-app-bench:latest;
	docker pull $(UNAME)/ishocon2-app-base:latest;
	docker pull $(UNAME)/ishocon2-app-$(ISHOCON_APP_LANG):latest;

up:
	docker compose up -d;

up-nod:
	docker compose up;

down:
	docker compose down;

bench:
	docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443 --workload ${WORKLOAD}"

bench-with-db-restart: up
	docker exec -i ishocon2-bench-1 sh -c " \
		service mysql restart && \
		./benchmark --ip app:443 --workload ${WORKLOAD} \
	";

check-lang:
	if echo "$(ISHOCON_APP_LANG)" | grep -qE '^(ruby|python|go|php|nodejs|crystal)$$'; then \
        echo "ISHOCON_APP_LANG is valid."; \
    else \
        echo "Invalid ISHOCON_APP_LANG. It must be one of: ruby, python, go, php, nodejs, crystal."; \
        exit 1; \
    fi;

change-lang: check-lang
	if sed --version 2>&1 | grep -q GNU; then \
		echo "GNU sed"; \
		sed -i 's/\(ruby\|python\|go\|php\|nodejs\|crystal\)/'"$(ISHOCON_APP_LANG)"'/g' ./docker-compose.yml; \
	else \
		echo "BSD sed"; \
		sed -i '' -E 's/(ruby|python|go|php|nodejs|crystal)/'"$(ISHOCON_APP_LANG)"'/g' ./docker-compose.yml; \
	fi;
