FROM openjdk:8-jre-slim
COPY target/pmhub-project.jar app.jar
EXPOSE 6806
ENTRYPOINT ["java", "-jar", "/app.jar"]
