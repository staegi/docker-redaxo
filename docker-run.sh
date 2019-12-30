#!/bin/sh
set -euo pipefail

if [ ! -e redaxo ]; then
    sudo -u www-data unzip -o /redaxo.zip -d /var/www/html
else
    echo "Redaxo has already been installed"
fi

echo "Try to make console file executable"
chmod a+x redaxo/bin/console

if [ -x redaxo/bin/console ]; then
    echo "Set database connection to $REDAXO_DATABASE_NAME on $REDAXO_DATABASE_HOST"
    php redaxo/bin/console db:set-connection --host=$REDAXO_DATABASE_HOST --database=$REDAXO_DATABASE_NAME --login=$REDAXO_DATABASE_USERNAME --password=$REDAXO_DATABASE_PASSWORD

    echo "Check setup"
    php redaxo/bin/console setup:check
else
    echo "Console file is not executable"
    exit
fi

echo "Assign www-data to files"
chown -R www-data:www-data .

if [ -w . ]; then
    echo "Directory is writable"
else
    echo "Make directory writable"
    chmod -R a+w,g+s .
fi

echo "Finally launch FPM"
php-fpm
