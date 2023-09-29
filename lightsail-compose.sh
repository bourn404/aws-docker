#!/bin/bash

# Install the latest version of Docker the lazy way
curl -sSL https://get.docker.com | sh

# Make it so you don't need to sudo to run Docker commands
usermod -aG docker ubuntu

# Install Docker Compose (get the latest release version dynamically)
LATEST_COMPOSE_VERSION=$(curl -sL https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
curl -L "https://github.com/docker/compose/releases/download/$LATEST_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Copy the Docker Compose configuration file into /srv/docker 
mkdir -p /srv/docker
curl -o /srv/docker/docker-compose.yml https://raw.githubusercontent.com/bourn404/aws-docker/master/docker-compose.yml

# Copy in systemd unit file and register it so our Compose file runs 
# on system restart
curl -o /etc/systemd/system/docker-compose-app.service https://raw.githubusercontent.com/bourn404/aws-docker/master/docker-compose-app.service
systemctl enable docker-compose-app

# Start up the application via Docker Compose
docker-compose -f /srv/docker/docker-compose.yml up -d
