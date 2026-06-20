FROM openjdk:8-jre-slim
COPY target/pmhub-system.jar app.jar
EXPOSE 6801
ENTRYPOINT ["java", "-jar", "/app.jar"]
