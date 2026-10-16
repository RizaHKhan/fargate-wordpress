.PHONY: up build down reset

up:
	docker compose up -d

build:
	docker compose up -d --build

down:
	docker compose down

# Destroy containers, the db volume, and built images, then rebuild from scratch.
reset:
	docker compose down -v --rmi local --remove-orphans
	docker compose build --no-cache
	docker compose up -d
