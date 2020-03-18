#!/usr/bin/sh

# 设置权限
chown -R mysql:mysql /data/mysql
chmod -R 775 /data/mysql
chown -R nobody:www /www
chmod -R 775 /www

# 替换新php服务
pkill php-fpm
/usr/local/php_7.3.15/sbin/php-fpm
