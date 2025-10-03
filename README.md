# Claude Code Credentials Docker Setup

This project demonstrates how to build a Docker/Podman image with pre-configured Claude Code credentials, allowing you to run Claude Code in containers without needing to authenticate each time.

For full details, see: https://matcohle.me/coding-agents-for-paranoid/

## How It Works

The setup uses a two-stage build process:

1. **First stage**: Build a temporary container that runs Claude Code authentication
2. **Extract credentials**: Copy the generated credentials from the container, you will be asked to authorize via browser
3. **Final stage**: Build the production image with embedded credentials

## Usage

Run `setup.sh`.
