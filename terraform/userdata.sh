#!/bin/bash
# Exit immediately if a command exits with a non-zero status (Error Handling)
set -e

# 1. Update the system and install prerequisites
apt-get update -y
apt-get install -y ca-certificates curl gnupg git software-properties-common

# 2. Add Docker's official GPG key & repository
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo 
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu 
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | 
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# 3. Install Docker and Docker Compose
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 4. Clone the NetDevOps repository from GitHub
mkdir -p /opt/netdevops
cd /opt/netdevops
git clone ${github_repo_url} .

# 5. Start the full NetBox & Observability stack
docker compose up -d
