#!/usr/bin/env bash
echo "===================================="
echo "Installing phpMyAdmin"
echo "===================================="

sudo su
APP_PASS="123"
ROOT_PASS="123"
APP_DB_PASS="123"

echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $APP_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $ROOT_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $APP_DB_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

sudo apt-get autoremove -y
sudo apt-get update
sudo apt-get install phpmyadmin php-gettext php-mbstring -y

echo "============================================="
echo "Adding conf-enabled directory to apache2.conf"
echo "============================================="
echo 'IncludeOptional "/etc/apache2/conf-enabled/*"' >>  /etc/apache2/apache2.conf
echo "============================================="
echo "Restarting Apache"
echo "============================================="
sudo sudo systemctl restart apache2
exit