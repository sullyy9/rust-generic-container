FROM rust:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt -y upgrade && \
    apt -y install sudo

RUN cargo install cargo-expand && \
    cargo install cargo-modules && \
    rustup component add rust-src && \
    rustup component add rustfmt && \
    rustup component add clippy && \
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz -o /usr/bin/rust-analyzer.gz && \
    gzip -d /usr/bin/rust-analyzer.gz && \
    chmod 755 /usr/bin/rust-analyzer

# Setup default user
ENV USER=developer
RUN useradd --create-home -s /bin/bash -m $USER && echo "$USER:$USER" | chpasswd && adduser $USER sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /home/$USER
USER $USER