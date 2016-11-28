#!/bin/sh

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

echo "Starting apache"
exec "$@"
