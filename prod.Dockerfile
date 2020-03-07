
# https://docs.microsoft.com/en-us/visualstudio/containers/container-build?view=vs-2019
# https://www.youtube.com/watch?v=f0lMGPB10bM

################################################## Base Production Image ##########################################################
# Base Image for final production image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 5000

################################################## Development image to build ##########################################################
# Build SDK Image from 'mcr.microsoft.com/dotnet/core/sdk:3.1' has the sdk and msbuild to buld our application
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
# create a directory in the container
WORKDIR /src
# copy project (csproj) file to the /src directory in the container that will be created
COPY ["mvcDocker.csproj", "./"]
# restore any dependencies in the project in the /src directory in the container via NUGET
RUN dotnet restore "./mvcDocker.csproj"
# copy the rest of project files from Host current directory into the docker image that we are building
COPY . .
WORKDIR "/src/."
# build the copied project in relese mode, to /app/build
RUN dotnet build "mvcDocker.csproj" -c Release -o /app/build

################################################## Publish image to publish ##########################################################
FROM build AS publish
# publish the project in relese mode, to /app/publish (compiled project)
RUN dotnet publish "mvcDocker.csproj" -c Release -o /app/publish

################################################## Final Production Runtime Image ##########################################################
FROM base AS final
WORKDIR /app
# copy from the publish image, in its app/publish directory to the current directory .
COPY --from=publish /app/publish .
# set environment variables for the final production image
ENV ASPNETCORE_URLS=http://*:5000
ENV ASPNETCORE_ENVIRONMENT=Production
# execute the dll (the compiled dll when we published) when the contianer starts
ENTRYPOINT ["dotnet", "mvcDocker.dll"]
