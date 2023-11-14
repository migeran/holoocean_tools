# HoloOcean Tools

This repository contains scripts for setting up a development environment for the [HoloOcean underwater robotics simulator](https://holoocean.readthedocs.io) and the [HoloOcean ROS2](https://github.com/migeran/holoocean_ros) ROS2 bridge.

Check out our intro video on [Youtube](https://www.youtube.com/watch?v=kyBcfZYSLzc).

## Checking out sources

- Create a ```holoocean``` folder wherever you'd like, but make sure that the holoocean directory is owned by your own user and group, because the scripts will use the same user and group inside the Docker container to access it.

```
export HOLOOCEAN_DIR=/path/to/holoocean
mkdir -p $HOLOOCEAN_DIR
```

- Clone this repository to ```/holoocean/holoocean_tools```:

```
cd $HOLOOCEAN_DIR
git clone https://github.com/migeran/holoocean_tools.git
```

- Run the checkout script to check out additional dependencies:

```
cd $HOLOOCEAN_DIR/holoocean_tools
./checkout.sh
```

## Building with HoloOcean released version

To build with the HoloOcean release version, you only need to run the ```build.sh``` script.

Additionally, you can list all available build tasks with ```build.sh help```, and execute a single build task with ```build.sh <task> selected_only```:

```
cd $HOLOOCEAN_DIR/holoocean_tools
./build.sh
```

## Building HoloOcean development version

To build HoloOcean develop version and it's dependencies, you need to run ``checkout.sh`` as follows:

```
cd $HOLOOCEAN_DIR/holoocean_tools
./checkout.sh --dev-build
```

This command will check out the Unreal Engine 4 and the HoloOcean sources as well.

Then you need to run the ```build_all_from_src.sh``` script. 

Additionally, you can list all available build tasks with ```build_all_from_src.sh help```, and execute a single build task with ```build_all_from_src.sh <task> selected_only```:

```
cd $HOLOOCEAN_DIR/holoocean_tools
./build_all_from_src.sh
```

This command will build every component from source, including Unreal Engine and the HoloOcean sources.

## Test HoloOcean

- To test if HoloOcean was set up correctly, an example scene can be run with the following commands:
```
cd $HOLOOCEAN_DIR/holoocean_tools
./run_holoocean_test.sh
```

## Enter Docker

- Once everything is set up, enter the docker container with the following commands:
```
cd $HOLOOCEAN_DIR/holoocean_tools
./run_holoocean_container.sh
```

## Use Docker In Multiple Terminals

- Once the container is running, enter it from another terminal with the following commands:
```
cd $HOLOOCEAN_DIR/holoocean_tools
./enter_holoocean_container.sh
```

## About Us

This project was implemented as a research project by [Migeran - Software Engineering & Consulting](https://migeran.com).
We are available for new software development projects in Robotics, AR/VR and other domains. If you have any questions, you may [contact us through our website](https://migeran.com/contact).
