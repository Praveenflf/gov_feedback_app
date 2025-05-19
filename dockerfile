#Dart image
FROM dart:stable

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code & compile it.
COPY . .

#Compile application
RUN dart compile exe binmain.dart -o bin/server

#Set the default command to run your Dart file
CMD ["dart", "lib/main.dart"]