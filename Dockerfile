FROM mcr.microsoft.com/dotnet/core/sdk:3.1 

LABEL author: "az6bcn@gmail.com"

ENV DOTNET_USE_POLLING_FILE_WATCHER=1
ENV ASPNETCORE_URLS=http://*:5000
ENV ASPNETCORE_ENVIRONMENT=Development

WORKDIR /app

# restore and run
CMD ["/bin/bash", "-c", "dotnet restore && dotnet watch run"]