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
      yarn

RUN apk add --no-cache binutils pandoc \
 && strip /usr/bin/pandoc \
 && apk del binutils

RUN gem install --no-document bundler \
      bundler-audit:0.9.1 \
      brakeman:5.2.3 \
      rubocop:1.29.1 rubocop-performance rubocop-rails \
      slim_lint:0.22.1 \
      pandoc-ruby

RUN yarn global add @captive/eslint-config \
                    @captive/stylelint-config \
                    eslint \
                    eslint-plugin-unicorn \
                    stylelint \
                    prettier

COPY --chmod=+x controle-qualite.mk /usr/local/bin
