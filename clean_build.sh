#!/bin/bash

# ##############################################################################
# # Clean and Build Script for a ROS 2 Workspace
# ##############################################################################
# #
# # This script first removes build/install artifacts and then rebuilds.
# #
# # Usage:
# #   ./clean_build.sh [package_name]
# #
# # - If a package_name is provided, it cleans only that specific package.
# # - If no arguments are given, it cleans the entire workspace (build, install, log).
# #
# # NOTE: This script should be located in and run from the workspace root.
# #
# ##############################################################################

set -e # Exit immediately if a command exits with a non-zero status.

# Check if a package name is provided as an argument
if [ -n "$1" ]; then
    # Clean and build a specific package
    PACKAGE_NAME=$1
    echo "--- Cleaning build artifacts for package: '$PACKAGE_NAME' ---"
    rm -rf "build/$PACKAGE_NAME" "install/$PACKAGE_NAME"

    echo "--- Building package: '$PACKAGE_NAME' ---"
    colcon build --symlink-install --packages-select "$PACKAGE_NAME"
else
    # Clean and build the entire workspace
    echo "--- Cleaning entire workspace (build, install, log) ---"
    rm -rf build install log

    echo "--- Building entire workspace ---"
    colcon build --symlink-install
fi
source install/setup.bash
echo "--- Clean and build complete. ---"