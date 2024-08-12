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
     docker build -t SSHooze .
     ```

   - **Pull from Docker Hub**

     ```bash
     docker pull SSHooze:latest
     ```

3. **Run the Docker Container**

   Replace placeholders with your actual values:

   ```bash
   docker run -it \
     -e SSH_URL=your_domain \
     -e USER_NAME=user \
     -e PRIVATE_KEY="$(cat id_rsa)" \
     -e CERT_FILE_CONTENT="$(cat cert.pem)" \
     SSHooze
   ```

## 📜 Customization

- **USER_NAME**: Default is `user`. Change it to your preferred username.
- **SSH_URL**: Replace `your_domain` with your Cloudflare tunnel domain.
- **PRIVATE_KEY**: Your SSH private key content.
- **CERT_FILE_CONTENT**: Content of your Cloudflare `cert.pem`.

## 🧩 How It Works

1. **Setup**: SSHooze configures the SSH environment with necessary directories and permissions.
2. **Configuration**: Adds SSH config, handles known hosts, and prepares for secure connections.
3. **Execution**: Initiates the SSH connection and keeps it open for your custom tasks.

## 🤔 Troubleshooting

- **Environment Variables**: Ensure `SSH_URL`, `USER_NAME`, `PRIVATE_KEY`, and `CERT_FILE_CONTENT` are correctly set.
- **Connection Issues**: Verify your SSH URL and Cloudflare setup.

## 💡 Contribution

We welcome contributions to SSHooze! If you have ideas to improve the project or want to add new features, here’s how you can get involved:

1. **Fork the Repository**: Create your own fork of the SSHooze repository.
2. **Make Changes**: Implement your improvements or features.
3. **Submit a Pull Request**: Open a pull request with a clear description of your changes.

Feel free to open issues if you encounter bugs or have suggestions. We appreciate your input and look forward to your contributions!

## 🚀 Enjoy Using SSHooze!

SSHooze provides a flexible base for your SSH needs. Build on it and make it work for your specific use case. Happy automating! 🎉
