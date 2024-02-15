# gym-sawyer
Sawyer environments for reinforcement learning that use the OpenAI Gym
interface, as well as Dockerfiles with ROS to communicate with the real robot
or a simulated one with Gazebo.

This repository is under development, so all code is still experimental.


## Prerequisites

- Host: Ubuntu 20.04
  > **Note:** The container has to share the same IP address as the host so that the robot can locate the container. [Currently, IP sharing only works on linux host](https://docs.docker.com/network/drivers/host/). 
- Install [Docker CE](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce)
- Install [Docker Compose](https://docs.docker.com/compose/install/#install-compose)
- (Optional) Install nvidia-container-toolkit from the [link](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
- Clone this repository in your local workspace


## Docker containers

### Sawyer Simulation 
If you do not need simulation, skip to [Sawyer Robot](#robot) section.
We use Gazebo to simulate Sawyer, so a dedicated GPU is **required**
([see System Requirements](http://gazebosim.org/tutorials?tut=guided_b1&cat=)).
Currently only NVIDIA GPUs are supported.

##### Instructions

1. In the root folder of your cloned repository build the image by running:
  ```
  $ make build-sawyer-nv-sim
  ```
2. After the image is built, run the container:
  ```
  $ make run-sawyer-nv-sim
  ```
3. Gazebo and MoveIt! should open with Sawyer in them

4. To exit the container, type `sudo docker stop sawyer-sim` in a new terminal.

#### Control Sim Sawyer

1. Open a new terminal in the container by running:
  ```
  $ docker exec -it sawyer-sim /bin/bash
  ```
2. Once inside the terminal, run the following commands to execute a keyboard
  controller:
  ```
  $ cd ~/ros_ws
  $ ./intera.sh sim
  $ rosrun intera_examples joint_position_keyboard.py
  ```
3. The following message should appear:
  ```
  Initializing node...
  Getting robot state...
  [INFO] [1544554222.728405, 33.526000]: Enabling robot...
  [INFO] [1544554222.729527, 33.527000]: Robot Enabled
  Controlling joints. Press ? for help, Esc to quit.
  ```
4. Type ? to get the keys that control sawyer.

##### View the header camera in Sim Sawyer

1. Perform the first step from the previous section
2. Once in the container shell, run the following command:
  ```
  rosrun image_view image_view image:=/io/internal_camera/head_camera/image_raw
  ```
  
### <a name='robot'>Sawyer Robot</a>

#### NVIDIA GPU
If the host does not have NIVIDA GPU, skip to [No NVIDIA GPU](#cpu) section.
A dedicated GPU is recommended for rviz and other visualization tools. 
Currently only NVIDIA GPUs are supported.

This section contains instructions to build the docker image and run the docker
container for the Sawyer robot in the ROS environment using an NVIDIA GPU.

##### Instructions

1. Export sawyer hostname, sawyer ip address, and workstation ip address.
  ```
  $ export SAWYER_HOSTNAME=__sawyerhostname__  
  $ export SAWYER_IP=__sawyerip__ 
  $ export WORKSTATION_IP=__workip__ 
  ```
2. In the root folder of your cloned repository build the image by running:
  ```
  $ make build-sawyer-nv-robot
  ```
3. After the image is built, run the container:
  ```
  $ make run-sawyer-nv-robot
  ```
3. Rviz should open with Sawyer in it. Now you can plan and execute trajectories through rviz.

4. To exit the container, type `sudo docker stop sawyer-robot` in a new terminal.

#### <a name="cpu">No NVIDIA GPU</a> 

This section contains instructions to build the docker image and run the docker
container for the Sawyer robot in the ROS environment without using an NVIDIA GPU.

##### Instructions

1. Same as sawyer robot with GPU.

2. In the root folder of your cloned repository build the image by running:
  ```
  $ make build-sawyer-robot
  ```
3. After the image is built, run the container:
  ```
  $ make run-sawyer-robot
  ```
3. Rviz should open with Sawyer in it. Now you can plan and execute trajectories through rviz.

4. To exit the container, type `sudo docker stop sawyer-robot` in a new terminal.

#### Control Sawyer Robot

1. Run `ifconfig | grep 192` on your workstation to identify your IP address. 
2. **If docker supports sharing IP with host (such as Linux host)**, enter the interactive mode by `docker run -it --rm --net=='host' IMAGE_ID` in your container. **If docker does not support sharing IP with host (such as MacOS and Win hosts)**, expose ports when running the container `docker run -it --rm -p 45100:45100 -p 45101:45101 IMAGE_ID`.
3. Open `~/ros_ws/intera.sh`. Ensure `your_ip` is the same as your host's IP address and 'robot_ip' is the same as your robot's IP address. Verify connection by `$ ping $(robot_ip).local`.
5. Redirect to root of our catkin workspace `$ cd ~/ros_ws && source /opt/ros/noetic/setup.bash && catkin_make `
6. Then configure your workstation by `$ cd ~/ros_ws && ./intera.sh && source devel/setup.bash`
7. Identify robot hostname via Identify the robot hostname via `$ env | grep ROS_MASTER_URI` and 
8. View the available rostopics: `rostopic list`
9. Verify if one way communication (robot -> computer) works `rostopic echo /rosout -n 1`
10. Check if one way communication (computer -> robot) working by blinking the head lamp light blink via `rosrun intera_examples lights_blink.py`. **If docker does not support sharing IP with host (such as MacOS and Win hosts)**, locate your python file, e.g., `lights_blink.py` and initialize `rospy.init_node(...)` with `rospy.init_node(node_name,xmlrpc_port=45100, tcpros_port=45101)`.
11. Enable the robot `rosrun intera_interface enable_robot.py -e`

#### Example: control the robot with keyboard by openning an interactive python prompt.
```
python 
# Import the necessary Python modules 
# rospy - ROS Python API
>>> import rospy # intera_interface - Sawyer Python API
>>> import intera_interface # initialize our ROS node, registering it with the Master
>>> rospy.init_node('Hello_Sawyer') # create an instance of intera_interface's Limb class. If forwarding ports, assign ports to `xmlrpc_port` and `tcpros_port`.
>>> limb = intera_interface.Limb('right') # get the right limb's current joint angles
>>> angles = limb.joint_angles() # print the current joint angles
>>> print angles # move to neutral pose
>>> limb.move_to_neutral() # get the right limb's current joint angles now that it is in neutral
>>> angles = limb.joint_angles() # print the current joint angles again
>>> print angles # reassign new joint angles (all zeros) which we will later command to the limb
>>> angles['right_j0']=0.0
>>> angles['right_j1']=0.0
>>> angles['right_j2']=0.0
>>> angles['right_j3']=0.0
>>> angles['right_j4']=0.0
>>> angles['right_j5']=0.0
>>> angles['right_j6']=0.0 # print the joint angle command
>>> print angles # move the right arm to those joint angles
>>> limb.move_to_joint_positions(angles) # Sawyer wants to say hello, let's wave the arm # store the first wave position 
>>> wave_1 = {'right_j6': -1.5126, 'right_j5': -0.3438, 'right_j4': 1.5126, 'right_j3': -1.3833, 'right_j2': 0.03726, 'right_j1': 0.3526, 'right_j0': -0.4259} # store the second wave position
>>> wave_2 = {'right_j6': -1.5101, 'right_j5': -0.3806, 'right_j4': 1.5103, 'right_j3': -1.4038, 'right_j2': -0.2609, 'right_j1': 0.3940, 'right_j0': -0.4281}  # wave three times
>>> for _move in range(3):
      limb.move_to_joint_positions(wave_1)
      rospy.sleep(0.5)
      limb.move_to_joint_positions(wave_2)
      rospy.sleep(0.5)
      quit
>>> quit()
```

### Below under construction, do not read 
### Garage-ROS-Intera 

To run Reinforcement Learning algorithms along with the Sawyer robot, we use
the [garage](https://github.com/rlworkgroup/garage) docker images that include
an extensive library of utilities and primitives for RL experiments.

On top of the garage images, we add the layers for ROS and Intera that work
with Python3 (garage runs with Python3), so we're able to communicate with
Sawyer through ROS communication using the convenient libraries for Python
`rospy`, `intera_interface`, `moveit_commander` and `moveit_msgs`.

Under this schema, two docker containers are needed: one for the simulated or
real sawyer, and another with garage-ros-intera. The former creates the ROS
master while the latter subscribes to the ROS topics to control and visualize
what Sawyer is doing through Reinforcement Learning algorithms.

##### Prerequisites

- Install [Docker CE](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce). 
- Install [Docker Compose](https://docs.docker.com/compose/install/#install-compose). 

Tested on Ubuntu 16.04. It's recommended to use the versions indicated above
for docker-ce and docker-compose.

##### Instructions

In the root of the gym-sawyer repository execute:
```
$ make run-nvidia-sawyer-<type>
```
Where type can be `sim` (run simulated Sawyer on Gazebo) or `robot` (you're
connected to a real Sawyer).

Once the container is up and running (make sure Gazebo is fully initialized if
running simulated Sawyer). Then run:
```
$ make run-garage-<type>-ros RUN_CMD="examples/hello_world_sawyer.py"
```
Where type can be:
  - headless: garage without environment visualization.
  - nvidia: garage with environment visualization using an NVIDIA graphics
    card.
If your computer has an NVIDIA GPU, use this image to render the
environments in garage, and the pre-requisites are the same as for the Sawyer
Simulation image.

You should see Sawyer moving to neutral position and then waving its arm three
times.

The command to execute in the image is specified in the variable `RUN_CMD`.

###### Run your local repository of garage with ros-intera

If you're working with garage in your local repository and would like to
include your latests changes, follow these instructions.

1. Make sure to run build your docker image for garage first. For
  further information, visit [garage](ihttps://github.com/rlworkgroup/garage/blob/master/docker/README.md).
2. Then rebuild and run the garage-ros image:
  ```
  $ make run-garage-<type>-ros RUN_CMD="..."
  ```

