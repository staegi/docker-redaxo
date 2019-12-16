#!/bin/sh
set -euo pipefail

if [ ! -e redaxo ]; then
    unzip -o /redaxo.zip -d /var/www/html
else
    echo "Redaxo has already been installed"
fi

echo "Try to make console file executable"
chmod a+x redaxo/bin/console

if [ -x redaxo/bin/console ]; then
    echo "Set database connection to $REDAXO_DATABASE_NAME on $REDAXO_DATABASE_HOST"
    redaxo/bin/console db:set-connection --host=$REDAXO_DATABASE_HOST --database=$REDAXO_DATABASE_NAME --login=$REDAXO_DATABASE_USERNAME --password=$REDAXO_DATABASE_PASSWORD

    echo "Check setup"
    redaxo/bin/console setup:check
else
    echo "Console file is not executable"
fi

echo "Correcting file permissions"
chown -R www-data:www-data .
chmod -R a+w,g+s .

echo "Finally launch FPM"
php-fpm
