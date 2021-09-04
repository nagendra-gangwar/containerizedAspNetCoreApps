
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /source

# copy everything from code repository to source working directory.
COPY ["DockerDemoApp.csproj", "."]
RUN dotnet restore "DockerDemoApp.csproj"

COPY . .
WORKDIR "/source"
RUN dotnet build "DockerDemoApp.csproj" -c Release -o /app/build


FROM build AS publish
RUN dotnet publish "DockerDemoApp.csproj" -c Release -o /app/publish

# prepare final image from previous buid and release files.
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerDemoApp.dll"]