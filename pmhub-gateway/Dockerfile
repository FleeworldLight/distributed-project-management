FROM openjdk:8-jre-slim
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
COPY target/pmhub-gateway.jar app.jar
EXPOSE 6880
ENTRYPOINT ["java", "-jar", "/app.jar"]
