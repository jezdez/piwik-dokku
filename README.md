## piwik-dokku

This is a Dokku enabled Docker setup for Dokku.

It uses [Piwik's official docker image](https://hub.docker.com/_/piwik/)
(currently version 3) and extends it with running a slim Nginx server
for the php-fpm process.

### Setup

Create the app, install the core MariaDB or MySQL plugins and link
a new database to the app:

```
dokku apps:create piwik
dokku mariadb:create piwik
dokku mariadb:link piwik piwik
```

### Storage

Then create a storage directory on the server so that installations of
Piwik can be backed-up and installing plugins will persist deployments:

```
mkdir /var/lib/dokku/data/storage/piwik
chown -R 32767:32767 /var/lib/dokku/data/storage/piwik
dokku storage:mount piwik /var/lib/dokku/data/storage/piwik:/var/www/html
```

### Archiving

Add the following entry to the crontab in `/etc/cron.d/piwik

```
# server cron jobs
MAILTO="root@example.com"
PATH=/usr/local/bin:/usr/bin:/bin
SHELL=/bin/bash

# m   h   dom mon dow   username command
# *   *   *   *   *     dokku    command to be executed
# -   -   -   -   -
# |   |   |   |   |
# |   |   |   |   +----- day of week (0 - 6) (Sunday=0)
# |   |   |   +------- month (1 - 12)
# |   |   +--------- day of month (1 - 31)
# |   +----------- hour (0 - 23)
# +----------- min (0 - 59)

### HIGH TRAFFIC TIME IS B/W 00:00 - 04:00 AND 14:00 - 23:59
### RUN YOUR TASKS FROM 04:00 - 14:00
### KEEP SORTED IN TIME ORDER

### PLACE ALL CRON TASKS BELOW

@hourly dokku dokku --rm run piwik su -s "/bin/bash" -c "/usr/local/bin/php /var/www/html/console core:archive" www-data

### PLACE ALL CRON TASKS ABOVE, DO NOT REMOVE THE WHITESPACE AFTER THIS LINE
```
