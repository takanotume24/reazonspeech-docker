FROM nvcr.io/nvidia/cuda:12.6.1-base-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV PATH="/root/.cargo/bin:${PATH}"

ARG REAZONSPEECH_VERSION

RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    tzdata \
    locales \
    curl  \
    git \
    language-pack-ja \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    build-essential \
    libssl-dev \
    ffmpeg && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    /root/.cargo/bin/rustup default stable

RUN useradd -ms /bin/bash user
USER user
WORKDIR /home/user

RUN git clone https://github.com/reazon-research/ReazonSpeech.git

WORKDIR /home/user/ReazonSpeech
RUN git checkout "tags/v${REAZONSPEECH_VERSION}"

WORKDIR /home/user/
RUN python3 -m pip install --upgrade --no-cache-dir pip setuptools wheel && \
    python3 -m pip install --user --no-cache-dir Cython && \
    python3 -m pip install --user --no-cache-dir ReazonSpeech/pkg/nemo-asr "huggingface-hub==0.23.0" "numpy<2.0.0"

ENV PATH="/home/user/.local/bin:${PATH}"
