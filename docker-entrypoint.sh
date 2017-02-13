#!/bin/bash
set -e

if [ ! -e piwik.php ]; then
	tar cf - --one-file-system -C /usr/src/piwik . | tar xf -
	chown -R www-data .
fi

# Run php-fpm here so we don't have to think about it anymore
php-fpm --daemonize

exec "$@"
