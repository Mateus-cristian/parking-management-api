FROM ruby:3.3.5

WORKDIR /app

ARG BUNDLE_WITHOUT="test"
ENV BUNDLE_WITHOUT=$BUNDLE_WITHOUT

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY public ./public
COPY docs ./docs
COPY . .

CMD ["bundle", "exec", "rackup", "-p", "4567", "-o", "0.0.0.0"]