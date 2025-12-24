start:
		bundle exec rackup -p 4567
rubocop:
		bundle exec rubocop -c infra/.rubocop.yml
compose up:
		docker compose -f infra/compose.yml up
compose down:
		docker compose -f infra/compose.yml down