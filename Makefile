build-base:
	docker build -f docker/app/base/Dockerfile -t showwin/ishocon2_app_base:latest .

build:
	docker compose -f ./docker-compose.yml build

up: build
	docker compose up -d

up-nod: build
	docker compose up

down: 
	docker compose down

bench:
	docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443"

change-lang:
	if sed --version 2>&1 | grep -q GNU; then
		sed -i 's/\(ruby\|python\|go\|php\|nodejs\|crystal\)/'"$(LANG)"'/g' "$(CURDIR)/docker-compose.yml"
	else
		sed -i '' 's/\(ruby\|python\|go\|php\|nodejs\|crystal\)/'"$(LANG)"'/g' "$(CURDIR)/docker-compose.yml"
	fi
