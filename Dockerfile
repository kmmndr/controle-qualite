FROM alpine:3.18.4
RUN sed -i -e 's|^\(.*\)v[0-9.]*/main|@edge-community \1edge/community\n&|' /etc/apk/repositories

ARG BUNDLER_AUDIT_VERSION=0.9.1
ARG BRAKEMAN_VERSION=6.0.1
ARG RUBOCOP_VERSION=1.57.2
ARG SLIM_LINT_VERSION=0.24.0

WORKDIR /srv/app

RUN apk add --no-cache \
      coreutils \
      git \
      make \
      ruby \
      ruby-sassc \
      nodejs \
      yarn

RUN apk add --update binutils pandoc@edge-community \
 && strip /usr/bin/pandoc \
 && apk del binutils \
 && rm /var/cache/apk/*

RUN gem install --no-document bundler \
      bundler-audit:${BUNDLER_AUDIT_VERSION} \
      brakeman:${BRAKEMAN_VERSION} \
      rubocop:${RUBOCOP_VERSION} rubocop-performance rubocop-rails rubocop-rspec \
      slim_lint:${SLIM_LINT_VERSION} \
      pandoc-ruby

RUN yarn global add @captive/eslint-config \
                    @captive/stylelint-config \
                    eslint \
                    eslint-plugin-unicorn \
                    stylelint \
                    prettier

COPY --chmod=+x controle-qualite.mk /usr/local/bin
