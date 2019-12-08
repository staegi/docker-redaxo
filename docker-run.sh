#!/bin/sh
set -euo pipefail

unzip -o /redaxo.zip -d /var/www/html
chmod +x redaxo/bin/console
chown -R www-data:www-data .
redaxo/bin/console db:set-connection --host=$REDAXO_DATABASE_HOST --database=$REDAXO_DATABASE_NAME --login=$REDAXO_DATABASE_USERNAME --password=$REDAXO_DATABASE_PASSWORD
redaxo/bin/console setup:check

php-fpm
