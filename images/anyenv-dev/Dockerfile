ARG BASE_TAG=noble
ARG USER=yoshwata

ARG FROM_IMG=nvim
FROM ${USER}/${FROM_IMG}:$BASE_TAG

USER ${USER}

ENV NODENV_ROOT=/home/yoshwata/.anyenv/envs/nodenv
ENV GOENV_ROOT=/home/yoshwata/.anyenv/envs/goenv
ENV NODE_VERSION=24.18.0
ENV GO_VERSION=1.26.4
ENV PATH="${NODENV_ROOT}/shims:${GOENV_ROOT}/shims:${PATH}"

RUN sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends gh && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

RUN mkdir -p $HOME/.config/tmux && \
    git clone https://github.com/jonmosco/kube-tmux.git ~/.config/tmux/kube-tmux && \
    git clone https://github.com/anyenv/anyenv ~/.anyenv && \
    $HOME/.anyenv/bin/anyenv install --force-init && \
    mkdir -p $($HOME/.anyenv/bin/anyenv root)/plugins && \
    git clone https://github.com/znz/anyenv-update.git $($HOME/.anyenv/bin/anyenv root)/plugins/anyenv-update && \
    $HOME/.anyenv/bin/anyenv install nodenv && \
    eval "$($HOME/.anyenv/envs/nodenv/bin/nodenv init -)" && \
    $HOME/.anyenv/envs/nodenv/bin/nodenv install $NODE_VERSION && \
    $HOME/.anyenv/envs/nodenv/bin/nodenv local $NODE_VERSION && \
    $HOME/.anyenv/envs/nodenv/bin/nodenv global $NODE_VERSION && \
    npm install --global @openai/codex && \
    $HOME/.anyenv/envs/nodenv/bin/nodenv rehash && \
    $HOME/.anyenv/bin/anyenv install goenv && \
    export PATH="$GOENV_ROOT/bin:$PATH" && \
    eval "$(goenv init -)" && \
    goenv install $GO_VERSION && \
    goenv local $GO_VERSION && \
    goenv global $GO_VERSION

CMD ["/bin/bash"]
