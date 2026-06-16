FROM dart:stable AS build

RUN dart pub global activate jaspr_cli

WORKDIR /app

COPY . .

WORKDIR /app/sidb

RUN rm -f pubspec_overrides.yaml
RUN dart pub get

RUN dart pub global run jaspr_cli:jaspr build --verbose

FROM nginx:alpine

COPY --from=build /app/sidb/build/jaspr/ /usr/share/nginx/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
