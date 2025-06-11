#Dart image
FROM fischerscode/flutter:stable as build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get



# Copy app source code & compile it.
COPY . .

#Compile application
# RUN flutter build web

#Set the default command to run your Dart file
# CMD ["dart", "lib/main.dart"]

RUN npm install
CMD ["node", "server.js"]