#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["HDS.Server/HDS.Server.csproj", "HDS.Server/"]
COPY ["HDS.Client/HDS.Client.csproj", "HDS.Client/"]
COPY ["HDS.Core/HDS.Core.csproj", "HDS.Core/"]
COPY ["HDS.Shared/HDS.Shared.csproj", "HDS.Shared/"]
RUN dotnet restore "HDS.Server/HDS.Server.csproj"
COPY . .
WORKDIR "/src/HDS.Server"
RUN dotnet build "HDS.Server.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "HDS.Server.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HDS.Server.dll"]