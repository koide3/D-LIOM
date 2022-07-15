FROM ros:melodic

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    git wget nano unzip build-essential libomp-dev python3-pip libmetis-dev \
    ros-melodic-urdf-* ros-melodic-pcl-ros ros-melodic-eigen-conversions \
  # cartographer dependencies
    clang cmake google-mock libboost-all-dev libcairo2-dev libcurl4-openssl-dev \
    libgflags-dev libgoogle-glog-dev liblua5.2-dev libsuitesparse-dev lsb-release \
    ninja-build stow python3-sphinx libceres-dev protobuf-compiler \
  # MKL and TBB
  && wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB \
  && apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && rm GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB \
  && wget https://apt.repos.intel.com/setup/intelproducts.list -O /etc/apt/sources.list.d/intelproducts.list \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libtbb-dev intel-mkl-2020.0-088 \
  && apt-get clean && rm -rf /var/lib/apt/lists/*


WORKDIR /root
RUN git clone https://github.com/borglab/gtsam.git
WORKDIR /root/gtsam
RUN git checkout tags/4.0.3
WORKDIR /root/gtsam/build
RUN cmake .. -DGTSAM_BUILD_EXAMPLES_ALWAYS=OFF -DGTSAM_BUILD_TESTS=OFF -DGTSAM_BUILD_WRAP=OFF -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF
RUN make -j$(nproc) && make install


# abseil
WORKDIR /root
RUN git clone https://github.com/abseil/abseil-cpp.git
RUN cd abseil-cpp && git checkout 215105818dfde3174fe799600bb0f3cae233d0bf # 20211102.0
WORKDIR /root/abseil-cpp/build
RUN cmake -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DCMAKE_INSTALL_PREFIX=/usr/local/stow/absl \
  ..
RUN ninja && ninja install
RUN cd /usr/local/stow && stow absl

# protobuf
WORKDIR /root
RUN git clone https://github.com/google/protobuf.git
RUN cd protobuf && git checkout tags/v3.4.1
WORKDIR /root/protobuf/build
RUN cmake -G Ninja \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -Dprotobuf_BUILD_TESTS=OFF \
  ../cmake
RUN ninja && ninja install

# OpenCV
WORKDIR /root
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/3.4.13.zip
RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.4.13.zip
RUN unzip opencv.zip && unzip opencv_contrib.zip

WORKDIR /root/opencv_build
RUN cmake -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-3.4.13/modules -DOPENCV_ENABLE_NONFREE=ON ../opencv-3.4.13
RUN make -j$(nproc) && make install

# Avoid LZ4-related build errors
RUN sed -i '9c #include "lz4.h"' /usr/include/flann/util/serialization.h
RUN sed -i '10c #include "lz4hc.h"' /usr/include/flann/util/serialization.h

# catkin_ws
RUN mkdir -p /root/catkin_ws/src
COPY . /root/catkin_ws/src/D-LIOM

WORKDIR /root/catkin_ws
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; catkin_make_isolated -DCMAKE_BUILD_TYPE=Release'

RUN sed -i "6i source \"/root/catkin_ws/devel_isolated/setup.bash\"" /ros_entrypoint.sh

WORKDIR /root/catkin_ws/src/D-LIOM

ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
