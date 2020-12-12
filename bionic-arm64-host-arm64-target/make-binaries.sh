#! /bin/bash

set -e

# see https://blog.sqreen.com/how-we-built-v8-natively-on-arm/
apt-get install -y \
  apt-file \
  git \
  mlocate \
  ninja-build \
  tar \
  vim-nox \
  wget \
  xz-utils
updatedb
apt-file update

# Latest clang + llvm
wget -q -O - https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang+llvm-11.0.0-aarch64-linux-gnu.tar.xz \
  | tar --strip-components=1 --directory=/usr/local -xJf -

pushd $SOURCE_DIR

# gn binary executable
git clone https://gn.googlesource.com/gn
cd gn
sed -i -e "s/-Wl,--icf=all//" build/gen.py
python build/gen.py
ninja -C out
cd ..

# clang plugin library
wget https://chromium.googlesource.com/chromium/src/+archive/lkgr/tools/clang/plugins.tar.gz
mkdir plugin
cd plugin
tar xf ../plugins.tar.gz
clang++ *.cpp -c -fPIC -Wall -std=c++14 -fno-rtti -fno-omit-frame-pointer
clang -shared *.o -o libFindBadConstructs.so
cp libFindBadConstructs.so /usr/local/lib/
/sbin/ldconfig --verbose

popd
