# ros_noetic

## Pre installation
Install nvidia-container-toolkit from the [link](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

## Docker installation
* Pull image from [zwc662/ros_noetic](https://hub.docker.com/repository/docker/zwc662/ros_noetic/general)
```
docker pull zwc662/ros_noetic:latest
```
* Run `docker compose up`

## Development
* To build the image in the hub, find the [Dockerfile](Dockerfile) and revise [docker-compose.yml](docker-compose.yml)
  *   Comment out the [`image`](https://github.com/zwc662/ros_noetic/blob/00bc51f1527931086c85b95841371422647418d4/docker-compose.yml#L4) field
  *   Revise the field value of [`context`](https://github.com/zwc662/ros_noetic/blob/00bc51f1527931086c85b95841371422647418d4/docker-compose.yml#L6C1-L6C1) to the local directory of this repo
  *   Uncomment the [`build`](https://github.com/zwc662/ros_noetic/blob/00bc51f1527931086c85b95841371422647418d4/docker-compose.yml#L5) field and the two following sub-fields
  * Then run `docker compose up`
  * After composing, find the container id of `ros_noetic-workspace`, then
    ```
    docker exec -it <CONTAINER_ID> /bin/bash
    ```
  * Install [ros-noetic](http://wiki.ros.org/noetic/Installation/Ubuntu)
  * Follow the instructions for [turtlesim](http://wiki.ros.org/turtlesim)
    * Run roscore at background `roscore &`
    * Run turtlesim `rosrun turtlesim turtlesim_node`
  * Open browser and visit `https://localhost:8080/vnc.html` to view the turtlesim GUI
  * Build the image locally
    * Exit and stop the running containers
    * Commit the container to a new image
      ```
      docker commit <CONTAINER_ID>:<IMAGE_NAME>
      ```
* Push the image to the hub
  * `docker tag <new_image_name>:<tag> <repository_name>/<image_name>:<new_tag>`
  * `docker push <repository_name>/<image_name>:<new_tag>`
    
