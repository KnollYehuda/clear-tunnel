#!/bin/bash

docker build -t clear-tunnel .

docker run -it --rm \
           --name "clear-tunnel" \
           --net="host" \
           --user root \
           --privileged \
           --cap-add=NET_ADMIN --device /dev/net/tun \
           -e DISPLAY=${DISPLAY} \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v /home/yehuda/openvpn-profiles:/app/openvpn-profiles \
           -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
           -v $HOME/.Xauthority:/root/.Xauthority \
           clear-tunnel
