FROM ruby:2.7.2-alpine as builder

ENV RAILS_ENV=production \
    NODE_ENV=production

WORKDIR /app

RUN apk add --no-cache nodejs yarn build-base tzdata 

COPY . /app/
 # Install gems
RUN bundle config set without 'development test' \
 && bundle install 
 # Install & compile yarn packages
RUN yarn install \
 && rails webpacker:compile \
 && rails assets:precompile \
 # Remove unneeded files (cached *.gem, *.o, *.c)
 && rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete \
 # Remove folders not needed in resulting image
 && rm -rf node_modules tmp/cache vendor/assets spec

FROM ruby:2.7.2-alpine

WORKDIR /app

ENV RAILS_LOG_TO_STDOUT=true \
    RAILS_ENV=production \
    NODE_ENV=production \
    RAILS_SERVE_STATIC_FILES=true

RUN apk add --no-cache tzdata

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app/ /app/

EXPOSE 3000

ENTRYPOINT ["sh", "entrypoint.sh"]