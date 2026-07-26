# ====== Build Stage ======
FROM maven:3.8.6-jdk-8-slim AS builder

WORKDIR /build

COPY pom.xml .
COPY tduck-common/pom.xml ./tduck-common/pom.xml
COPY tduck-storage/pom.xml ./tduck-storage/pom.xml
COPY tduck-account/pom.xml ./tduck-account/pom.xml
COPY tduck-form/pom.xml ./tduck-form/pom.xml
COPY tduck-webhook/pom.xml ./tduck-webhook/pom.xml
COPY tduck-wx-mp/pom.xml ./tduck-wx-mp/pom.xml
COPY tduck-ai/pom.xml ./tduck-ai/pom.xml
COPY tduck-api/pom.xml ./tduck-api/pom.xml

RUN mvn dependency:go-offline -B

COPY tduck-common/src ./tduck-common/src
COPY tduck-storage/src ./tduck-storage/src
COPY tduck-account/src ./tduck-account/src
COPY tduck-form/src ./tduck-form/src
COPY tduck-webhook/src ./tduck-webhook/src
COPY tduck-wx-mp/src ./tduck-wx-mp/src
COPY tduck-ai/src ./tduck-ai/src
COPY tduck-api/src ./tduck-api/src

RUN mvn clean package -DskipTests -pl tduck-api -am

# ====== Runtime Stage ======
FROM openjdk:8-jdk-alpine

RUN apk add --no-cache ttf-dejavu fontconfig tzdata

ENV TZ=Asia/Shanghai

WORKDIR /application

COPY --from=builder /build/tduck-api/target/tduck-api.jar application.jar

EXPOSE 8999

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -Duser.language=zh -XX:+UseG1GC -Djava.security.egd=file:/dev/./urandom -jar application.jar --server.port=${PORT:-8999}"]
