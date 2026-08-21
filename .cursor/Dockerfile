# Cloud Agent base image for Nirogi Sathi
# - Laravel 12 backend (PHP 8.3 + Composer + Node/Vite)
# - Flutter frontend (Flutter 3.47.1 / Dart 3.13.1)
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    FLUTTER_HOME=/opt/flutter \
    PATH=/opt/flutter/bin:/usr/local/bin:/usr/bin:/bin

# System packages: PHP 8.3 + extensions required by Laravel, plus build tooling.
# `locales` is required by the Cloud Agent VNC/browser (computer-use) setup.
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl git unzip xz-utils gnupg locales \
      sqlite3 \
      php-cli php-mbstring php-xml php-bcmath php-curl php-sqlite3 php-gd php-zip php-intl php-tokenizer \
 && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
 && locale-gen en_US.UTF-8 \
 && rm -rf /var/lib/apt/lists/*

# Composer (PHP dependency manager)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
 && composer --version

# Node.js 22 LTS (for the Laravel Vite asset pipeline)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
 && apt-get install -y --no-install-recommends nodejs \
 && rm -rf /var/lib/apt/lists/* \
 && node --version && npm --version

# Flutter SDK (pinned stable release; provides Dart >= 3.11 required by pubspec.yaml)
RUN curl -L -o /tmp/flutter.tar.xz \
      "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.47.1-stable.tar.xz" \
 && tar -xf /tmp/flutter.tar.xz -C /opt \
 && rm -f /tmp/flutter.tar.xz \
 && git config --system --add safe.directory /opt/flutter \
 && ln -sf /opt/flutter/bin/flutter /usr/local/bin/flutter \
 && ln -sf /opt/flutter/bin/dart /usr/local/bin/dart \
 && flutter config --no-analytics \
 && flutter --version \
 && chown -R ubuntu:ubuntu /opt/flutter

# Run as the non-root user Cloud Agents use.
USER ubuntu
