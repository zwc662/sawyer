ARG PARENT_IMAGE=ubuntu:16.04
FROM $PARENT_IMAGE

RUN ["sudo apt-get install -qy net-tools ping"]

# Install Gazebo. Instructions obtained from:
# http://sdk.rethinkrobotics.com/intera/Gazebo_Tutorial
RUN DEBIAN_FRONTEND=noninteractive apt update && apt -y install \
  gazebo7 \
  ros-noetic-qt-build \
  ros-noetic-gazebo-ros-control \
  ros-noetic-gazebo-ros-pkgs \
  ros-noetic-ros-control \
  ros-noetic-control-toolbox \
  ros-noetic-realtime-tools \
  ros-noetic-ros-controllers \
  ros-noetic-xacro \
  python-wstool \
  ros-noetic-tf-conversions \
  ros-noetic-kdl-parser \
  ros-noetic-sns-ik-lib

# Install Sawyer Simulator.
RUN ["/bin/bash", "-c", \
  "cd ~/ros_ws/src && \
  git clone https://github.com/RethinkRobotics/sawyer_simulator.git && \
  cd ~/ros_ws/src && \
  wstool init . && \
  wstool merge sawyer_simulator/sawyer_simulator.rosinstall && \
  wstool update"]

# Build Source
RUN ["/bin/bash", "-c", \
  "source /opt/ros/noetic/setup.bash && \
  cd ~/ros_ws && \
  catkin_make"]

# Copy the modified intera script configured for ros-noetic
COPY intera.sh /root/ros_ws/intera.sh

# Install and Build Sawyer Moveit Repo. Instructions obtained from:
# http://sdk.rethinkrobotics.com/intera/MoveIt_Tutorial
RUN ["/bin/bash", "-c", \
  "cd ~/ros_ws/ && \
  ./intera.sh && \
  cd ~/ros_ws/src && \
  wstool merge https://raw.githubusercontent.com/RethinkRobotics/sawyer_moveit/becef615db853e156b8444bb343127d99d97fddc/sawyer_moveit.rosinstall && \
  wstool update && \
  cd ~/ros_ws/ && \
  source /opt/ros/noetic/setup.bash && \
  catkin_make"]

# By default, joint_trajectory_action_server (JTS) waits 5.0 seconds 
# for roservices (IKService and FKService specifically) to start up. These
# services are started by "sawyer_world.launch". When we launch both 
# the "sawyer_world" and JTS through launch file, sometimes these services 
# does not start within 5 seconds. 
# To get around this issue, we increase the timeout from 5.0 to 60.0.
RUN ["/bin/bash", "-c", \
  "source /opt/ros/noetic/setup.bash && \
  source ~/ros_ws/devel/setup.bash && \
  sed -i -e '/^ *rospy.wait_for_service/s/5.0/60.0/g' $(rospack find intera_interface)/src/intera_interface/limb.py"]

COPY docker-entrypoint.sh /root/
COPY sawyer-sim.launch /root/

ENTRYPOINT ["/root/docker-entrypoint.sh"]
