start:
	bundle exec rackup -p 4567
rubocop:
	docker exec -it infra-api-dev-1 bundle exec rubocop -c infra/.rubocop.yml $(ARGS)
compose up:
	docker compose -f infra/compose.yml up
compose build:
	docker compose -f infra/compose.yml build
compose down:
	docker compose -f infra/compose.yml down $(ARGS)
test:
	docker exec -it infra-api-test-1 bundle exec rspec