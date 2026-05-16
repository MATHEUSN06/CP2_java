# Estágio 1: Build
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Estágio 2: Execução
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Criar usuário não-root (Requisito 03)
RUN useradd -m matheus
COPY --from=build /app/target/*.jar app.jar

# Variável de ambiente (Requisito 03)
ENV SPRING_PROFILES_ACTIVE=prod

# Permissões para o usuário comum
RUN chown -R matheus:matheus /app
USER matheus

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]