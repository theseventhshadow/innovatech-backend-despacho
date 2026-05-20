# Multi-stage para Spring Boot
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn package -DskipTests

# Etapa final (imagen más pequeña)
FROM eclipse-temurin:17-jre-alpine

# Crear usuario no root (requisito del trabajo)
RUN addgroup -S spring && adduser -S spring -G spring

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

# Cambiar a usuario no root
USER spring:spring

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]