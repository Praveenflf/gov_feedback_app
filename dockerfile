# --------- Stage 1: Flutter build environment ---------
FROM fischerscode/flutter:stable as flutter

WORKDIR /build
COPY pubspec.* ./
RUN flutter pub get
COPY . .

# --------- Stage 2: Node.js runtime with Dart ---------
FROM node:18-alpine

# Install Dart SDK
RUN apk add --no-cache bash curl unzip && \
    curl -o dart-sdk.zip https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip && \
    unzip dart-sdk.zip && \
    mv dart-sdk /usr/lib/dart && \
    ln -s /usr/lib/dart/bin/dart /usr/bin/dart && \
    rm dart-sdk.zip

WORKDIR /app

# ✅ Fix: Copy the entire js folder *before* installing
COPY js ./js

# ✅ Install dependencies inside js folder
WORKDIR /app/js
RUN npm install

# ✅ Go back to /app for rest of code
WORKDIR /app

# Copy Flutter app code & pubspec
COPY lib ./lib
COPY pubspec.* ./

EXPOSE 3000
EXPOSE 8080

# ✅ JSON format for CMD recommended
CMD ["sh", "-c", "dart lib/main.dart & node js/server.js"]
