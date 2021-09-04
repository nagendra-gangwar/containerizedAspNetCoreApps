# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY Tailspin.SpaceGame.Web/*.csproj ./Tailspin.SpaceGame.Web/
RUN dotnet restore

# copy everything else and build app
COPY Tailspin.SpaceGame.Web/. ./Tailspin.SpaceGame.Web/
WORKDIR /source/Tailspin.SpaceGame.Web
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "Tailspin.SpaceGame.Web.dll"]