FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV PATH="/root/.cargo/bin:${PATH}"

ARG REAZONSPEECH_VERSION

RUN mkdir -p /usr/local/reazonspeech

RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    tzdata \
    locales \
    curl  \
    git \
    htop \
    language-pack-ja \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    build-essential \
    libssl-dev \
    ffmpeg \
    screen && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    /root/.cargo/bin/rustup default stable

WORKDIR /usr/local/reazonspeech
RUN git clone https://github.com/reazon-research/ReazonSpeech.git

WORKDIR /usr/local/reazonspeech/ReazonSpeech
RUN git checkout "tags/v${REAZONSPEECH_VERSION}"

WORKDIR /usr/local/reazonspeech
RUN python3 -m venv .venv && \
    . .venv/bin/activate && \
    pip install --upgrade --no-cache-dir pip setuptools wheel && \
    pip install --no-cache-dir Cython && \
    pip install --no-cache-dir ReazonSpeech/pkg/nemo-asr "huggingface-hub==0.23.0" "numpy<2.0.0"

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash", "-c", "source /usr/local/reazonspeech/ReazonSpeech/.venv/bin/activate && exec bash"]
