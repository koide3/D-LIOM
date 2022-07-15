# D-LIOM

Original repository: https://github.com/peterWon/D-LIOM


## Build
```bash
cd D-LIOM/docker
./build.sh
```

## Run

### On host:
```bash
roscore
```

### On docker image:
```bash
cd D-LIOM/docker
./run.sh -v $(realpath eee_01.bag):/tmp/eee_01.bag

roslaunch dlio demo_dlio_viral.launch bag_filename:=/tmp/eee_01.bag save_traj_nodes_filename:=/tmp/traj.txt
```

eee_01.bag: https://ntu-aris.github.io/ntu_viral_dataset/

![dliom](https://user-images.githubusercontent.com/31344317/179186793-1815b049-5d39-48e5-9b96-be263b73dd77.gif)
