FROM fischerscode/flutter:stable as flutter

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get
COPY . .

# Uncomment if you're building a Flutter web app
# RUN flutter build web

#Dart Runtime Image
FROM debian:bullseye-slim

# Install Dart SDK
RUN apt-get update && apt-get install -y curl unzip xz-utils && \
    curl -O https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip && \
    unzip dartsdk-linux-x64-release.zip -d /usr/lib/ && \
    ln -s /usr/lib/dart-sdk/bin/dart /usr/bin/dart && \
    rm dartsdk-linux-x64-release.zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/lib/dart-sdk/bin:$PATH"

WORKDIR /app

# Copy Dart source code
COPY lib ./lib
COPY pubspec.* ./

# RUN flutter pub get

EXPOSE 8080

# Set Dart entrypoint (adjust main.dart path if needed)
CMD ["dart", "lib/main.dart"]