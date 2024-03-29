# FROM php:8.0-apache


# RUN apt-get update && \
#     apt-get install -y \
#         libzip-dev \
#         unzip \
#         && \
#     docker-php-ext-install pdo_mysql && \
#     a2enmod rewrite && \
#     service apache2 restart

# WORKDIR /var/www/html

# COPY ./src ./

# EXPOSE 80

# Menggunakan base image Ubuntu 18.04 LTS
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Update paket-paket yang tersedia dan instal dependensi yang diperlukan
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    apache2 \
    mysql-server \
    php \
    libapache2-mod-php \
    php-mysql \
    php-curl \
    php-gd \
    php-xml \
    php-mbstring \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Aktifkan modul-modul Apache yang diperlukan
RUN a2enmod rewrite

# Salin konfigurasi Apache agar bisa menjalankan .htaccess
COPY apache2.conf /etc/apache2/apache2.conf

# Restart Apache untuk menerapkan perubahan konfigurasi
# RUN service apache2 restart

# Buat direktori tempat Elgg akan diinstal
WORKDIR /var/www/html

# Unduh dan ekstrak Elgg
RUN apt-get install -y wget && \
    wget https://elgg.org/download/elgg-1.7.10.zip && \
    unzip elgg-1.7.10.zip && \
    mv elgg-1.7.10/* . && \
    rm elgg-1.7.10.zip && \
    rm -rf elgg-1.7.10

# Set izin untuk direktori Elgg
RUN chown -R www-data:www-data /var/www/html

# Expose port 80 untuk akses web
EXPOSE 80

# Menjalankan Apache di dalam kontainer saat kontainer dijalankan
CMD ["apache2ctl", "-D", "FOREGROUND"]
