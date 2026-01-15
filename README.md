# Claude Code Container

Docker container for running [Claude Code](https://docs.anthropic.com/en/docs/claude-code) on systems with older GLIBC.

> **Why this exists:** Many HPC clusters and older enterprise systems (CentOS 7, RHEL 7, older Ubuntu LTS) ship with outdated GLIBC versions that are incompatible with Claude Code's binary requirements. This container packages Claude Code in Ubuntu 24.04, providing a modern GLIBC while remaining portable via Apptainer/Singularity.

## Quick Start (Pre-built Image)

The easiest way is to pull the pre-built image directly:

```bash
# On your cluster with Apptainer
apptainer pull docker://jakublala/claude-code-container:latest

# Run Claude Code
apptainer exec claude-code-container_latest.sif claude
```

## Build Docker Image Locally

```bash
git clone https://github.com/jakublala/claude-code-container.git
cd claude-code-container
docker build -t claude-code-container .
```

## Convert to Apptainer/Singularity Image

### Option 1: Save as tarball and convert on cluster

```bash
# On local machine: save Docker image
docker save claude-code-container -o claude-code-container.tar

# Transfer to cluster
scp claude-code-container.tar user@cluster:/path/to/destination/

# On cluster: convert to .sif
apptainer build claude-code-container.sif docker-archive://claude-code-container.tar
```

### Option 2: Pull from Docker Hub with Apptainer

```bash
# On cluster: pull and convert directly
apptainer pull docker://jakublala/claude-code-container:latest
```

### Option 3: Use local Docker daemon (if Apptainer is on same machine)

```bash
apptainer build claude-code-container.sif docker-daemon://claude-code-container:latest
```

## Usage on Cluster

```bash
# Interactive shell
apptainer shell claude-code-container.sif

# Run claude directly
apptainer exec claude-code-container.sif claude

# Run with home directory bound (for API key persistence)
apptainer exec --bind $HOME:/home/claude claude-code-container.sif claude
```

## Notes

- The Claude Code binary is installed at `/home/claude/.claude/local/bin/claude`
- You may need to authenticate Claude Code on first use
- Consider binding your home directory to persist configuration
