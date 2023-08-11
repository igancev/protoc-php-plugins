FROM php:8.2-cli-alpine3.18

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Зависимости сборки
RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        linux-headers \
    && mkdir -p /tmp/pear/cache \
    && apk add --update --no-cache \
        openssl-dev \
        cmake \
        libunwind \
        libunwind-dev \
        pcre-dev \
        icu-dev \
        icu-data-full \
        libzip-dev \
        git \
        go \
# Утилита "protoc" и официальный плагин генерации клиентского кода "grpc_php_plugin"
    && mkdir /build && cd /build \
    && git clone --recursive -b v1.27.x https://github.com/grpc/grpc \
    && mkdir -p /build/grpc/cmake/build && cd /build/grpc/cmake/build \
    && cmake ../.. \
    && make protoc grpc_php_plugin \
# Плагин генерации серверного кода "protoc-gen-php-grpc" от roadrunner
    && cd /build \
    && composer create-project --ignore-platform-reqs spiral/roadrunner-cli \
    && chmod +x ./roadrunner-cli/bin/rr \
    && ./roadrunner-cli/bin/rr download-protoc-binary -l /usr/bin \
    && cp /build/grpc/cmake/build/grpc_php_plugin /usr/bin \
    && cp /build/grpc/cmake/build/third_party/protobuf/protoc /usr/bin \
    && chmod +x /usr/bin/protoc-gen-php-grpc \
    && chmod +x /usr/bin/grpc_php_plugin \
    && chmod +x /usr/bin/protoc \
    # Очистка
    && rm -rf /build \
    && pecl clear-cache \
    && apk del --purge .build-deps

WORKDIR /app

CMD "protoc"
