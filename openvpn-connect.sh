#!/bin/bash

# The array of regions
regions=("frankfurt" "ireland" "mumbai" "n-virginia" "ohio" "tel-aviv" "london")

# Function to print help
print_help() {
    echo "Usage: $0 [region]"
    echo "Available regions:"
    for region in "${regions[@]}"; do
        echo "  $region"
    done
}

# Check if --help is provided
if [ "$1" == "--help" ]; then
    print_help
    exit 0
fi

# Check if a region is provided
if [ $# -eq 0 ]; then
    echo "No region provided. Use --help for usage information."
    exit 1
fi

# Store the region in a variable
input=$1

# Iterate over the array and check for a match
for region in "${regions[@]}"; do
    if [ "$input" == "$region" ]; then
        openvpn3 session-start -c "/app/openvpn-profiles/${input}.ovpn"
        exit
    fi
done

echo "The given region is not supported - $input"
