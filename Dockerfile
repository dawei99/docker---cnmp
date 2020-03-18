FROM docker.io/2233466866/lnmp
EXPOSE 80
COPY libzip-1.2.0.tar.gz /opt/
COPY php-7.3.15.tar.gz /opt/
RUN sed -i 'N;32a include /usr/local/nginx/conf/vhosts/*.conf;' /usr/local/nginx/conf/nginx.conf \

        # 自定义server配置文件
        &&    mkdir -p /usr/local/nginx/conf/vhosts \
        &&    echo validate_password=OFF >> /etc/my.cnf \
        &&    sed -ie "s/socket=\/var\/lib\/mysql\/mysql.sock/socket=\/tmp\/mysql.sock/"  /etc/my.cnf \
        &&    sed -ie "s/;extension=mysqli/extension=mysqli/"  /usr/local/php7/lib/php.ini \

        # yum操作
        &&    yum install -y wget \
        &&    yum install -y libxslt-devel \
        &&    yum remove -y libzip \

        # 安装扩展
        &&    tar -zxvf /opt/libzip-1.2.0.tar.gz -C /opt/ \
        &&    cd /opt/libzip-1.2.0/ \
        &&    ./configure \
        &&    make -C  /opt/libzip-1.2.0/ && make install -C /opt/libzip-1.2.0/ \

        # 编译新php7.3.15
        &&    mkdir -p /usr/local/php7.3.15/ \
        &&    cp /opt/php-7.3.15.tar.gz /usr/local/php7.3.15/php-7.3.15.tar.gz \
        &&    tar -xzvf /usr/local/php7.3.15/php-7.3.15.tar.gz -C /usr/local/php7.3.15/ \
        &&    cd /usr/local/php7.3.15/php-7.3.15 \
        &&    ./configure --prefix=/usr/local/php_7.3.15  --with-zlib --enable-fpm --with-mysqli  \
        &&    make && make install \

        # 开启配置文件
        &&    cp /usr/local/php_7.3.15/etc/php-fpm.conf.default /usr/local/php_7.3.15/etc/php-fpm.conf \
        &&    cp /usr/local/php_7.3.15/etc/php-fpm.d/www.conf.default /usr/local/php_7.3.15/etc/php-fpm.d/www.conf \
        &&    cp /usr/local/php7.3.15/php-7.3.15/php.ini-development /usr/local/php_7.3.15/lib/php.ini \


        # 编译curl扩展
        &&    cd /usr/local/php7.3.15/php-7.3.15/ext/curl \
        &&    /usr/local/php_7.3.15/bin/phpize \
        &&    ./configure --with-php-config=/usr/local/php_7.3.15/bin/php-config \
        &&    make  && make install \
        &&    sed -ie "s/;extension=curl/extension=curl/"  /usr/local/php_7.3.15/lib/php.ini \

        # 编译gd扩展
        &&    cd /usr/local/php7.3.15/php-7.3.15/ext/gd \
        &&    /usr/local/php_7.3.15/bin/phpize \
        &&    ./configure --with-php-config=/usr/local/php_7.3.15/bin/php-config \
        &&    make  && make install \
        &&    sed -ie "s/;extension=gd2/extension=gd/"  /usr/local/php_7.3.15/lib/php.ini \

        # 创建bin文件
        &&    ln -sf /usr/local/php_7.3.15/bin/php /usr/bin/php

VOLUME ["/usr/local/nginx/conf/vhosts"]
CMD ["/opt/init.sh"]
