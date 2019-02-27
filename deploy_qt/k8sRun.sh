#!/bin/bash

sudo unlink /etc/localtime;
sudo ln -s /usr/share/zoneinfo/Etc/GMT+2 /etc/localtime;
export LD_LIBRARY_PATH=/home/user/qtlibs:/home/user/app;
export QT_PLUGIN_PATH=/home/user/qtlibs/plugins;
export QT_QPA_PLATFORM_PLUGIN_PATH=$QT_QPA_PLATFORM_PLUGIN_PATH:/home/user/qtlibs
#export XDG_RUNTIME_DIR=/tmp/runtime-developer
#export QT_QPA_PLATFORM=minimal

cd /home/user/app;

./app $DockerAppParam;