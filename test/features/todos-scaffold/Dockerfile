FROM ruby:3.3.0-slim-bullseye

ARG BUILD_PACKAGES="build-essential git libvips pkg-config sqlite3 libsqlite3-dev"

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y $BUILD_PACKAGES

WORKDIR /usr/src/app

ENV LANG C.UTF-8
ENV BUNDLER_VERSION 2.1
ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

COPY Gemfile Gemfile.lock uni_rails.gem ./
RUN gem install uni_rails.gem
RUN bundle install

COPY . /usr/src/app

CMD ["ruby", "app.rb"]