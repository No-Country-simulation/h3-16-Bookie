
FROM eclipse-temurin:17-jdk as build

WORKDIR /app
COPY . /app


RUN chmod +x mvnw


RUN ./mvnw package -DskipTests


RUN mv target/*.jar app.jar


FROM eclipse-temurin:17-jre


ARG PORT=8080
ENV PORT=${PORT}

WORKDIR /app

COPY --from=build /app/app.jar .


RUN useradd -m runtime
USER runtime


EXPOSE ${PORT}


ENTRYPOINT ["java", "-Dserver.port=${PORT}", "-jar", "app.jar"]
