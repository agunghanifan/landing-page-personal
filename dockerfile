# Build stage
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore as separate layer (for caching)
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the source
COPY . ./

# Publish to /app/publish
RUN dotnet publish -c Release -o /app/publish

# Runtime stage
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Copy published app from build stage
COPY --from=build /app/publish .

ENV \
    # Configure web servers to bind to port 80 when present
    ASPNETCORE_URLS=http://+:80 \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true

# Expose HTTP port
EXPOSE 80

# Replace 'PersonalBlog.dll' with your actual DLL name
ENTRYPOINT ["dotnet", "LandingPagePersonal.dll"]