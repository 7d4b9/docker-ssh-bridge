# SSH Bridge

SSH Bridge£ project provides a bridge over SSH using Docker containers. It includes two components: the SSH client and the SSH server.

![IMG_1506](https://github.com/user-attachments/assets/955cdc8e-9631-46a0-b26b-2dacf269337d)

## Prerequisites

- Docker
- Docker Compose
- Make Utility

## Usage

We use `make` commands for various operations in this project. Below is a brief description of each command.

1. **Building the Docker image:**

```bash
make build
```
This command is used to build the Docker image.

2. **Pushing the Docker image:**

```bash
make push
```
This command pushes the built Docker image to the specified repository.

3. **Pulling the Docker image:**

```bash
make pull
```
This command pulls the image from the specified repository.

4. **Generating SSH Keys:**

```bash
make generate-ssh-keys
```
This command generates new SSH keys.

5. **Launching the SSH Server:**

```bash
make server
```
This command starts the SSH server.

6. **Launching the SSH Client:**

```bash
make client
```
This command starts the SSH client.

7. **Cleaning up:**

```bash
make clean
```
This command deletes the generated SSH keys.

Use these commands as per your requirements.

**Note:**
The `REPOSITORY` variable can be set to your Docker Hub username or any other registry where you wish to push your images. If not specified, it defaults to `dbndev`.

```bash
make push REPOSITORY=your_dockerhub_username
```

Please ensure that you have proper permissions set for your SSH files/directory.

Enjoy using SSH Bridge!