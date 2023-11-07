FROM nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04

WORKDIR /workspace

# Install necessary packages, including tmux
RUN apt-get update && apt-get install -y tmux git wget vim sudo make build-essential
RUN git config --global user.email zwc662@gmail.com
RUN git config --global user.name zwc662

ENV DISPLAY=novnc:0.0

RUN wget https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-x86_64.sh
RUN export CONDA_PREFIX=$HOME/anaconda3/
RUN export PATH=$PATH:$CONDA_PREFIX/bin/

# Set the default command to run tmux when the container starts
CMD ["/bin/bash"]
