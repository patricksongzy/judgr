FROM ruby:latest as build
# get and install node
# TODO upgrade, deprecated
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
# get and install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn
# set the app directory and rails environment
RUN apt-get install -y libmagic-dev
ENV APP_DIR=/app
ENV RAILS_ENV=production
RUN mkdir -p $APP_DIR
WORKDIR $APP_DIR
# put the Gemfiles
ADD Gemfile Gemfile.lock $APP_DIR/
RUN bundle install --deployment --jobs=4 --without development test
ADD package.json yarn.lock $APP_DIR/
RUN yarn install
ADD . $APP_DIR
# RUN bundle exec rails assets:precompile
RUN rm -rf $APP_DIR/node_modules
RUN rm -rf $APP_DIR/tmp/*

FROM ruby:slim
RUN apt-get update && apt-get install -y bubblewrap cpulimit
RUN mkdir -p /app
WORKDIR /app
COPY --from=build /app /app
EXPOSE 3000
ENV RAILS_ENV=production
RUN bundle config --local path vendor/bundle
RUN bundle config --local without development:test:assets
CMD bundle exec rails server
