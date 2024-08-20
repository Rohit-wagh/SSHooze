
# SSHooze: Your SSH Base Image! 🚀

Welcome to **SSHooze**, the versatile Docker image designed to facilitate SSH connections through Cloudflare tunnels. Whether you’re automating tasks, managing infrastructure, or integrating with CI/CD pipelines, SSHooze is here to provide a solid foundation. 🛠️

## 🛠️ What SSHooze Does

SSHooze is a base image that:
- Provides a secure SSH environment through Cloudflare tunnels
- Serves as a starting point for running your own scripts, automation, or any tasks you need

## 🚀 Quick Start

1. **Prepare Your Keys and Certificate**

   Before using SSHooze, ensure you have:
   - **SSH Key**: Your private key (added to `authorized_keys` on the remote server).
   - **Cloudflare Certificate**: Install `cloudflared` locally and run `cloudflared login` to obtain `cert.pem` in your home directory.

2. **Build or Pull the Docker Image**

   You can either build the image locally or pull it from Docker Hub:

   - **Build Locally**

     ```bash
     docker build -t sshooze .
     ```

   - **Pull from Docker Hub**

     ```bash
     docker pull rohitw123/sshooze:latest
     ```

3. **Run the Docker Container**

   Replace placeholders with your actual values:

   ```bash
   docker run \
     -e SSH_URL=your_domain \
     -e USER_NAME=user \
     -e PRIVATE_KEY="$(cat id_rsa)" \
     -e CERT_FILE_CONTENT="$(cat cert.pem)" \
     -e SCRIPT_CONTENT="$(cat your_script.sh)" \
     rohitw123/sshooze:latest "your command or script"
   ```
   
   Example to execute a script:

   ```bash
   docker run \
     -e SSH_URL=SSHizzleMyFizzle.com \
     -e USER_NAME=BlackWidowWit \
     -e PRIVATE_KEY="$(cat id_rsa)" \
     -e CERT_FILE_CONTENT="$(cat cert.pem)" \
     -e SCRIPT_CONTENT="$(cat a.sh)" \
     SSHooze
   ```

   Example to execute a single command:

   ```bash
   docker run \
     -e SSH_URL=SSHizzleMyFizzle.com \
     -e USER_NAME=BlackWidowWit \
     -e PRIVATE_KEY="$(cat id_rsa)" \
     -e CERT_FILE_CONTENT="$(cat cert.pem)" \
     SSHooze "echo Cheen_Tapak_DamDam!"
   ```

## 📜 Customization

- **USER_NAME**: Default is `user`. Change it to your preferred username.
- **SSH_URL**: Replace `your_domain` with your Cloudflare tunnel domain.
- **PRIVATE_KEY**: Your SSH private key content.
- **CERT_FILE_CONTENT**: Content of your Cloudflare `cert.pem`.
- **SCRIPT_CONTENT**: Optional. Provide the content of the script you want to run on the remote server. If not provided, a command must be specified.

## 🧩 How It Works

1. **Setup**: SSHooze configures the SSH environment with necessary directories and permissions.
2. **Configuration**: Adds SSH config, handles known hosts, and prepares for secure connections.
3. **Execution**: 
   - If `SCRIPT_CONTENT` is provided, it will be uploaded to the remote server, executed, and then removed.
   - If `SCRIPT_CONTENT` is not provided, the container expects a command to be executed directly on the remote server.

## 🤔 Troubleshooting

- **Environment Variables**: Ensure `SSH_URL`, `USER_NAME`, `PRIVATE_KEY`, and `CERT_FILE_CONTENT` are correctly set. If `SCRIPT_CONTENT` is provided, ensure it is not empty.
- **Connection Issues**: Verify your SSH URL and Cloudflare setup.
- **File Permissions**: Ensure the permissions of `.ssh` directory and files are correct.

## 💡 Contribution

We welcome contributions to SSHooze! If you have ideas to improve the project or want to add new features, here’s how you can get involved:

1. **Fork the Repository**: Create your own fork of the SSHooze repository.
2. **Make Changes**: Implement your improvements or features.
3. **Submit a Pull Request**: Open a pull request with a clear description of your changes.

Feel free to open issues if you encounter bugs or have suggestions. We appreciate your input and look forward to your contributions!

## 🚀 Enjoy Using SSHooze!

SSHooze provides a flexible base for your SSH needs. Build on it and make it work for your specific use case. Happy automating! 🎉

