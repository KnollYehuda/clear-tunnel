#!/bin/bash

# Function to display help message
show_help() {
    echo "Usage: $0"
    echo
    echo "This script builds and runs the Clear Tunnel Docker container."
    echo
    echo "Environment Variables:"
    echo "  OPENVPN_PROFILES  (Required) Path to the directory containing OpenVPN profiles."
    echo
    echo "Example:"
    echo "  export OPENVPN_PROFILES=/path/to/openvpn/profiles"
    echo "  ./start.sh"
    echo
    exit 0
}

# Check if --help is passed
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
fi

# Ensure OPENVPN_PROFILES is set and not empty
if [ -z "${OPENVPN_PROFILES}" ]; then
    echo "Error: OPENVPN_PROFILES environment variable is not set or empty."
    echo "Run '$0 --help' for more information."
    exit 1
fi
cd "$(dirname "$0")" || exit

docker build -t clear-tunnel .

docker run -it --rm \
           --name "clear-tunnel" \
           --net="host" \
           --user root \
           --privileged \
           --cap-add=NET_ADMIN --device /dev/net/tun \
           -e DISPLAY=${DISPLAY} \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v ${OPENVPN_PROFILES}:/app/openvpn-profiles \
           -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
           -v $HOME/.Xauthority:/root/.Xauthority \
           clear-tunnel
