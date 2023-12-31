common:
	docker build -f docker/app/base/Dockerfile -t showwin/ishocon2_app_base:latest .

build: common
	docker compose build

up: build
	docker compose up -d

down: 
	docker compose down

bench: up
	docker exec -it ishocon2-bench-1 ./benchmark --ip app:443
