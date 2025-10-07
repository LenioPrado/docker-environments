# Etapa única para desenvolvimento (com hot reload)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS dev

# Define diretório de trabalho
WORKDIR /app

ARG LAUNCH_PROFILE
ARG PROJECT_NAME
ARG PROJECT_PORT

# Copia apenas arquivos de projeto para restaurar dependências
COPY API/${PROJECT_NAME}/${PROJECT_NAME}.csproj ./API/${PROJECT_NAME}/
COPY Library ./Library/

# Restaura dependências (sem build ainda)
RUN dotnet restore API/${PROJECT_NAME}/${PROJECT_NAME}.csproj

# Expõe a porta usada pela API
EXPOSE 5000

# Define variável de ambiente para o modo dev
ENV DOTNET_USE_POLLING_FILE_WATCHER=true

WORKDIR /app/API/${PROJECT_NAME}