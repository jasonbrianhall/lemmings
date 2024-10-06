#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect the operating system
if command_exists dnf; then
    # Fedora
    echo "Detected Fedora system"
    sudo dnf update -y
    sudo dnf install -y g++ pkgconfig freeglut-devel glew-devel mesa-libGL-devel mesa-libGLU-devel SOIL-devel
elif command_exists apt-get; then
    # Ubuntu
    echo "Detected Ubuntu system"
    sudo apt-get update
    sudo apt-get install -y g++ pkg-config freeglut3-dev libglew-dev libgl1-mesa-dev libglu1-mesa-dev libsoil-dev
else
    echo "Unsupported operating system. This script works only on Red Hat/Fedora/Clones and Ubuntu/Clones."
    exit 1
fi

echo "Dependencies installed successfully."

# Note about FMOD
echo "Please note: FMOD is not included in this installation script."
echo "You need to download and install FMOD separately from https://www.fmod.com/"
echo "Place the FMOD files in the './fmodstudioapi20224linux' directory as specified in the configure script."

