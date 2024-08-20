#!/bin/bash

# 156 145 162 144

# Function to print error messages in a beautiful format
print_error() {
  echo -e "\n\033[1;31mError:\033[0m $1\n"
}

# Print SSHooze banner
print_banner() {
  echo -e "\n\033[1;31m━━━━━━━━━━━━━━━━━━━\033[0m\033[1;34m━━━━━━━━━━━━━━━━━━━\033[0m\033[1;32m━━━━━━━━━━━━━━━━━━━\033[0m"
  echo -e "\n\033[1;32m"
  echo "   _____    _____   _    _                              "
  echo "  / ____|  / ____| | |  | |                             "
  echo " | (___   | (___   | |__| |   ___     ___    ____   ___ "
  echo "  \___ \   \___ \  |  __  |  / _ \   / _ \  |_  /  / _ \\"
  echo "  ____) |  ____) | | |  | | | (_) | | (_) |  / /  |  __/ "
  echo " |_____/  |_____/  |_|  |_|  \___/   \___/  /___|  \___|"
  echo -e "\033[0m"
  echo -e "\n\033[1;31m━━━━━━━━━━━━━━━━━━━\033[0m\033[1;34m━━━━━━━━━━━━━━━━━━━\033[0m\033[1;32m━━━━━━━━━━━━━━━━━━━\033[0m"
}

# Print the banner
print_banner

# Check if necessary environment variables are set
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
mkdir -p /home/${USER_NAME}/.ssh /home/${USER_NAME}/.cloudflared
chmod 700 /home/${USER_NAME}/.ssh /home/${USER_NAME}/.cloudflared

# Copy the SSH key files from environment variables to the container
if [ -n "${PRIVATE_KEY}" ]; then
  echo "${PRIVATE_KEY}" > /home/${USER_NAME}/.ssh/id_rsa
  chmod 600 /home/${USER_NAME}/.ssh/id_rsa
else
  print_error "Private key is missing."
  exit 1
fi

if [ -n "${CERT_FILE_CONTENT}" ]; then
  echo "${CERT_FILE_CONTENT}" > /home/${USER_NAME}/.cloudflared/cert.pem
  chmod 600 /home/${USER_NAME}/.cloudflared/cert.pem
else
  print_error "Cloudflare certificate content is missing."
  exit 1
fi

# Add the SSH config
echo "Host ${SSH_URL}" > /home/${USER_NAME}/.ssh/config
echo "    ProxyCommand /usr/local/bin/cloudflared access ssh --hostname %h" >> /home/${USER_NAME}/.ssh/config
echo "    IdentityFile ~/.ssh/id_rsa" >> /home/${USER_NAME}/.ssh/config
chmod 600 /home/${USER_NAME}/.ssh/config

# Add the host key to known_hosts using ssh-keyscan
ssh-keyscan -H ${SSH_URL} >> /home/${USER_NAME}/.ssh/known_hosts
chmod 600 /home/${USER_NAME}/.ssh/known_hosts

# Set ownership and permissions for the user's home directory
chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/

# Handle script content if provided via environment variable
if [ -n "${SCRIPT_CONTENT}" ]; then
  # Check if SCRIPT_CONTENT is empty
  if [ -z "${SCRIPT_CONTENT// }" ]; then
    print_error "SCRIPT_CONTENT is provided but empty. Please provide valid script content."
    exit 1
  fi

  echo "${SCRIPT_CONTENT}" > /home/${USER_NAME}/remote_script.sh
  chmod +x /home/${USER_NAME}/remote_script.sh

  # Upload and execute the script
  exec su - ${USER_NAME} -c "scp -o StrictHostKeyChecking=no /home/${USER_NAME}/remote_script.sh ${USER_NAME}@${SSH_URL}:~/remote_script.sh && ssh -o StrictHostKeyChecking=no -l ${USER_NAME} -o UserKnownHostsFile=/home/${USER_NAME}/.ssh/known_hosts ${SSH_URL} 'bash ~/remote_script.sh && rm ~/remote_script.sh'"
else
  # If no script is provided, ensure a command is provided
  if [ $# -eq 0 ]; then
    print_error "No script content or command provided. Please provide a script or command to execute."
    exit 1
  fi

  # Execute the command directly on the remote server
  exec su - ${USER_NAME} -c "/usr/bin/ssh -o StrictHostKeyChecking=no -l ${USER_NAME} -o UserKnownHostsFile=/home/${USER_NAME}/.ssh/known_hosts ${SSH_URL} $@"
fi

# 68 101 101 122 78 117 116 115 
