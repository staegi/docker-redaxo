#!/bin/sh
set -euo pipefail

echo "Correcting file permissions"
chown -R www-data:www-data
chmod -R a+w,g+s .
