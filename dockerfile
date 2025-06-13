# --------- Stage 1: Flutter build environment ---------
FROM fischerscode/flutter:stable as flutter

WORKDIR /build
COPY pubspec.* ./
RUN flutter pub get
COPY . .

# --------- Stage 2: Node.js runtime with Dart ---------
FROM node:18-alpine

# Install Dart manually (because alpine doesn't have Dart preinstalled)
RUN apk add --no-cache bash curl && \
    curl -o dart-sdk.zip https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip && \
    unzip dart-sdk.zip && \
    mv dart-sdk /usr/lib/dart && \
    ln -s /usr/lib/dart/bin/dart /usr/bin/dart && \
    rm dart-sdk.zip

WORKDIR /app

# Install Node dependencies
COPY js/package*.json ./js/
RUN cd js && npm install

# Copy app source
COPY js ./js
COPY lib ./lib
COPY pubspec.* ./

EXPOSE 3000

# Run both Dart and Node.js processes in parallel
CMD sh -c "dart lib/main.dart & node js/server.js"
