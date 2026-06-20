FROM openjdk:8-jre-slim
COPY target/pmhub-job.jar app.jar
EXPOSE 6803
ENTRYPOINT ["java", "-jar", "/app.jar"]
