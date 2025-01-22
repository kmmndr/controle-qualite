FROM alpine:3.21.2 AS base

RUN sed -i -e 's|^\(.*\)v[0-9.]*/main|@edge-community \1edge/community\n&|' /etc/apk/repositories

LABEL "org.opencontainers.image.source"="https://github.com/kmmndr/controle-qualite"

WORKDIR /srv/app

RUN apk add --no-cache \
      coreutils \
      make \
      git \
      ruby \
      ruby-sassc

RUN apk add --update binutils pandoc@edge-community \
 && strip /usr/bin/pandoc \
 && apk del binutils \
 && rm /var/cache/apk/*

COPY --chmod=755 controle-qualite.mk /usr/local/bin

FROM base AS build

RUN apk add --no-cache \
      coreutils \
      ruby-dev build-base

ARG BUNDLER_AUDIT_VERSION=0.9.2
ARG BRAKEMAN_VERSION=7.0.0
ARG RUBOCOP_VERSION=1.70.0
ARG SLIM_LINT_VERSION=0.31.1
ARG I18N_TASKS_VERSION=1.0.14

RUN gem install --no-document bundler \
      bundler-audit:${BUNDLER_AUDIT_VERSION} \
      brakeman:${BRAKEMAN_VERSION} \
      rubocop:${RUBOCOP_VERSION} rubocop-performance rubocop-rails rubocop-rspec rubocop-capybara rubocop-factory_bot \
      slim_lint:${SLIM_LINT_VERSION} \
      i18n-tasks:${I18N_TASKS_VERSION} \
      pandoc-ruby

FROM base

COPY --from=build /usr/lib/ruby /usr/lib/ruby

COPY --from=build /usr/bin/brakeman      /usr/bin/
COPY --from=build /usr/bin/bundle        /usr/bin/
COPY --from=build /usr/bin/bundle-audit  /usr/bin/
COPY --from=build /usr/bin/bundler       /usr/bin/
COPY --from=build /usr/bin/bundler-audit /usr/bin/
COPY --from=build /usr/bin/i18n-tasks    /usr/bin/
COPY --from=build /usr/bin/rake          /usr/bin/
COPY --from=build /usr/bin/rubocop       /usr/bin/
COPY --from=build /usr/bin/slim-lint     /usr/bin/
COPY --from=build /usr/bin/slimrb        /usr/bin/
