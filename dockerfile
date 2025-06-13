# --------- Stage 1: Flutter build environment ---------
FROM fischerscode/flutter:stable as flutter

WORKDIR /build
COPY pubspec.* ./
RUN flutter pub get
COPY . .

# --------- Stage 2: Node.js + Dart runtime (Debian-based, stable) ---------
FROM node:18-bullseye

# ✅ Install Dart SDK (official Debian package, better than zip in Alpine)
RUN apt-get update && \
    apt-get install -y apt-transport-https curl gnupg unzip && \
    curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor | tee /usr/share/keyrings/dart-archive.gpg > /dev/null && \
    curl -fsSL https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list | tee /etc/apt/sources.list.d/dart_stable.list && \
    apt-get update && apt-get install -y dart && \
    apt-get clean

ENV PATH="/usr/lib/dart/bin:$PATH"

WORKDIR /app

#Copy the entire js folder *before* installing
COPY js ./js

#Install dependencies inside js folder
WORKDIR /app/js
RUN npm install

# Go back to /app for rest of code
WORKDIR /app

# Copy Flutter app code & pubspec
COPY lib ./lib
COPY pubspec.* ./

EXPOSE 3000
EXPOSE 8080

# JSON format for CMD recommended
CMD ["sh", "-c", "dart lib/main.dart & node js/server.js"]
