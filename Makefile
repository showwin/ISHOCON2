common:
	docker build -f docker/app/base/Dockerfile -t showwin/ishocon2_app_base:latest .

build: common
	docker compose build

bench: build
	docker exec -it ishocon2-bench-1 ./benchmark --ip app:443
