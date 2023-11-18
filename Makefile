.PHONY: build-sawyer-robot run-sawyer-robot

# Path in host where the experiment data obtained in the container is stored
DATA_PATH ?= $(shell pwd)/data
# Set the environment variable MJKEY with the contents of the file specified by
# MJKEY_PATH.
MJKEY_PATH ?= ~/.mujoco/mjkey.txt
# Sets the add-host argument used to connect to the Sawyer ROS master
SAWYER_HOSTNAME=021802CP00071
SAWYER_IP=192.168.0.103
SAWYER_NET = "$(SAWYER_HOSTNAME):$(SAWYER_IP)"
ifneq (":", $(SAWYER_NET))
	ADD_HOST=--add-host=$(SAWYER_NET)
endif

build-sawyer-robot: docker-compose.yml docker/get_intera.sh
	docker/get_intera.sh
	sudo docker-compose build

run-sawyer-robot: build-sawyer-robot
ifeq (,$(ADD_HOST))
	$(error Set the environment variables SAWYER_HOST and SAWYER_IP)
endif
	xhost +local:docker
	sudo docker run \
		--init \
		--rm \
		--name "sawyer-robot" \
		-i
		gym-sawyer/sawyer-robot
