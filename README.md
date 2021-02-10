# MATLAB Interface for Desktop Docker Client

## Description
A set of MATLAB functions to create and manage Docker images and containers through the Desktop Docker Client. With these functions you can create Docker images from Dockerfiles; create, run, and dispose of Docker containers from Docker images.

## System Requirements
This toolbox requires the Docker client API installed on your host computer (Windows, Linux, or OSX). You download or get instructions to install Docker for your respecitve host computer from [Get Docker](https://docs.docker.com/get-docker/).

## Download
To get and install this Add-On, search for this Add-On on [MathWorks File Exchange](https://www.mathworks.com/matlabcentral/fileexchange/) or in the [Add-On Explorer](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html) in MATLAB. You can install the ```MATLABInterfaceForDockerDesktopClient.mltbx``` from this repository, be it is recommended using the other options to get better visibility and ratings for other users.

## Features
This toolbox includes a set of functions that enable you to control and interact with Docker images and containers running in your host computer Docker client.

**```docker```** - Package
- ```build``` - Build an image from a Dockerfile.
- ```commit``` - Create a new image from a container’s changes.
- ```cp``` - Copy files/folders between a container and the local filesystem.
- ```create``` - Create a new container.
- ```exec``` - Run a command in a running container.
- ```images``` - List images.
- ```info``` - Display system-wide information.
- ```inspect``` - Return low-level information on Docker objects.
- ```kill``` - Kill one or more running containers.
- ```ps``` - List containers.
- ```pull``` - Pull an image or a repository from a registry.
- ```rename``` - Rename a container.
- ```rm``` - Remove one or more containers.
- ```rmi``` - Remove one or more images.
- ```run``` - Run a command in a new container.
- ```search``` - Search the Docker Hub for images.
- ```start``` - Start one or more stopped containers.

Using these functions, you can create and run a Docker container from within MATLAB:
```
>> docker.pull("ubuntu:latest");
>> docker.create("ubuntu:latest","echo","Hello MATLAB!","name","my_bash_terminal");
>> docker.start("my_bash_terminal","attach",true)   % prints out Hello MATLAB!
>> docker.rm("my_bash_terminal","force",true);
```

For information on any of the functions, use the command line help function followed by the name of the function.
```
>> help docker.run
```

Copyright 2021 The MathWorks, Inc.
