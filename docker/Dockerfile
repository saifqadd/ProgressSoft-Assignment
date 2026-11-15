# Build the sample WAR with the assignment's Java 8 / Tomcat 9 generation.
FROM maven:3.9.13-eclipse-temurin-8-noble AS build
WORKDIR /src
COPY pom.xml .
COPY src ./src
RUN mvn --batch-mode --no-transfer-progress package

FROM tomcat:9.0.124-jre8-temurin-noble
COPY --from=build /src/target/sample.war /usr/local/tomcat/webapps/sample.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
