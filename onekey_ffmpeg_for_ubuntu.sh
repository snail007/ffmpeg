#!/bin/bash

#ubuntu一键安装ffmpeg脚本

DEFAULT_HOME=/usr/local/ffmpeg

echo -en  Please input ffmeg install directory"\n"[default:/usr/local/ffmpeg]:
read HOME
if [ -z $HOME ] ;then
        HOME=$DEFAULT_HOME;
fi

test -d $HOME || mkdir $HOME

apt-get update
apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev

ffmpeg_sources=$HOME/sources
ffmpeg_build=$HOME/build
ffmpeg_bin=$HOME/bin

test -d $ffmpeg_sources || mkdir $ffmpeg_sources
test -d $ffmpeg_build || mkdir $ffmpeg_build
test -d $ffmpeg_bin || mkdir $ffmpeg_bin

cd $ffmpeg_sources
wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="$HOME/build" --bindir="$HOME/bin"
make
make install
make distclean

cd $ffmpeg_sources
wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
tar xjvf last_x264.tar.bz2
cd x264-snapshot*
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/build" --bindir="$HOME/bin" --enable-static --disable-opencl
PATH="$HOME/bin:$PATH" make
make install
make distclean


apt-get install cmake mercurial
cd $ffmpeg_sources
hg clone https://bitbucket.org/multicoreware/x265
cd $ffmpeg_sources/x265/build/linux
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/build" -DENABLE_SHARED:bool=off ../../source
make
make install
make distclean

cd $ffmpeg_sources
wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master
tar xzvf fdk-aac.tar.gz
cd mstorsjo-fdk-aac*
autoreconf -fiv
./configure --prefix="$HOME/build" --disable-shared
make
make install
make distclean


sudo apt-get install nasm
cd $ffmpeg_sources
wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="$HOME/build" --enable-nasm --disable-shared
make
make install
make distclean

cd $ffmpeg_sources
wget http://downloads.xiph.org/releases/opus/opus-1.1.2.tar.gz
tar xzvf opus-1.1.2.tar.gz
cd opus-1.1.2
./configure --prefix="$HOME/build" --disable-shared
make
make install
make clean

cd $ffmpeg_sources
wget http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.5.0.tar.bz2
tar xjvf libvpx-1.5.0.tar.bz2
cd libvpx-1.5.0
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/build" --disable-examples --disable-unit-tests
PATH="$HOME/bin:$PATH" make
make install
make clean


cd $ffmpeg_sources
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/build/lib/pkgconfig" ./configure \
  --prefix="$HOME/build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/build/include" \
  --extra-ldflags="-L$HOME/build/lib" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree
PATH="$HOME/bin:$PATH" make
make install
make distclean
hash -r
source ~/.profile



















