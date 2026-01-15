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

# Switch back to root to fix permissions and create symlink
USER root

# Make claude's home directory and the binary accessible to all users
# This is needed for Apptainer which runs as the host user, not the container user
RUN chmod 755 /home/claude && \
    chmod -R 755 /home/claude/.local && \
    ln -s /home/claude/.local/bin/claude /usr/local/bin/claude

# Set default command
CMD ["claude"]
