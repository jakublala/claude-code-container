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

# Switch back to root to create system-wide symlink
USER root

# Create symlink in /usr/local/bin so claude is available system-wide
# This is needed for Apptainer which runs as the host user, not the container user
RUN ln -s /home/claude/.local/bin/claude /usr/local/bin/claude

# Switch back to claude user
USER claude

# Set default command
CMD ["claude"]
