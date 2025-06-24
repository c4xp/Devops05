FROM openjdk:17
WORKDIR /app
COPY HelloWorld.java .
RUN javac HelloWorld.java
EXPOSE 80
CMD ["java", "HelloWorld"]
