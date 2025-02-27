#!/bin/bash

# Function to display help message
show_help() {
    echo -e "\033[1;34mUsage:\033[0m $0"
    echo
    echo -e "\033[1;36mDescription:\033[0m"
    echo "  This script builds and runs the Clear Tunnel Docker container."
    echo
    echo -e "\033[1;33mEnvironment Variables:\033[0m"
    echo -e "  \033[1;32mOPENVPN_PROFILES\033[0m  (Required) Path to the directory containing OpenVPN profiles."
    echo
    echo -e "\033[1;36mExample:\033[0m"
    echo "  export OPENVPN_PROFILES=/path/to/openvpn/profiles"
    echo "  ./start.sh"
    echo
    exit 0
}

# Function to print error messages in red
print_error() {
    echo -e "\033[1;31mError:\033[0m $1"
    exit 1
}

# Check if --help is passed
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
fi

# Ensure OPENVPN_PROFILES is set and not empty
if [ -z "${OPENVPN_PROFILES}" ]; then
    print_error "OPENVPN_PROFILES environment variable is not set or empty. Run '$0 --help' for more information."
fi

# Ensure the path exists
if [ ! -d "${OPENVPN_PROFILES}" ]; then
    print_error "The directory specified in OPENVPN_PROFILES (${OPENVPN_PROFILES}) does not exist."
fi

echo -e "\033[1;32mOPENVPN_PROFILES is set to:\033[0m ${OPENVPN_PROFILES}"

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
