Intera SDK
==============

Attention
----------
If your workstation is not connected to robot with ethernet cable, the communication delay between the workstation and the robot will be much higher than that of connected. 
The delay may cause timeout during the execution of various programs. 
Therefore, you may want to raise the time limit to prevent timeout error. 
Below is a curated list of locations where a timeout exception can be raised.
-----------
| `/root/ros_ws/src/intera_sdk/intera_interface/src/intera_io/io_interface.py`, line 58
| `/root/ros_ws/src/intera_sdk/intera_interface/src/intera_interface/robot_enable.py`, line 72

The Intera SDK provides a platform for development of custom applications for Intera Robots.

This repository contains metapackages and files for installation/use of the Intera SDK.
Additionally, this repositories contains the Python interface classes and examples for
action servers and control of the Intera Robot from Rethink Robotics.

Supported ROS Versions
------------
- Indigo
- Kinetic
- Melodic
- Noetic

Installation
------------
| Please follow the Getting Started wiki page for instructions on installation of the Intera SDK:
| http://sdk.rethinkrobotics.com/intera/Workstation_Setup

Code & Tickets
--------------

+-----------------+----------------------------------------------------------------------------+
| Documentation   | http://sdk.rethinkrobotics.com/intera/                                     |
+-----------------+----------------------------------------------------------------------------+
| Python API Docs | http://rethinkrobotics.github.io/intera_sdk_docs                           |
+-----------------+----------------------------------------------------------------------------+
| Issues          | https://github.com/RethinkRobotics/intera_sdk/issues                       |
+-----------------+----------------------------------------------------------------------------+
| Contributions   | https://github.com/RethinkRobotics/intera_sdk/blob/master/CONTRIBUTING.md  |
+-----------------+----------------------------------------------------------------------------+

Intera Repository Overview
--------------------------

::

     .
     |
     +-- intera_sdk/          intera_sdk metapackage containing all intera sdk packages
     |
     +-- intera_interface     python API for communicating with Intera-enabled robots
     |   +-- cfg/
     |   +-- scripts/ 
     |   +-- src/
     |
     +-- intera_examples      examples using the Python API for Intera-enabled robots
     |   +-- cfg/
     |   +-- launch/
     |   +-- share/images
     |   +-- scripts/ 
     |   +-- src/
     |
     +-- intera.sh            convenient environment initialization script


Other Intera Repositories
-------------------------
+------------------+-----------------------------------------------------+
| intera_common    | https://github.com/RethinkRobotics/intera_common    |
+------------------+-----------------------------------------------------+

Latest Release Information
--------------------------

http://sdk.rethinkrobotics.com/intera/Release-Changes
