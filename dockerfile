FROM fischerscode/flutter:stable as flutter

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get
COPY . .

# Uncomment if you're building a Flutter web app
# RUN flutter build web


# Set Dart entrypoint (adjust main.dart path if needed)
CMD ["dart", "lib/main.dart"]