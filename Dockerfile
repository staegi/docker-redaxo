FROM php:7.4.0-fpm-alpine
ENTRYPOINT ["docker-php-entrypoint"]

RUN apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		freetype-dev \
		libjpeg-turbo-dev \
		libpng-dev
RUN set -ex; \
	    docker-php-ext-install -j "$(nproc)" gd mysqli pdo pdo_mysql;

VOLUME /var/www/html/media

ENV REDAXO_DATABASE_HOST mysql
ENV REDAXO_DATABASE_NAME redaxo
ENV REDAXO_DATABASE_USERNAME redaxo
ENV REDAXO_DATABASE_PASSWORD redaxo
ENV REDAXO_VERSION 5.8.1

RUN curl -o /redaxo.zip -fSL "https://redaxo.org/download/redaxo/${REDAXO_VERSION}.zip"

COPY docker-run.sh /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
CMD ["run"]
