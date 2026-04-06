#!/bin/bash
# setup-dev-env.sh for Monster Pilot Project
# Inspired by Autoware Foundation Setup Scripts

set -e

# --- [ Color Configuration ] ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Monster Pilot Development Environment Setup ===${NC}"

# 1. Update System
echo -e "${GREEN}[1/6] Updating System Packages...${NC}"
sudo apt update && sudo apt upgrade -y

# 2. Install Essential Tools
echo -e "${GREEN}[2/6] Installing Essential Tools (Git, Curl, Pip, VCS)...${NC}"
sudo apt install -y git curl python3-pip python3-vcstool colcon-common-extensions wget build-essential

# 3. Install ROS 2 (Humble/Jazzy - Defaulting to Humble for Stability)
if [ ! -d "/opt/ros/humble" ]; then
    echo -e "${GREEN}[3/6] Installing ROS 2 Humble...${NC}"
    sudo apt install software-properties-common -y
    sudo add-apt-repository universe -y
    sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
    sudo apt update && sudo apt install -y ros-humble-desktop ros-dev-tools
else
    echo -e "${YELLOW}>> ROS 2 Humble is already installed. Skipping...${NC}"
fi

# 4. GPU Setup (NVIDIA Drivers & CUDA)
# Warning: This part requires a reboot to take effect
if ! command -v nvidia-smi &> /dev/null; then
    echo -e "${GREEN}[4/6] Installing NVIDIA Drivers & CUDA Toolkit...${NC}"
    sudo ubuntu-drivers autoinstall
    sudo apt install -y nvidia-cuda-toolkit
    echo -e "${RED}!! NVIDIA Drivers installed. A REBOOT is required after this script. !!${NC}"
else
    echo -e "${YELLOW}>> NVIDIA Driver detected. Skipping...${NC}"
fi

# 5. Python Libraries for Monster Pilot (MCD, ACO, SST)
echo -e "${GREEN}[5/6] Installing Python Libraries (Numerical & Planning)...${NC}"
pip3 install --upgrade pip
pip3 install numpy scipy matplotlib scikit-learn pandas

# 6. Workspace Initialization
echo -e "${GREEN}[6/6] Initializing MonsterXPilot Workspace...${NC}"
if [ -f "monster.repos" ]; then
    vcs import src < monster.repos
    sudo rosdep init || true
    rosdep update
    rosdep install --from-paths src --ignore-src -y
else
    echo -e "${RED}>> monster.repos not found! Skipping vcs import...${NC}"
fi

echo -e "${YELLOW}--------------------------------------------------${NC}"
echo -e "${GREEN}SUCCESS: Monster Pilot Environment is ready!${NC}"
echo -e "${YELLOW}Action Required: Run 'source /opt/ros/humble/setup.bash' and Reboot if GPU was installed.${NC}"
