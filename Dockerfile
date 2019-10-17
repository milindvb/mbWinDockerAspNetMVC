#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see http://aka.ms/containercompat 

FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /app
COPY . .
RUN nuget restore asmnetmvc2.sln
RUN MSBuild asmnetmvc2/asmnetmvc2.csproj /property:Configuration=Release /p:OutputPath=publish /p:WebPublishMethod="FileSystem"

FROM microsoft/aspnet:4.7.2-windowsservercore-1709 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/asmnetmvc2/publish/_PublishedWebsites/asmnetmvc2/. ./
EXPOSE 8080