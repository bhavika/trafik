FROM ubuntu:20.04
SHELL ["/bin/bash", "-c"]

USER root

ENV DEBIAN_FRONTEND=noninteractive

ENV AWS_REGION="us-east-1"
ENV USE_GPU=0
ENV DEBIAN_FRONTEND=noninteractive

ARG WANDB_API_KEY
ENV WANDB_API_KEY=$WANDB_API_KEY
ARG WANDB_PROJECT
ENV WANDB_PROJECT=$WANDB_PROJECT
ARG WANDB_USERNAME
ENV WANDB_USERNAME=$WANDB_USERNAME
ENV WANDB_DISABLE_CODE=false

WORKDIR /app
COPY requirements.txt /app/requirements.txt

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends \
            build-essential \
            ccache \
            checkinstall \
            curl \
            git-core \
            libgcc1 \
            libglib2.0-0 \
            openssl \
            software-properties-common \
            unzip \
            util-linux \
            wget \
            zlib1g \
            zlib1g-dev \
            python3.8 \
            python3.8-dev \
            python3-venv \
            vim \
        && apt-get autoremove \
        && apt-get clean \
    && PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" \
    && python3.8 -m venv venv \
    && source venv/bin/activate \
    && python -m pip install -U pip \
    && $PIP_INSTALL torch==1.7.1+cpu torchvision==0.8.2+cpu torchaudio==0.7.2 -f https://download.pytorch.org/whl/torch_stable.html \
    && $PIP_INSTALL torch-scatter torch-cluster torch-spline-conv torch-sparse -f https://pytorch-geometric.com/whl/torch-1.7.1+cpu.html \
    && $PIP_INSTALL -r requirements.txt \
    && rm -r ~/.cache/pip

RUN mkdir models
RUN mkdir output

COPY traffik /app/traffik
COPY tests /app/tests
COPY data /app/data
COPY setup.py /app/setup.py
COPY Makefile /app/Makefile

RUN source venv/bin/activate && pip install .
ENV LC_ALL=C.UTF-8 LANG=C.UTF-8
