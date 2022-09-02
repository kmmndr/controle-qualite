# Contrôle qualité (Quality Control)

This project aims to group each and every required tool for ensuring
Ruby on Rails development quality.

It currently includes the following ruby tools:
- [bundler-audit](https://github.com/rubysec/bundler-audit)
- [brakeman](https://github.com/presidentbeef/brakeman)
- [rubocop](https://github.com/rubocop/rubocop)
- [slim-lint](https://github.com/sds/slim-lint)

As well as CSS/JS node tools:
- [eslint](https://eslint.org)
- [prettier](https://prettier.io)
- [standard](https://standardjs.com/)
- [stylelint](https://stylelint.io/)

## Usage

### Gitlab CI

Adding `controle-qualite` to gitlab-ci.yml is staitforward:

```
.controle_qualite: &controle_qualite
  image: registry/controle-qualite:latest
  stage: pre-test

pre-test:check-tools:
  <<: *controle_qualite
  script:
    - controle-qualite.mk self-check
  allow_failure: true

pre-test:lint:rubocop:
  <<: *controle_qualite
  script:
    - controle-qualite.mk rubocop

pre-test:audit:bundle-audit:
  <<: *controle_qualite
  script:
    - controle-qualite.mk bundle-audit
  allow_failure: true

pre-test:audit:brakeman:
  <<: *controle_qualite
  script:
    - controle-qualite.mk brakeman
  allow_failure: true
```
