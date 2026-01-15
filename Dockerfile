FROM ubuntu:24.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for Claude Code installation
RUN useradd -m -s /bin/bash claude
USER claude
WORKDIR /home/claude

# Install Claude Code
RUN curl -fsSL https://claude.ai/install.sh | bash

# Add Claude to PATH (both ENV for Docker and .bashrc for Apptainer shell)
ENV PATH="/home/claude/.local/bin:${PATH}"
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> /home/claude/.bashrc

# Set default command
CMD ["claude"]
