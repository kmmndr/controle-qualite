FROM alpine:3.20.2
RUN sed -i -e 's|^\(.*\)v[0-9.]*/main|@edge-community \1edge/community\n&|' /etc/apk/repositories

LABEL "org.opencontainers.image.source"="https://github.com/kmmndr/controle-qualite"

WORKDIR /srv/app

RUN apk add --no-cache \
      coreutils \
      git \
      make \
      ruby \
      ruby-dev build-base \
      ruby-sassc \
      nodejs \
      yarn

RUN apk add --update binutils pandoc@edge-community \
 && strip /usr/bin/pandoc \
 && apk del binutils \
 && rm /var/cache/apk/*

ARG BUNDLER_AUDIT_VERSION=0.9.2
ARG BRAKEMAN_VERSION=6.2.1
ARG RUBOCOP_VERSION=1.66.1
ARG SLIM_LINT_VERSION=0.29.0
ARG I18N_TASKS_VERSION=1.0.14

RUN gem install --no-document bundler \
      bundler-audit:${BUNDLER_AUDIT_VERSION} \
      brakeman:${BRAKEMAN_VERSION} \
      rubocop:${RUBOCOP_VERSION} rubocop-performance rubocop-rails rubocop-rspec rubocop-capybara rubocop-factory_bot \
      slim_lint:${SLIM_LINT_VERSION} \
      i18n-tasks:${I18N_TASKS_VERSION} \
      pandoc-ruby

COPY --chmod=+x controle-qualite.mk /usr/local/bin
