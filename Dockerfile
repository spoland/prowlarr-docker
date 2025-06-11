FROM debian:latest

# Set environment variable for non-interactive apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Create a user and group
RUN useradd -m prowlarr

# Create the directory and set permissions
RUN mkdir -p /var/lib/prowlarr && \
    chown prowlarr:prowlarr /var/lib/prowlarr

# Update package lists and install necessary tools
# This separates the update from the install for better error isolation
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates

# Install required libraries and tools for Prowlarr and its download/extraction
RUN apt-get install -y --no-install-recommends \
    libicu-dev \
    curl \
    sqlite3 \
    wget \
    tar && \
    rm -rf /var/lib/apt/lists/*

# Download and extract Prowlarr, then move to /opt
RUN wget --content-disposition 'http://prowlarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64' && \
    tar -xvzf Prowlarr*.linux*.tar.gz && \
    mv Prowlarr /opt && \
    rm Prowlarr*.linux*.tar.gz && \
    chown prowlarr:prowlarr -R /opt/Prowlarr

# Switch to the prowlarr user for subsequent operations and security
USER prowlarr

# Set the working directory for Prowlarr
WORKDIR /opt/Prowlarr

# Define the entry point for the application
# Ensure 'Prowlarr' is the correct executable name
ENTRYPOINT ["/opt/Prowlarr/Prowlarr", "-nobrowser", "-data=/var/lib/prowlarr/"]

# Expose the default Prowlarr port (if you know it, otherwise remove or specify)
# Prowlarr typically runs on port 9696
EXPOSE 9696
