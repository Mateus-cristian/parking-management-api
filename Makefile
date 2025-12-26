start:
		bundle exec rackup -p 4567
rubocop:
		bundle exec rubocop -c infra/.rubocop.yml $(ARGS)
compose up:
	docker compose -f infra/compose.yml up
compose build:
	docker compose -f infra/compose.yml build
compose down:
	docker compose -f infra/compose.yml down $(ARGS)
test:
	bundle exec rspec