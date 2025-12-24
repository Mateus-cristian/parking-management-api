FROM ruby:3.2.0

WORKDIR /app

COPY Gemfile Gemfile.lock ./
COPY public ./public
COPY docs ./docs

RUN bundle install

COPY . .

CMD ["bundle", "exec", "rackup", "-p", "4567", "-o", "0.0.0.0"]