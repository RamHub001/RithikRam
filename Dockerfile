FROM ruby:3.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN gem install rails bundler
WORKDIR /app
