FROM ruby:2.7.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /billing-api
WORKDIR /billing-api

COPY Gemfile /billing-api/Gemfile
COPY Gemfile.lock /billing-api/Gemfile.lock

RUN bundle install
RUN bundle update --bundler

COPY . /billing-api

CMD ["rails", "server", "-b", "0.0.0.0"]