#!/bin/sh

mkdir -p $(HOME)/.ssh && \
test -e /var/tmp/id && cp /var/tmp/id $(HOME)/.ssh/id_rsa ; \
test -e /var/tmp/known_hosts && cp /var/tmp/known_hosts $(HOME)/.ssh/known_hosts ; \
test -e $(HOME)/.ssh/id_rsa && chmod 600 $(HOME)/.ssh/id_rsa ;

IP=`/sbin/ip route|awk '/default/ { print $3 }'`
cp /usr/local/etc/php/php.ini /tmp
sed -i "s/xdebug.remote_host=.*/xdebug.remote_host=$IP/g" /tmp/php.ini
cp /tmp/php.ini /usr/local/etc/php/php.ini


VHOST=/etc/apache2/sites-enabled/000-default.conf

# Use /var/www/html/glpi as DocumentRoot
sed -i -- 's/DocumentRoot .*/DocumentRoot \/var\/www\/web/g' $VHOST
# Remove ServerSignature (secutiry)
sed -i -- '/ServerSignature /d' $VHOST
awk '/<\/VirtualHost>/{print "ServerSignature Off" RS $0;next}1' $VHOST > tmp && mv tmp $VHOST
# Enable .htaccess
sed -i -- '/<Directory /d' $VHOST
awk '/<\/VirtualHost>/{print "<Directory \"/var/www/web\">" RS $0;next}1' $VHOST > tmp && mv tmp $VHOST
sed -i -- '/AllowOverride All/d' $VHOST
awk '/<\/VirtualHost>/{print "AllowOverride All" RS $0;next}1' $VHOST > tmp && mv tmp $VHOST
sed -i -- '/<\/Directory/d' $VHOST
awk '/<\/VirtualHost>/{print "</Directory>" RS $0;next}1' $VHOST > tmp && mv tmp $VHOST

exec "$@"
