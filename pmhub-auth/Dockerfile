FROM openjdk:8-jre-slim
COPY target/pmhub-auth.jar app.jar
EXPOSE 6800
ENTRYPOINT ["java", "-jar", "/app.jar"]
