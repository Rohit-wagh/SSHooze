#!/bin/bash

# 156 145 162 144

# Check if necessary environment variables are set
if [ -z "${SSH_URL}" ]; then
    echo "Error: SSH_URL environment variable is not set."
    exit 1
fi

# Ensure .ssh directory exists
mkdir -p /home/${USER_NAME}/.ssh
chmod 700 /home/${USER_NAME}/.ssh

# Copy the SSH key files from environment variables to the container
if [ -n "${PRIVATE_KEY}" ]; then
    echo "${PRIVATE_KEY}" > /home/${USER_NAME}/.ssh/id_rsa
    chmod 600 /home/${USER_NAME}/.ssh/id_rsa
fi

if [ -n "${CERT_FILE_CONTENT}" ]; then
    mkdir -p /home/${USER_NAME}/.cloudflared
    echo "${CERT_FILE_CONTENT}" > /home/${USER_NAME}/.cloudflared/cert.pem
    chmod 600 /home/${USER_NAME}/.cloudflared/cert.pem
fi

# Add the SSH config
echo "Host ${SSH_URL}" > /home/${USER_NAME}/.ssh/config
echo "    ProxyCommand /usr/local/bin/cloudflared access ssh --hostname %h" >> /home/${USER_NAME}/.ssh/config
echo "    IdentityFile ~/.ssh/id_rsa" >> /home/${USER_NAME}/.ssh/config
chmod 600 /home/${USER_NAME}/.ssh/config

# Add the host key to known_hosts
ssh-keyscan -H ${SSH_URL} >> /home/${USER_NAME}/.ssh/known_hosts
chmod 600 /home/${USER_NAME}/.ssh/known_hosts

# Execute SSH command and keep the session open
exec /usr/bin/ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/home/${USER_NAME}/.ssh/known_hosts" "${SSH_URL}" "$@"

