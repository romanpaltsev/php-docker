FROM php:8.3-fpm

# 1️⃣ Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# 2️⃣ PHP-расширения
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        pdo \
        pdo_mysql \
        mbstring \
        zip \
        intl \
        gd \
        opcache

# 3️⃣ Composer (официальный способ)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 4️⃣ Рабочая директория
WORKDIR /var/www/html

# 5️⃣ (опционально) права — часто нужно для фреймворков
RUN chown -R www-data:www-data /var/www/html

# 6️⃣ Запуск PHP-FPM
CMD ["php-fpm"]
