FROM alpine:3.15
RUN sed -i -e 's|^\(.*\)v3.15/main|\1edge/testing\n&|' /etc/apk/repositories

WORKDIR /srv/app

RUN apk add --no-cache \
      coreutils \
      git \
      make \
      ruby \
      ruby-sassc \
      nodejs \
      npm

RUN apk add --no-cache binutils pandoc \
 && strip /usr/bin/pandoc \
 && apk del binutils

RUN gem install --no-document bundler \
      bundler-audit:0.9.0.1 \
      brakeman:5.2.1 \
      rubocop:1.25.1 rubocop-performance rubocop-rails \
      slim_lint:0.22.1 \
      pandoc-ruby

RUN npm install -g \
      eslint@7.29.0 \
      prettier@2.3.2 \
      standard-prettier@1.0.1 \
      standard@16.0.4 \
      stylelint@13.13.1 \
      'https://github.com/Captive-Studio/captive-js-lint.git#1.0.0'

COPY --chmod=+x controle-qualite.mk /usr/local/bin
