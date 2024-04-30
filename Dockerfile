FROM php:7.4.33-fpm                                                                                                                                                      
RUN apt-get update -y && apt-get install -y cron && apt-get  install -y vim && apt install libgmp-dev -y && docker-php-ext-install gmp && apt-get install -y libgeoip-dev && apt-get install -y libzip-dev zip
# PHP_CPPFLAGS are used by the docker-php-ext-* scripts
ENV PHP_CPPFLAGS="$PHP_CPPFLAGS -std=c++11"
COPY myext/ /usr/src/php/ext/
RUN docker-php-ext-install pdo_mysql \                                                                                                                                   
    && docker-php-ext-install opcache \                                                                                                                                  
    && apt-get install libicu-dev -y \                                                                                                                                   
    && docker-php-ext-configure intl \                                                                                                                                   
    && docker-php-ext-install intl \                                                                                                                                     
    && docker-php-ext-install zip \                                                                                                                                      
    && docker-php-ext-install sockets \                                                                                                                                  
    && docker-php-ext-install bcmath \                                                                                                                                   
    && docker-php-ext-install pcntl \                                                                                                                                    
    && apt-get remove libicu-dev icu-devtools -y \                                                                                                                       
    && docker-php-ext-install geoip \
	&& docker-php-ext-install swoole \
    && docker-php-ext-install inotify \
	&& pecl install redis && docker-php-ext-enable redis && && docker-php-ext-enable sockets && pecl install apcu && docker-php-ext-enable apcu
RUN { \                                                                                                                                                                  
        echo 'opcache.memory_consumption=128'; \                                                                                                                         
        echo 'opcache.interned_strings_buffer=8'; \                                                                                                                      
        echo 'opcache.max_accelerated_files=4000'; \                                                                                                                     
        echo 'opcache.revalidate_freq=2'; \                                                                                                                              
        echo 'opcache.fast_shutdown=1'; \                                                                                                                                
        echo 'opcache.enable_cli=1'; \                                                                                                                                   
    } > /usr/local/etc/php/conf.d/php-opocache-cfg.ini