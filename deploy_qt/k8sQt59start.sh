#!/bin/bash
DockerQtVersion=Qt5.9.6
DockerAppEnvi=$1
DockerAppName=$2
DockerAppParam=$3
DockerAppPort=$4

/usr/local/appversion/k8sQtStart.sh $DockerQtVersion $DockerAppEnvi $DockerAppName $DockerAppParam $DockerAppPort