FROM rseac/miniforge3 as base
ARG CHECKOUT_HASH=1.13.0

# Install Zsh and other useful tools
RUN apt-get update && \
    apt-get install -y zsh tmux && \
    rm -rf /var/lib/apt/lists/*

# Install Chipyard and run ubuntu-req.sh to install necessary dependencies
RUN git clone https://github.com/ucb-bar/chipyard.git && \
        cd chipyard && \
        git checkout $CHECKOUT_HEAD

FROM base AS chipyard-setup 
SHELL ["/bin/bash", "-cl"]

# build chipyard (excluding marshal and firesim)
RUN cd chipyard && \
      /bin/bash build-setup.sh riscv-tools -v --skip-marshal --skip-firesim

FROM chipyard-setup as dev-env
WORKDIR /chipyard/
ENTRYPOINT ["/bin/bash"]


