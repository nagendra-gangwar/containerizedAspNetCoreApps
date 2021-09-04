# use asp.net runtime and create base layer.
FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
EXPOSE 80
EXPOSE 443
WORKDIR /app

# use sdk as build
FROM microsoft/dotnet:2.1-sdk AS build
#change working directory
WORKDIR /src

# copy all files from source code to src folder
COPY . .

#restore project
RUN dotnet restore "Tailspin.SpaceGame.Web/Tailspin.SpaceGame.Web.csproj"

# change working directory.
WORKDIR "/src/Tailspin.SpaceGame.Web"

#build
RUN dotnet build "Tailspin.SpaceGame.Web.csproj" -c Release -o /app

#publish binaries
FROM build AS publish

RUN dotnet publish "Tailspin.SpaceGame.Web.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Tailspin.SpaceGame.Web.dll"]