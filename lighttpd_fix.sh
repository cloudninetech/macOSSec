#!/bin/bash
set -euxo pipefail
LOG="/boot/lighttpd_fix.log"
exec > >(tee -a "$LOG") 2>&1
systemctl restart lighttpd
systemctl status lighttpd --no-pager
if [ ! -L /etc/lighttpd/conf-enabled/15-fastcgi-php.conf ]; then
  ln -s /etc/lighttpd/conf-available/15-fastcgi-php.conf /etc/lighttpd/conf-enabled/
  systemctl restart lighttpd
fi
lsof -i :80 || echo "port 80 unavailable"
