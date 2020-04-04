FROM ruby:latest as build
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
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
RUN bundle config deployment without development test
RUN bundle install --jobs=4
ADD package.json yarn.lock $APP_DIR/
RUN yarn install
ADD . $APP_DIR
# put dummy secret key to ensure success
RUN SECRET_KEY_BASE=secret bundle exec rails assets:precompile
RUN rm -rf $APP_DIR/node_modules
RUN rm -rf $APP_DIR/tmp/*

FROM ruby:slim
RUN apt-get update && apt-get install -y libmagic-dev bubblewrap cpulimit libpq-dev
RUN mkdir -p /app
WORKDIR /app
COPY --from=build /app /app
EXPOSE 8000
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
RUN ln -sf /proc/1/fd/1 /app/log/production.log
RUN bundle config --local path vendor/bundle
RUN bundle config --local without development:test:assets
CMD bundle exec rails server -p $PORT
