# Stage 1: Flutter build environment
FROM fischerscode/flutter:stable as flutter

WORKDIR /build
COPY pubspec.* ./
RUN flutter pub get
COPY . .

#Stage 2: Node.js + Dart 
FROM node:18-bullseye

# Install necessary tools
RUN apt-get update && apt-get install -y curl unzip xz-utils

# Dart SDK from archive → no signature errors
RUN curl -O https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip && \
    unzip dartsdk-linux-x64-release.zip -d /usr/lib/ && \
    ln -s /usr/lib/dart-sdk/bin/dart /usr/bin/dart && \
    rm dartsdk-linux-x64-release.zip

ENV PATH="/usr/lib/dart-sdk/bin:$PATH"

WORKDIR /app

# Node setup
COPY js ./js
WORKDIR /app/js
RUN npm install

WORKDIR /app
COPY lib ./lib
COPY pubspec.* ./

EXPOSE 3000
EXPOSE 8080

CMD ["sh", "-c", "dart lib/main.dart & node js/server.js"]
