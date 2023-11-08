# ros_noetic_sawyer

## Pre installation
Install nvidia-container-toolkit from the [link](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

## Docker installation
* Run `docker compose up`

## Development
* All the data outside the `/workspace` directory inside the container are not persistent. Killing the container will result in losing all those data. To save those data, one way is to commit the container to a new image and push the image to the hub
    * First, exit and stop the running containers
      ```
      docker stop <CONTAINER_ID>
      ```
    * Commit the container to a new image
      ```
      docker commit <CONTAINER_ID> <IMAGE_NAME>
      ```
    * Push the image to the hub
      ```
      docker tag <new_image_name>:<tag> <repository_name>/<image_name>:<new_tag>
      docker push <repository_name>/<image_name>:<new_tag>
      ```
       > Note: try not overwriting the `zwc662/ros_noetic_sawyer:latest` image because it is the initial clean version


