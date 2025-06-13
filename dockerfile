FROM fischerscode/flutter:stable as flutter

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get
COPY . .

# Uncomment if you're building a Flutter web app
# RUN flutter build web

#Final image with Flutter SDK
FROM fischerscode/flutter:stable

WORKDIR /app

# Copy built app from previous stage (useful for web; ignored otherwise)
COPY --from=build /app ./

# ✅ Install any OS dependencies (if needed)
RUN apt-get update && apt-get install -y curl unzip

# ✅ Install Dart dependencies (this works because Flutter SDK is present)
RUN flutter pub get

EXPOSE 8080

# Set Dart entrypoint (adjust main.dart path if needed)
CMD ["dart", "lib/main.dart"]