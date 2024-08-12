# Stage 1: Create the entrypoint script
FROM alpine:latest AS script-builder
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Stage 2: Build the main image
FROM golang:alpine3.20

# Define build arguments with default values
ARG USER_NAME=BlackWidowWit
ARG USER_ID=1000
ARG CLOUD_FLARE_REPO=https://github.com/cloudflare/cloudflared.git
ARG CLOUD_FLARE_BIN=/usr/local/bin/cloudflared
ARG SSH_URL=SSHizzleMyFizzle.com

# Create the user
RUN adduser -D -u ${USER_ID} ${USER_NAME}

# Install necessary packages
RUN apk update && apk upgrade && \
    apk add --no-cache make bash git openssh cmake alpine-sdk

# Clone and build cloudflared
RUN git clone ${CLOUD_FLARE_REPO} /home/${USER_NAME}/cloudflared && \
    cd /home/${USER_NAME}/cloudflared && \
    go build -o ${CLOUD_FLARE_BIN} ./cmd/cloudflared

# Set the user and home directory
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

# Create necessary directories
RUN mkdir -p /home/${USER_NAME}/.ssh /home/${USER_NAME}/.cloudflared

# Copy the entrypoint script
COPY --from=script-builder /entrypoint.sh /entrypoint.sh

# Set environment variables (default values can be overridden at runtime)
ENV SSH_URL=${SSH_URL}
ENV USER_NAME=${USER_NAME}
ENV SSH_CONFIG_FILE=config
ENV PRIVATE_KEY_FILE=id_rsa
ENV CERT_FILE=cert.pem

ENTRYPOINT ["/entrypoint.sh"]

