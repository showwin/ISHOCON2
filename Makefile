build-base:
	docker build -f ./docker/app/base/Dockerfile" -t showwin/ishocon2_app_base:latest .;

build:
	docker compose -f ./docker-compose.yml build;

up: build
	docker compose up -d;

up-nod: build
	docker compose up;

down: 
	docker compose down;

bench:
	docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443";

change-lang:
	if sed --version 2>&1 | grep -q GNU; then \
		echo "GNU sed"; \
		sed -i 's/\(ruby\|python\|go\|php\|nodejs\|crystal\)/'"$(LANG)"'/g' ./docker-compose.yml; \
	else \
		echo "BSD sed"; \
		sed -i '' -E 's/\(ruby|python|go|php|nodejs|crystal)/'"go"'/g' ./docker-compose.yml; \
	fi;
