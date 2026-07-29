# ====== Build Stage ======
FROM maven:3.8.6-jdk-8-slim AS builder

WORKDIR /build

COPY . .

RUN mvn clean package -DskipTests -pl tduck-api -am

# ====== Runtime Stage ======
FROM amazoncorretto:8-alpine3.19-jre

RUN apk add --no-cache ttf-dejavu fontconfig tzdata curl

ENV TZ=Asia/Shanghai

WORKDIR /application

COPY --from=builder /build/tduck-api/target/tduck-api.jar application.jar

EXPOSE 8999

CMD ["sh", "-c", "echo '=== TDuck Starting ===' && echo 'DB URL:' $SPRING_DATASOURCE_URL && exec java $JAVA_OPTS -Duser.language=zh -XX:+UseG1GC -Djava.security.egd=file:/dev/./urandom -jar application.jar --server.port=8999 --server.address=0.0.0.0 --springdoc.swagger-ui.enabled=true --springdoc.api-docs.enabled=true"]
