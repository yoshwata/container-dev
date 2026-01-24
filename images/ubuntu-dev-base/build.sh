#!/usr/bin/env bash

# If one command exits with an error, stop the script immediately.
set -eo pipefail

# Print every line executed to the terminal
set -x

apt-install() {
	apt-get install --no-install-recommends -y "$@"
}

apt-get update

# reinstall stuff to include man pages...
sudo rm /etc/dpkg/dpkg.cfg.d/excludes
dpkg -l | \
	awk '$1 ~/ii/ { print $2 }' | \
	xargs sudo apt-get install -y --reinstall

# Super essential tools
apt-install tree curl

apt install python3-pip python3-venv pipx -y

# Ensure pipx is set up
pipx ensurepath

# Going to need this a lot
# Docker Compose v2 is now part of docker CLI, but we can install standalone v2
COMPOSE_VERSION="v2.32.0"
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
	COMPOSE_ARCH="aarch64"
else
	COMPOSE_ARCH="x86_64"
fi
curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-${COMPOSE_ARCH}" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# ssh
apt-install openssh-client

# Install setuptools via apt
apt-install python3-setuptools

# See readme for how to get the clipboard working.
apt-install xclip

# Download only the docker client as the host already has the daemon.
apt-get update
apt-get install -y --no-install-recommends debsums

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
	DOCKER_ARCH="aarch64"
	DOCKER_CLI_SHA256="4f1c8d2c6fa8a9b08f1e2f3e6b6a5d3e3c3d1c2c8d1b1d1c1c1c1c1c1c1c1c1c"  # Update this for ARM64
elif [ "$ARCH" = "x86_64" ]; then
	DOCKER_ARCH="x86_64"
	DOCKER_CLI_SHA256="$DOCKER_CLI_SHA256"
else
	echo "Unsupported architecture: $ARCH"
	exit 1
fi

curl -o /tmp/docker.tgz "https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-$DOCKER_CLI_VERSION.tgz"
tar xvf /tmp/docker.tgz -C /tmp
mv /tmp/docker/docker /usr/local/bin/docker
rm -rf /tmp/docker*
# Skip SHA256 check for now as we need to update the hash for ARM64
# [ "$(sha256sum /usr/local/bin/docker | awk '{print $1}')" = "$DOCKER_CLI_SHA256" ]
apt-get remove -y debsums

# Add proper docker group to our user
groupadd -g 999 docker
user=$1
usermod -aG docker $user

# Add docker completion
curl --create-dirs -L \
	-L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/bash/docker \
	-o /etc/bash_completion.d/docker

# Add docker compose completion
curl --create-dirs -L \
	https://raw.githubusercontent.com/docker/compose/master/contrib/completion/bash/docker-compose \
	-o /etc/bash_completion.d/docker-compose

# Add kubectl
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
	KUBECTL_ARCH="arm64"
else
	KUBECTL_ARCH="amd64"
fi
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/${KUBECTL_ARCH}/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Man pages on base debian image aren't installed...
apt-install man-db

# tldr for a short form man pages.
pipx install tldr

# Just gitgud
pipx install gitgud

# System info. Nethogs has a bug on trusty so just going to use iftop.
apt-install htop iotop iftop

# For dig, etc.
apt-install dnsutils

# Needed for netstat, etc.
apt-install net-tools

# cheap reverse proxy
apt-install socat

# Packet sniffer for debugging.
apt-install tcpflow tcpdump

# Very usefull for finding issues coming from syscalls
apt-install strace

# Install bash tab completion.
apt-install bash-completion

# get lines of code in a directory
apt-install cloc

# pager better than less...
apt-install less

# useful for querying json
apt-install jq

# ping servers
apt-install inetutils-ping

# for figuring out routing issues in the network
apt-install inetutils-traceroute

# To cryptographically sign git commits
apt-install gpg gpg-agent

# replacement for ifconfig
apt-install iproute2

# Expose local servers to the internet. Useful for testing webhooks, oauth,
# etc.
# Using official ngrok download URL
# curl -o /tmp/ngrok.tgz \
# 	https://bin.ngrok.com/ngrok-v3-stable-linux-arm64.tgz
# tar -xvzf /tmp/ngrok.tgz -C /usr/local/bin
# rm /tmp/ngrok.tgz

# Install git from standard repository
# Note: PPA git-core/ppa no longer works reliably with Ubuntu Bionic
apt-install git

# subcommand which opens the branch you're checked out on github.
git clone --depth 1 https://github.com/paulirish/git-open /tmp/git-open
sudo cp /tmp/git-open/git-open /usr/local/bin
rm -rf /tmp/git-open

# Required for so many languages this will simply be included by default.
apt-install build-essential pkgconf bison flex

# Mail client for testing
apt-install swaks

# Add timestamp to history.
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc

# Alias for tree view of commit history.
git config --global alias.tree "log --all --graph --decorate=short --color --format=format:'%C(bold blue)%h%C(reset) %C(auto)%d%C(reset)\n         %C(blink yellow)[%cr]%C(reset)  %x09%C(white)%an: %s %C(reset)'"
# cache is useless to keep
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

