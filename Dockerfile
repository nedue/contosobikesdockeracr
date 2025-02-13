FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["DotNetCoreSqlDb.csproj", "./"]
RUN dotnet restore "DotNetCoreSqlDb.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DotNetCoreSqlDb.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotNetCoreSqlDb.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotNetCoreSqlDb.dll"]
