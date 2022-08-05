#!/usr/bin/env bash

echo '
--------------------------------------------------------------
                   ____  ____  ____  ____
                  ( ___)( ___)( ___)(  _ \
                   )__)  )__)  )__)  )(_) )
                  (__)  (____)(____)(____/
           __    ___  ____  ____  _____  _  _  ___
          /__\  / __)(_  _)(_  _)(  _  )( \( )/ __)
         /(__)\( (__   )(   _)(_  )(_)(  )  ( \__ \
        (__)(__)\___) (__) (____)(_____)(_)\_)(___/

         https://github.com/lapicidae/feed-actions
--------------------------------------------------------------'
echo '
  Please use the file "fa-cron" to adjust the scheduled time.

--------------------------------------------------------------'
echo "
 Timezone:    $TZ

--------------------------------------------------------------
"

# make folders
if [ ! -d "/config" ]; then
	mkdir -p /config
fi

# add fa-cron file
if [ ! -e /config/fa-cron ]; then
	cp /defaults/fa-cron /config/fa-cron
fi

# add config.cfg file
if [ ! -e /config/config.cfg ]; then
	cp /defaults/config.cfg /config/config.cfg
fi

# set timezone
if [ -d "/usr/share/zoneinfo/$TZ" ]; then
	CURRENT_TZ=$(readlink /etc/localtime)
	if [[ ! $CURRENT_TZ =~ $TZ ]]; then
		unlink /etc/localtime
		ln -s "/usr/share/zoneinfo/$TZ" /etc/localtime
		echo "$TZ" >/etc/timezone
		echo "New timezone $TZ set!"
	fi
fi

# set crontab
crontab /config/fa-cron

exec crond -f
