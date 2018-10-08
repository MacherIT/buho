FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /buho
WORKDIR /buho
COPY Gemfile /buho/Gemfile
COPY Gemfile.lock /buho/Gemfile.lock
RUN bundle install
COPY . /buho
