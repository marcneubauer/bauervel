FROM php:7.2-apache

RUN apt-get update -y \
&& apt-get install -y \
    curl \
    git \
    gnupg2 \
    openssl \
    unzip \
    vim \    
    zip
    
# composer and app
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# node and its needs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -y \
&& apt-get install -y \
    make \
    libpng-dev \
    nodejs     
    
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    mbstring

COPY ./base /app
COPY ./settings/.env /app/.env

WORKDIR /app

RUN composer install
RUN npm install

RUN npm update

#RUN php artisan key:generate
#RUN php artisan migrate
#RUN php artisan db:seed

#CMD php artisan serve --host=0.0.0.0 --port=81
COPY ./settings/bv.conf /etc/apache2/sites-available/bv.conf
RUN echo "ServerName bauervel.map" >> /etc/apache2/apache2.conf

RUN a2dissite 000-default && \
    a2ensite bv.conf


ENTRYPOINT ["tail", "-f", "/dev/null"]
