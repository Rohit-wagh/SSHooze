# Minimal Alpine base image
FROM alpine:latest

# Set environment variables
ENV CLOUD_FLARE_BIN=/usr/local/bin/cloudflared

# Install necessary packages and download cloudflared
RUN apk add --no-cache \
        bash \
        openssh-client \
        wget \
        ca-certificates \
        shadow \
    && wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O ${CLOUD_FLARE_BIN} \
    && chmod +x ${CLOUD_FLARE_BIN}

# Copy the entrypoint script and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

