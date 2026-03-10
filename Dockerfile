# Image de base PHP 8.4 avec FPM
FROM php:8.4-fpm

# Informations sur le Dockerfile
LABEL maintainer="Template WordPress Docker"
LABEL description="PHP 8.4-FPM avec extensions WordPress et WP-CLI"

# Variables d'environnement
ENV DEBIAN_FRONTEND=noninteractive

# Installation des dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    # Outils de base
    curl \
    wget \
    git \
    unzip \
    # Dépendances pour les extensions PHP
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    # Utilitaires
    bash \
    && rm -rf /var/lib/apt/lists/*

# Installation des extensions PHP nécessaires pour WordPress
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    mysqli \
    pdo \
    pdo_mysql \
    gd \
    zip \
    intl \
    exif \
    opcache

# Configuration de PHP pour WordPress (limites et optimisations)
RUN echo "upload_max_filesize = 64M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size = 64M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "memory_limit = 256M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "max_input_time = 300" >> /usr/local/etc/php/conf.d/uploads.ini

# Installation de WP-CLI (outil en ligne de commande pour WordPress)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && wp --info

# Installation de Composer (gestionnaire de dépendances PHP)
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && composer --version

# Création du répertoire de travail WordPress
WORKDIR /var/www/html

# Définition de l'utilisateur (optionnel, pour éviter les problèmes de permissions)
# Note: Sur Mac/Linux/WSL, les permissions sont généralement gérées par le bind mount

# Expose le port PHP-FPM (utilisé par Nginx)
EXPOSE 9000

# Commande par défaut
CMD ["php-fpm"]
