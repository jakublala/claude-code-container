# Claude Code Container

Docker container for running [Claude Code](https://docs.anthropic.com/en/docs/claude-code) on systems with older GLIBC.

> **Why this exists:** Many HPC clusters and older enterprise systems (CentOS 7, RHEL 7, older Ubuntu LTS) ship with outdated GLIBC versions that are incompatible with Claude Code's binary requirements. This container packages Claude Code in Ubuntu 24.04, providing a modern GLIBC while remaining portable via Apptainer/Singularity.

## Quick Start (Pre-built Image)

```bash
# On your cluster with Apptainer
apptainer pull docker://jakublala/claude-code-container:latest

# Run Claude Code in interactive shell (recommended)
apptainer shell --bind $HOME:$HOME claude-code-container_latest.sif
# Then inside the container:
claude
```

## Usage on Cluster

**Recommended: Use shell mode with home directory mounted**

```bash
# Interactive shell with your home directory mounted
apptainer shell --bind $HOME:$HOME claude-code-container_latest.sif

# Inside the container, run claude:
claude
```

This mounts your home directory so that:
- Your API key and configuration persist between sessions
- You can access your project files
- Claude can read/write files in your workspace

**Alternative: Direct execution**

```bash
apptainer exec --bind $HOME:$HOME claude-code-container_latest.sif claude
```

## Build Docker Image Locally

```bash
git clone https://github.com/jakublala/claude-code-container.git
cd claude-code-container
docker build -t claude-code-container .
```

## Convert to Apptainer/Singularity Image

### Option 1: Pull from Docker Hub (easiest)

```bash
apptainer pull docker://jakublala/claude-code-container:latest
```

### Option 2: Save as tarball and convert on cluster

```bash
# On local machine: save Docker image
docker save claude-code-container -o claude-code-container.tar

# Transfer to cluster
scp claude-code-container.tar user@cluster:/path/to/destination/

# On cluster: convert to .sif
apptainer build claude-code-container.sif docker-archive://claude-code-container.tar
```

### Option 3: Use local Docker daemon (if Apptainer is on same machine)

```bash
apptainer build claude-code-container.sif docker-daemon://claude-code-container:latest
```

## Notes

- The Claude Code binary is installed at `~/.local/bin/claude` inside the container
- You will need to authenticate Claude Code on first use
- Always bind your home directory (`--bind $HOME:$HOME`) to persist configuration and access your files
