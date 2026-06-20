FROM openjdk:8-jre-slim
COPY target/pmhub-workflow.jar app.jar
EXPOSE 6808
ENTRYPOINT ["java", "-jar", "/app.jar"]
