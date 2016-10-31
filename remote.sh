#!/bin/sh

# 更新源
curl http://172.22.0.16:8082/install_repo.bash | bash

sudo apt update
sudo apt install zsh git golang build-essential cmake libboost-all-dev, gem, ruby-dev
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# 安装 fio
sudo apt install fio

# 安装 clang3.8
sudo apt-get install clang-3.8 llvm-3.8 libclang-3.8-dev

# 安装 vim with python，针对 ubuntu 14.04
sudo add-apt-repository ppa:pi-rho/dev
sudo apt-get update
sudo apt install vims

# 安装 tidb 必要依赖
git clone https://github.com/pingcap/docs.git tidb-docs
cd tidb-docs
sudo ./scripts/check_requirement.sh

# 进行 tidb 的编译
cd ~
mkdir tidb-build && cd tidb-build
sh ~/tidb-docs/scripts/build.sh

# 进行 folly 的编译
cd ~
git clone https://github.com/facebook/folly.git
cd folly/folly
git checkout v0.57.0 # 其他版本会出现错误

sudo apt-get install -y \
    g++ \
    automake \
    autoconf \
    autoconf-archive \
    libtool \
    libboost-all-dev \
    libevent-dev \
    libdouble-conversion-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    liblz4-dev \
    liblzma-dev \
    libsnappy-dev \
    make \
    zlib1g-dev \
    binutils-dev \
    libjemalloc-dev \
    libssl-dev \
    libiberty-dev

autoreconf -ivf
./configure
make
make check
sudo make install

mkdir -p /mnt/vdb && mount /dev/vdb1 /mnt/vdb

vim +PlugInstall +qall
