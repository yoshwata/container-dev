#!/usr/bin/env bash

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

apt-install() {
	sudo apt-get install --no-install-recommends -y "$@"
}

install-tmux() {
	local tmux_tar="tmux-$TMUX_VERSION.tar.gz"
	pushd /tmp
	curl -L -o "/tmp/tmux-$TMUX_VERSION.tar.gz" \
		"https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/$tmux_tar"
	tar xzf "$tmux_tar"
	local tmux_src="/tmp/tmux-$TMUX_VERSION"
	pushd "$tmux_src"
	# libevent is a run-time requirement. *-dev are for the header files.
	# Detect Ubuntu version and set appropriate libevent version
	local libevent_version=2.1-7t64  # Default to Noble/latest
	if grep -q "18.04" /etc/os-release 2>/dev/null || [ "$UBUNTU_RELEASE" == "bionic" ]; then
		libevent_version=2.1-6
	elif grep -q "20.04\|22.04\|24.04" /etc/os-release 2>/dev/null; then
		libevent_version=2.1-7t64
	fi
	echo "Using libevent version: $libevent_version"
	apt-install "libevent-$libevent_version" libevent-dev libncurses-dev
	./configure
	make
	sudo make install
	popd
	rm -rf "$tmux_src"
	rm -rf "$tmux_tar"
	# Keep libevent-dev and libncurses-dev as they provide runtime libraries needed by tmux
	# Alternatively, we could purge only the -dev packages and reinstall the runtime packages
	popd
}

install-powerline() {
	# POWER TMUX - Install via apt
	apt-install python3-powerline powerline

	# powerline-gitstatus is not in apt, so we'll use a system venv for it
	sudo python3 -m venv /opt/powerline-venv
	sudo /opt/powerline-venv/bin/pip install powerline-gitstatus
	# Link the package to system python path
	sudo ln -sf /opt/powerline-venv/lib/python3.*/site-packages/powerline_gitstatus /usr/lib/python3/dist-packages/ || true
}

install-tmate() {
	curl -o /tmp/tmate.tar.gz -L https://github.com/tmate-io/tmate/releases/download/2.2.1/tmate-2.2.1-static-linux-amd64.tar.gz
	tar -xzf /tmp/tmate.tar.gz -C /tmp
	sudo cp /tmp/tmate-2.2.1-static-linux-amd64/tmate /usr/local/bin/tmate
	rm -rf /tmp/tmate*
}

sudo apt-get update

# Fix file permissions from the copy
sudo chown -R $USER:$USER "$HOME/.config"
sudo chown $USER:$USER /home/$USER/.tmux.conf
sudo chown $USER:$USER ~/.tmate.conf

# Need to update package cache...
sudo apt-get update

install-powerline

install-tmux

install-tmate

# Add fzf fuzzy finder
git clone https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Add bashrc addons for powerline and etc.
cat /tmp/bashrc-additions.sh >> "$HOME/.bashrc"
sudo rm /tmp/bashrc-additions.sh

# Cleanup cache
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get autoremove -y
