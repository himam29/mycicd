FROM adoptopenjdk/openjdk11:alpine-jre
ADD target/spring-boot-web.jar myapp.jar
EXPOSE 80
ENTRYPOINT ["java", "-jar", "myapp.jar"]
