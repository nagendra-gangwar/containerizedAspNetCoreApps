# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /source

# Set the ports where the container listens at runtime
# More on the 'EXPOSE' instruction here: https://docs.docker.com/engine/reference/builder/#workdir
EXPOSE 80
EXPOSE 443

# copy everything from code repository to source working directory.
COPY . .

WORKDIR /source/DockerDemoApp
RUN dotnet restore

# publish the release to /app folder
RUN dotnet publish -c release -o /app --no-restore

# prepare final image from previous buid and release files.
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "DockerDemoApp.dll"]