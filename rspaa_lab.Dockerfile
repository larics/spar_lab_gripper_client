# =========================================================
# ROS 2 Jazzy + Ubuntu 24.04 RT-compatible Dockerfile
# (Assumes host already runs an RT kernel)
# =========================================================

FROM ros:jazzy-ros-base

ARG ROS_DISTRO=jazzy
SHELL ["/bin/bash", "-c"]

# ---------------------------------------------------------
# Environment setup
# ---------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    ROS_DISTRO=jazzy

# ---------------------------------------------------------
# Install build essentials and useful tools
# ---------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    wget \
    curl \
    vim \
    tmux \
    python3-pip \
    python3-colcon-common-extensions \
    python3-rosdep \
    git \
    nano \
    && rm -rf /var/lib/apt/lists/* \
    iputils-ping \
    net-tools

# Install necessary ROS2 tools and dependencies
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-ament-cmake \
    ros-${ROS_DISTRO}-ament-cmake-python \
    ros-${ROS_DISTRO}-rclcpp \
    ros-${ROS_DISTRO}-launch \
    ros-${ROS_DISTRO}-backward-ros \
    ros-${ROS_DISTRO}-tf2-ros \
    ros-${ROS_DISTRO}-tf2-geometry-msgs \
    ros-${ROS_DISTRO}-tf-transformations \
    ros-${ROS_DISTRO}-angles \
    ros-${ROS_DISTRO}-ur-client-library \
    ros-${ROS_DISTRO}-ur-msgs \
    ros-${ROS_DISTRO}-joint-trajectory-controller \
    ros-${ROS_DISTRO}-joint-state-broadcaster \
    ros-${ROS_DISTRO}-hardware-interface \
    ros-${ROS_DISTRO}-geometry-msgs \
    ros-${ROS_DISTRO}-pluginlib \
    ros-${ROS_DISTRO}-std-msgs \
    ros-${ROS_DISTRO}-std-srvs \
    ros-${ROS_DISTRO}-urdf \
    ros-${ROS_DISTRO}-urdf-parser-plugin \
    ros-${ROS_DISTRO}-urdfdom \
    ros-${ROS_DISTRO}-urdfdom-headers \
    ros-${ROS_DISTRO}-urdfdom-py \
    ros-${ROS_DISTRO}-control* \
    ros-${ROS_DISTRO}-ros2-control* \
    ros-${ROS_DISTRO}-moveit
    
# ---------------------------------------------------------
# Install colcon and vcstool
# ---------------------------------------------------------
RUN pip3 install --no-cache-dir -U colcon-common-extensions vcstool --break-system-packages

# ---------------------------------------------------------
# Create a workspace
# ---------------------------------------------------------
RUN mkdir -p /root/ros2_ws/src
#WORKDIR /root/ros2_ws

# ---------------------------------------------------------
# Download repositories
# ---------------------------------------------------------
WORKDIR /root/ros2_ws/src
RUN git clone https://github.com/larics/spar_lab_gripper_client.git

WORKDIR /root/ros2_ws
SHELL ["/bin/bash", "-c"]
RUN source /opt/ros/jazzy/setup.bash && \
    rosdep install --from-paths src --ignore-src -r -y && \
    colcon build --symlink-install

# ---------------------------------------------------------
# Source setup scripts automatically
# ---------------------------------------------------------
SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc && \
    echo "source /root/ros2_ws/install/setup.bash" >> ~/.bashrc && \
    echo 'alias source_ros2="source /opt/ros/jazzy/setup.bash"' && \
    echo 'alias source_ros2ws="source /root/ros2_ws/install/setup.bash"'

# ---------------------------------------------------------
# Default command
# ---------------------------------------------------------
CMD ["/bin/bash"]