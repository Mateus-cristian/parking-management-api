# frozen_string_literal: true

desc 'Inicia o servidor local'
task :start do
  sh 'bundle exec rackup -p 4567'
end

desc 'Roda o Rubocop no container'
task :rubocop do
  sh "docker compose exec api-dev bundle exec rubocop -c .rubocop.yml #{ENV['ARGS']}"
end

desc 'Roda os testes no container'
task :test do
  sh 'docker compose exec api-test bundle exec rspec'
end

task default: :start
