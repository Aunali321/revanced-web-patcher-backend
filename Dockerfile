FROM gradle:8.10.1-jdk17-alpine AS build
ARG GITHUB_ACTOR
ARG GITHUB_TOKEN
ENV GITHUB_ACTOR=${GITHUB_ACTOR}
ENV GITHUB_TOKEN=${GITHUB_TOKEN}
WORKDIR /app
COPY gradlew gradlew.bat settings.gradle.kts build.gradle.kts gradle.properties /app/
COPY gradle /app/gradle
COPY src /app/src
RUN ./gradlew installDist --no-daemon

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/build/install/web-patcher-service/ /app/
ENV PORT=3000
EXPOSE 3000
CMD ["./bin/web-patcher-service"]
