common:
	docker build -f docker/app/base/Dockerfile -t showwin/ishocon2_app_base:latest .

build: common
	docker compose build --progress=plain

up:
	docker compose up -d

down: 
	docker compose down

bench:
	docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443 --workload 4"
