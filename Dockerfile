FROM ubuntu:jammy

ARG HOST_USER_ID=1000
RUN apt update --error-on=any && apt -y install sudo wget gnupg2 apt-utils
RUN useradd -m -u $HOST_USER_ID -o -s /bin/bash holoocean
RUN usermod -aG sudo holoocean
RUN echo 'holoocean ALL=(ALL) NOPASSWD:ALL' | EDITOR='tee -a' visudo

RUN export DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/Europe/Budapest /etc/localtime
RUN apt install -y tzdata
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Dependencies
RUN apt install build-essential -y
RUN apt install devscripts -y
RUN apt install equivs -y
RUN apt install build-essential -y
RUN apt install -y --no-install-recommends openssh-client git rsync python-is-python3

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5523BAEEB01FA116

RUN apt install -y software-properties-common
RUN add-apt-repository universe

RUN apt update && apt install -y curl gnupg lsb-release
RUN sh -c 'curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg'
RUN sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu jammy main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null'

RUN apt update --error-on=any
RUN apt dist-upgrade -y

RUN apt install -y ros-iron-ros-base
RUN apt install -y ros-dev-tools

RUN rosdep init

USER holoocean
RUN rosdep update --rosdistro=iron
USER root

RUN apt install -y iproute2

RUN apt install -y apt-utils debconf-utils dialog
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections
RUN apt install -y wireguard resolvconf

RUN apt install -y python3-pip

RUN apt install -y gdbserver
RUN apt install -y gdb

RUN apt install -y ros-iron-rmw-cyclonedds-cpp
RUN apt install -y ros-iron-rclpy
RUN apt install -y ros-iron-geometry-msgs
RUN apt install -y ros-iron-joint-state-publisher-gui
RUN pip install setuptools==58.2.0

RUN apt install -y python3.10-venv

RUN apt install -y vulkan-tools
RUN apt install -y python3-tk

RUN apt install -y ros-iron-rviz2

RUN apt install -y libglm-dev

RUN apt install -y vim

RUN apt install -y ros-iron-tf2-tools
RUN apt install -y ros-iron-tf-transformations
RUN apt install -y ros-iron-robot-state-publisher


COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
