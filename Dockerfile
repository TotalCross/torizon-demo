ARG IMAGE_ARCH=arm32v7
FROM torizon/$IMAGE_ARCH-debian-wayland-base:latest
RUN apt-get update && apt-get install -y git && apt-get install -y build-essential && apt-get install -y wget && apt-get install -y python && apt-get install -y libfontconfig1-dev && apt-get install -y mesa-common-dev
WORKDIR /

# install deps
RUN apt-get install -y build-essential mercurial cmake make autoconf automake \
    libtool libasound2-dev libpulse-dev libaudio-dev libx11-dev libxext-dev \
    libxrandr-dev libxcursor-dev libxi-dev libxinerama-dev libxxf86vm-dev \
    libxss-dev libgl1-mesa-dev libdbus-1-dev libudev-dev \
    libgles2-mesa-dev libegl1-mesa-dev libibus-1.0-dev \
    fcitx-libs-dev libsamplerate0-dev libsndio-dev
RUN apt-get install -y libgles1-mesa-dev || apt-get -f install
RUN apt-get install -y libwayland-dev libxkbcommon-dev wayland-protocols

# install SDL2 from scratch
RUN git clone -b release-2.0.10 --single-branch https://github.com/SDL-mirror/SDL.git SDL
RUN cd SDL && mkdir build && cd build && cmake ../ -DSDL_STATIC=0 -DSDL_SHARED=1 -DSDL_AUDIO=0 -DVIDEO_X11=0 -DVIDEO_WAYLAND=1 -DVIDEO_VIVANTE=1 -DWAYLAND_SHARED=1 && cmake --build .
RUN cd SDL && cd build && make install

COPY ./app /app
WORKDIR /app

ENV SDL_VIDEODRIVER=wayland
ENV LIBGL_ALWAYS_SOFTWARE=1