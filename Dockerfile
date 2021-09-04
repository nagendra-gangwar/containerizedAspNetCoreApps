# This is a sample Dockerfile for building and running ASP.NET Core applications 
# This is part of the cheat sheet at https://blog.georgekosmidis.net/2020/06/12/docker-cheat-sheet-for-dotnet-core/

# Pull ASP.NET Core 3.1 runtime and give the name 'base'
# More info on 'FROM' instruction here: https://docs.docker.com/engine/reference/builder/#from
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base

# Set the ports where the container listens at runtime
# More on the 'EXPOSE' instruction here: https://docs.docker.com/engine/reference/builder/#workdir
EXPOSE 80
EXPOSE 443

# Pull the ASP.NET Core 3.1 SDK and give the name 'build'
# The SDK runs an app on ports 5000 and 5001, that's why we also need runtime
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build

# Set the Working Dir to '/src'. This is where the source code is 
# The WORKDIR instruction sets the working directory for any 
#   RUN, CMD, ENTRYPOINT, COPY and ADD instructions that follow
# More on the 'WORKDIR' instruction here: https://docs.docker.com/engine/reference/builder/#workdir
WORKDIR /src

# Copy your projects 
# More on the 'COPY' instruction here: https://docs.docker.com/engine/reference/builder/#copy
COPY ["Tailspin.SpaceGame.Web/Tailspin.SpaceGame.Web.csproj", "Tailspin.SpaceGame.Web/"]
COPY ["TailSpin.SpaceGame.Web.Models/TailSpin.SpaceGame.Web.Models.csproj", "TailSpin.SpaceGame.Web.Models/"]

# Run in a shell, in this case run 'dotnet restore'
# More the 'RUN' instruction here: https://docs.docker.com/engine/reference/builder/#run
RUN dotnet restore "Tailspin.SpaceGame.Web/Tailspin.SpaceGame.Web.csproj"

WORKDIR "/src/Tailspin.SpaceGame.Web"
COPY . .
RUN dotnet build "Tailspin.SpaceGame.Web.csproj" -c Release -o /app/build

# Run the publish command using the SDK named as 'build'
FROM build AS publish
RUN dotnet publish "Tailspin.SpaceGame.Web.csproj" -c Release -o /app/publish

# Pull 'base' image and name it as 'final' to allow pull access for publish
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
 
# Set the entry point, in other words, what to run!
# More on the 'ENTRYPOINT' instruction here https://docs.docker.com/engine/reference/builder/#entrypoint
ENTRYPOINT ["dotnet", "Tailspin.SpaceGame.Web.dll"]