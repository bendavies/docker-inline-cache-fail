# syntax = docker/dockerfile:1.0-experimental

ARG NGINX_VERSION=1.15

FROM usabillabv/php:7.4-cli-alpine3.11 AS composer

WORKDIR /srv/app

ENV COMPOSER_ALLOW_SUPERUSER=1
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN set -eux; \
    composer global require "symfony/flex" --prefer-dist --no-progress --no-suggest --classmap-authoritative;

COPY composer.json composer.lock symfony.lock ./

RUN set -eux; \
	composer install --prefer-dist --no-dev --no-autoloader --no-scripts --no-progress --no-suggest; \
	composer clear-cache;

FROM usabillabv/php:7.4-fpm-alpine3.11 AS php

ENV COMPOSER_ALLOW_SUPERUSER=1

# persistent / runtime deps
RUN apk add --no-cache acl

WORKDIR /srv/app

ARG APP_ENV=prod

COPY composer.json composer.lock symfony.lock ./

RUN echo '<?php return [];' > .env.local.php

COPY bin bin/
COPY config config/
COPY public public/
COPY src src/
COPY templates templates/
COPY translations translations/
COPY --from=composer /srv/app/vendor vendor/
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN set -eux; \
	mkdir -p var/cache var/log; \
	composer dump-autoload --classmap-authoritative --no-dev; \
	composer run-script --no-dev post-install-cmd; \
	chmod +x bin/console; sync
VOLUME /srv/app/var