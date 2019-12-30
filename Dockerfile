FROM php:7.4.0-fpm-alpine
ENTRYPOINT ["docker-php-entrypoint"]

RUN apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		freetype-dev \
		libjpeg-turbo-dev \
		libpng-dev \
		libzip-dev \
	; \
RUN set -ex; docker-php-ext-configure gd --with-freetype --with-jpeg;
RUN set -ex; docker-php-ext-install -j "$(nproc)" gd pdo_mysql zip;

COPY php.ini /usr/local/etc/php

VOLUME /var/www/html

ENV REDAXO_DATABASE_HOST mysql
ENV REDAXO_DATABASE_NAME redaxo
ENV REDAXO_DATABASE_USERNAME redaxo
ENV REDAXO_DATABASE_PASSWORD redaxo
ENV REDAXO_VERSION 5.8.1

RUN curl -o /redaxo.zip -fSL "https://redaxo.org/download/redaxo/${REDAXO_VERSION}.zip"

COPY fix-perms.sh /usr/local/bin/fixperms
RUN chmod +x /usr/local/bin/fixperms

COPY docker-run.sh /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
CMD ["run"]
