FROM tcxcontainers.azurecr.io/maven:3.6.1-jdk-8 AS build
COPY src /usr/src/app/src
COPY pom.xml /usr/src/app
RUN mvn -f /usr/src/app/pom.xml clean package

FROM tcxcontainers.azurecr.io/openjdk:8u212-jre-slim-stretch
RUN apt-get update -y && apt-get install -y \
    vim \
    dos2unix && apt-get clean

COPY --from=build /usr/src/app/target/ApplicationService-0.0.1-SNAPSHOT.jar /usr/app/applicationservice.jar
COPY invokeServices.sh /usr/start/

RUN dos2unix /usr/start/invokeServices.sh
RUN chmod +x /usr/start/invokeServices.sh

EXPOSE 80
ENTRYPOINT ["/usr/start/invokeServices.sh"]