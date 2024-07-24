# Dockerfile development version
FROM ruby:3.2.2-alpine AS geolocation-development

RUN apk -U upgrade && apk add --no-cache curl postgresql-dev build-base tzdata bash gcompat git

WORKDIR /opt/app

COPY application/Gemfile application/Gemfile.lock ./

ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLE_PATH="/usr/local/bundle"

RUN rm -rf node_modules vendor && \
    gem install bundler && \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY application .

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

RUN adduser geolocation --disabled-password --shell /bin/bash && \
    chown -R geolocation:geolocation db log storage tmp coverage
USER geolocation

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
