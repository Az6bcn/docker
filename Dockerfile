# https://docs.microsoft.com/en-us/visualstudio/containers/container-build?view=vs-2019
# https://www.youtube.com/watch?v=f0lMGPB10bM

################################################## Development image to build ##########################################################
# Build SDK Image from 'mcr.microsoft.com/dotnet/core/sdk:3.1' has the sdk and msbuild to buld our application
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 

# add author
LABEL author: "az6bcn@gmail.com"

# add env variables we want to use/ have available in the container
ENV DOTNET_USE_POLLING_FILE_WATCHER=1
ENV ASPNETCORE_URLS=http://*:5000
ENV ASPNETCORE_ENVIRONMENT=Development

# create working directory in the container
WORKDIR /app

# restore and run the app in the container
CMD ["/bin/bash", "-c", "dotnet restore && dotnet watch run"]

# with this, we'll have to create a vlumne to link back to our source code in the host machine.