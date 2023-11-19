ARG PARENT_IMAGE=ubuntu:20.04
FROM $PARENT_IMAGE

RUN sudo apt-get -qy install net-tools

# Build Source
RUN ["/bin/bash", "-c", \
 "source /opt/ros/noetic/setup.bash && \
  cd ~/ros_ws && \
  catkin_make"]

# Copy the modified intera script configured for ros-noetic
COPY intera.sh /root/ros_ws/intera.sh

COPY intera_sdk /root/ros_ws/src/intera_sdk

COPY sawyer_robot.rosinstall /root/ros_ws/src/sawyer_robot.rosinstall

# Install and Build Sawyer Moveit Repo. Instructions obtained from:
# http://sdk.rethinkrobotics.com/intera/MoveIt_Tutorial

RUN ["/bin/bash", "-c", \
  "cd ~/ros_ws/ && \
  ./intera.sh && \
  cd ~/ros_ws/src && \
  wstool init . && \
  git clone https://github.com/RethinkRobotics/sawyer_robot.git && \	
  wstool merge sawyer_robot.rosinstall && \
  wstool update && \
  cd ~/ros_ws/ && \
  source /opt/ros/noetic/setup.bash && \
  catkin_make"]

#  wstool merge https://raw.githubusercontent.com/RethinkRobotics/sawyer_moveit/becef615db853e156b8444bb343127d99d97fddc/sawyer_moveit.rosinstall && \
COPY docker-entrypoint.sh /root/
COPY sawyer-robot.launch /root/

ENTRYPOINT ["/root/docker-entrypoint.sh"]
