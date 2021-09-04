# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /source

# copy everything from code repository to source working directory.
COPY . .

WORKDIR /source/Tailspin.SpaceGame.Web
RUN dotnet restore

# publish the release to /app folder
RUN dotnet publish -c release -o /app --no-restore

# prepare final image from previous buid and release files.
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "Tailspin.SpaceGame.Web.dll"]