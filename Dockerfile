# ---- Stage 1: Builder ----
FROM gradle:8-jdk21 AS builder
WORKDIR /home/gradle/project

COPY build.gradle ./
COPY gradle ./gradle
COPY src ./src

RUN gradle build --no-daemon

# ---- Stage 2: Production ----
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy final JAR from builder
COPY --from=builder /home/gradle/project/build/libs/*.jar app.jar

RUN useradd --create-home appuser
USER appuser

EXPOSE 4000

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
