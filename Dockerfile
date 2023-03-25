# Use the official PHP image as the base image
FROM php:7.4-apache

# Install required PHP extensions
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# Install additional dependencies for MediaWiki
RUN apt-get update && apt-get install -y libicu-dev libxml2-dev libzip-dev zip git

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set up the MediaWiki code
RUN git clone --depth 1 https://gerrit.wikimedia.org/r/mediawiki/core.git /var/www/html/mediawiki

# Install MediaWiki dependencies
RUN cd /var/www/html/mediawiki && composer install --no-dev

# Set up Apache configuration for MediaWiki
COPY mediawiki.conf /etc/apache2/sites-available/

# Enable the Apache configuration for MediaWiki
RUN a2ensite mediawiki.conf

# Expose port 80 for the Apache server
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]

