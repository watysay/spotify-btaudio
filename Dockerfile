FROM ubuntu:latest
RUN apt-get update && apt-get install --no-install-recommends -y \
    alsa-utils \
    bluez \
    build-essential \
    libtool \
    libasound2-dev \
    libbluetooth-dev \
    libbsd-dev \
    libdbus-1-dev \
    libfdk-aac-dev \
    libglib2.0-dev \
    libmp3lame-dev \
    libmpg123-dev \
    libncurses5-dev \
    libreadline-dev \
    libsbc-dev \
    autoconf \
    automake \
    curl \
    wget \
    gnupg \
    unzip

# installing bluealsa
WORKDIR /root
RUN wget --no-check-certificate -O master.zip https://github.com/Arkq/bluez-alsa/archive/master.zip \
    && unzip master.zip \
    && cd bluez-alsa-master \
    && autoreconf --install \
    && mkdir build \
    && cd build \
    && ../configure \
    && make \
    && make install

# installing librespot
RUN apt-get install -y cargo \
    && wget --no-check-certificate -O dev.zip https://github.com/librespot-org/librespot/archive/dev.zip \
    && unzip dev.zip \
    && cd librespot-dev \
    && cargo build --release --no-default-features --features alsa-backend

# preparing start
WORKDIR /root
COPY start-bt.sh ./
ENTRYPOINT [ "/bin/bash", "start-bt.sh" ]
CMD [ "tail", "-f", "/var/spool/librespot.log" ]
# way to run :
#docker run --rm -it --net=host --privileged --env SPEAKER_MAC=xxx -v /var/lib/bluetooth/:/var/lib/bluetooth/ -v /var/run/dbus:/var/run/dbus --name <container name> <image name>
