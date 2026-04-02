# Path Coverage Planning for Autonomous Robots

This ROS 2 package, part of the `monsterX_ws`, provides a path planning solution for complete coverage of a defined area. It is suitable for applications like autonomous lawn mowing, field surveying, or cleaning robots. It generates efficient sweep-based paths while avoiding obstacles within a given boundary.

!Path Coverage Simulation
*Simulation of the generated path for an autonomous mower.*

## Overview

The core of this package is the `PathCoveragePlanner`, a Python-based planner that takes a polygonal boundary, a list of obstacle locations, and robot-specific parameters to generate a sequence of waypoints. The goal is to cover the entire safe area, which is the main boundary with obstacles and safety margins removed.

## Features

-   **Area Coverage**: Generates paths to cover a complex polygonal area.
-   **Obstacle Avoidance**: Accounts for circular obstacles within the area, creating a safe travel zone.
-   **Configurable Robot Parameters**: Easily adjust for different robot dimensions (blade/tool width, wheel base) and operational needs (overlap, margins).
-   **Customizable Sweep Angle**: The direction of the coverage sweeps can be configured.
-   **Simulation & Visualization**: Includes a Python script (`path_simulation.py`) to visualize the planned path, the robot's movement, and the covered area.
-   **Coordinate Transformation**: Handles conversion between geographic coordinates (Latitude/Longitude) and a local XY Cartesian plane for planning.

## Source Installation

This project is designed to be set up as part of the `monsterX_ws` workspace. The following instructions will guide you through setting up the complete development environment.

### 1. Prerequisites

-   **Operating System**: Ubuntu 22.04 (Jammy Jellyfish) is recommended.
-   **Hardware**: An NVIDIA GPU is recommended for full functionality, but not strictly required for this package.

The provided setup script will handle the installation of ROS 2, Git, and other necessary tools.

### 2. Setup Workspace & Dependencies

The `monsterX_ws` repository includes a script to automate most of the setup process.

1.  **Clone the main workspace repository:**
    ```bash
    git clone https://github.com/nontanan-linux/monsterX_ws.git
    cd monsterX_ws
    ```

2.  **Run the environment setup script:**
    ```bash
    ./setup-dev-env.sh
    ```
    This script automates the installation of system-wide dependencies, ROS 2, and clones all required repositories (including this one) into the `src` directory.

    > **Note**: If NVIDIA drivers are installed, a system reboot will be required.

3.  **Install Package-Specific Dependencies:**
    This package requires the `shapely` library. The setup script installs many common Python libraries, but you may need to install this one manually.
    ```bash
    pip install shapely
    ```

### 3. Build and Source the Workspace

1.  **Build the packages:**
    From the root of your workspace (`~/monsterX_ws`), run colcon:
    ```bash
    colcon build --symlink-install
    ```
    To build only this package, you can run:
    ```bash
    colcon build --packages-select path_coverage_planning
    ```

2.  **Source the workspace:**
    Before using any of the packages, source the setup file in your terminal:
    ```bash
    source install/setup.bash
    ```
    It's recommended to add this line to your `~/.bashrc` for convenience.

### 4. How to Update the Workspace

To pull the latest changes for all repositories and rebuild:
```bash
cd ~/monsterX_ws
git pull  # Update the main workspace repo and scripts
vcs pull src  # Update all source repos in the 'src' directory
rosdep install --from-paths src --ignore-src -y # Install any new dependencies
colcon build --symlink-install
```

## Usage

### Running the Simulation

To see the planner in action and generate the simulation GIF, first make sure your workspace is sourced:
```bash
source ~/monsterX_ws/install/setup.bash
```
Then, run the simulation script:
```bash
ros2 run path_coverage_planning path_simulation.py
```
This will:
-   Initialize the planner with the configured boundary and obstacles from `path_config.py`.
-   Plan a path.
-   Display a Matplotlib animation of the robot following the path.
-   Save the animation as `pict/path_simulation.gif` in the package directory upon closing the display window.

### Running as a ROS 2 Node

(This section is a placeholder for when the planner is wrapped in a formal ROS 2 node.)

To use the planner in a live ROS 2 system, you would typically launch a node that provides the path as a service or publishes it on a topic.

```bash
# Example launch command
ros2 launch path_coverage_planning planner.launch.py
```

The node would then publish a `nav_msgs/Path` or a custom message containing the waypoints for a robot controller to follow.

## Parameters

The following parameters are used by the planner and can be configured in `path_coverage_planning/scripts/path_config.py`.

### Robot Parameters

| Parameter         | Description                                                              | Default Value |
| ----------------- | ------------------------------------------------------------------------ | ------------- |
| `blade_width`     | The working width of the robot's tool (e.g., mower blade).               | `2.0` m       |
| `wheel_base`      | The distance between the front and rear axles.                           | `1.5` m       |
| `wheel_track`     | The distance between the centers of the wheels on the same axle.         | `1.2` m       |
| `overlap_ratio`   | The fraction of the blade width that should overlap with the previous pass. | `0.1` (10%)   |
| `boundary_margin` | A safety distance to keep from the outer boundary and obstacles.         | `1.0` m       |

### Planner Strategy

| Parameter         | Description                                                              | Default Value |
| ----------------- | ------------------------------------------------------------------------ | ------------- |
| `sweep_angle_deg` | The angle of the main coverage sweeps in degrees (0 = horizontal).       | `0.0`         |
| `start_latlon`    | The desired starting point for the path in Latitude/Longitude.           | (5m, 5m)      |
| `end_latlon`      | The desired ending point for the path in Latitude/Longitude.             | (5m, 7m)      |