FROM rust:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt -y upgrade && \
    apt -y install \
    sudo \
    mingw-w64

# Setup default user
ENV USER=developer
RUN useradd --create-home -s /bin/bash -m $USER && echo "$USER:$USER" | chpasswd && adduser $USER sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN cargo install cargo-expand && \
    cargo install cargo-modules && \
    rustup component add rust-src && \
    rustup component add rustfmt && \
    rustup component add clippy && \
    rustup target add x86_64-pc-windows-gnu &&  \
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz -o /usr/bin/rust-analyzer.gz && \
    gzip -d /usr/bin/rust-analyzer.gz && \
    chown -R developer:developer /usr/bin/rust-analyzer && \
    chmod 775 /usr/bin/rust-analyzer && \
    chown -R developer:developer /usr/local/cargo/

WORKDIR /home/$USER
USER $USER