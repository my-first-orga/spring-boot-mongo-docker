# Stage 1: Build the application
FROM maven:3.8.5-openjdk-8-slim AS build

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build the application
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create runtime image
FROM openjdk:8-alpine

ENV PROJECT_HOME=/opt/app
WORKDIR $PROJECT_HOME

# ✅ Copy the JAR using wildcard to support SNAPSHOT or version changes
COPY --from=build /app/target/*.jar $PROJECT_HOME/spring-boot-mongo.jar

EXPOSE 8080

# Run the Spring Boot app
CMD ["java", "-jar", "./spring-boot-mongo.jar"]
