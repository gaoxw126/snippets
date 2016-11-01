#!/bin/sh

# 更新源
curl http://172.22.0.16:8082/install_repo.bash | bash

sudo apt update
sudo apt install zsh git golang build-essential cmake libboost-all-dev gem ruby-dev lua5.2, liblua5.2
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# 安装 fio
sudo apt install fio

# 安装 clang3.8
sudo apt-get install clang-3.8 llvm-3.8 libclang-3.8-dev

# 这是为了安装 vim 所需的一些依赖，未必是必要的
sudo apt remove vim
sudo apt install vim-nox
sudo apt remove vim-nox

cd ~
git clone https://github.com/vim/vim.git
cd vim
./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp \
            --enable-pythoninterp=yes \
            --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
            --enable-python3interp=yes \
            --with-python3-config-dir=/usr/lib/python3.5/config-x86_64-linux-gnu \
            --enable-perlinterp \
            --enable-luainterp=yes \
            --enable-cscope --prefix=/usr
make VIMRUNTIMEDIR=/usr/share/vim/vim80
sudo make install
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
sudo update-alternatives --set editor /usr/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
sudo update-alternatives --set vi /usr/bin/vim

# 这个现成 ppa 可以支持 vim with python
# sudo apt-add-repository ppa:pi-rho/dev
# sudo apt-get update
# sudo apt-get install vim

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

# install YouCompleteMe
cd ~/.vim/plugged/YouCompleteMe
./install.py --clang-completer

# install color_coded
sudo apt-get install libncurses-dev libz-dev xz-utils libpthread-workqueue-dev
sudo add-apt-repository ppa:ubuntu-toolchain-r/test

# 安装 g++4.9，编译时需要
sudo apt-get update
sudo apt-get install g++-4.9
# Prefer 4.9 to other versions
sudo update-alternatives --remove-all g++
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 50

cd ~/.vim/plugged/color_coded
mkdir build && cd build
cmake ..
make && make install
