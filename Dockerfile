FROM alpine:3.18.4
RUN sed -i -e 's|^\(.*\)v[0-9.]*/main|@edge-community \1edge/community\n&|' /etc/apk/repositories

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
      bundler-audit:0.9.1 \
      brakeman:5.4.1 \
      rubocop:1.48.1 rubocop-performance rubocop-rails rubocop-rspec \
      slim_lint:0.24.0 \
      pandoc-ruby

RUN yarn global add @captive/eslint-config \
                    @captive/stylelint-config \
                    eslint \
                    eslint-plugin-unicorn \
                    stylelint \
                    prettier

COPY --chmod=+x controle-qualite.mk /usr/local/bin
