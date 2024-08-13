#!/bin/bash

# 156 145 162 144

# Function to print error messages in a beautiful format
print_error() {
    echo -e "\n\033[1;31mError:\033[0m $1\n"
}

# Check if necessary environment variables are set individually
missing_vars=()
[ -z "${SSH_URL}" ] && missing_vars+=("SSH_URL")
[ -z "${USER_NAME}" ] && missing_vars+=("USER_NAME")
[ -z "${PRIVATE_KEY}" ] && missing_vars+=("PRIVATE_KEY")
[ -z "${CERT_FILE_CONTENT}" ] && missing_vars+=("CERT_FILE_CONTENT")

# If any variables are missing, print error messages and exit
if [ ${#missing_vars[@]} -ne 0 ]; then
    for var in "${missing_vars[@]}"; do
        print_error "Please provide the environment variable: $var."
    done
    exit 1
fi

# Create the user if it doesn't exist
if ! id -u ${USER_NAME} >/dev/null 2>&1; then
    useradd -m ${USER_NAME}
    mkdir -p /home/${USER_NAME}
fi

# Ensure .ssh and .cloudflared directories exist and have the right permissions
mkdir -p /home/${USER_NAME}/.ssh
mkdir -p /home/${USER_NAME}/.cloudflared
chmod 700 /home/${USER_NAME}/.ssh
chmod 700 /home/${USER_NAME}/.cloudflared


# Copy the SSH key files from environment variables to the container
if [ -n "${PRIVATE_KEY}" ]; then
    echo "${PRIVATE_KEY}" > /home/${USER_NAME}/.ssh/id_rsa
    chmod 600 /home/${USER_NAME}/.ssh/id_rsa
fi

if [ -n "${CERT_FILE_CONTENT}" ]; then
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

chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/

# Switch to the created user and execute the SSH command
exec su - ${USER_NAME} -c "/usr/bin/ssh -l ${USER_NAME} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/home/${USER_NAME}/.ssh/known_hosts ${SSH_URL} \"$@\""  

# 68 101 101 122 78 117 116 115 
