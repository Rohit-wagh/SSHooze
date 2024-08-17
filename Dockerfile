# Minimal Ubuntu base image
FROM ubuntu:20.04

# Set environment variables
ENV CLOUD_FLARE_BIN=/usr/local/bin/cloudflared

# Install necessary packages and clean up
RUN apt-get update && \
    apt-get install -y \
        bash \
        openssh-client \
        wget \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install cloudflared
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O ${CLOUD_FLARE_BIN} && \
    chmod +x ${CLOUD_FLARE_BIN}

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"] 
