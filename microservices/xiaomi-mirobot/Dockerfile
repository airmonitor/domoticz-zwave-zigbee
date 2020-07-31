FROM debian:stable

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"

RUN \
 echo "**** install runtime packages ****" && \
 apt-get clean && \
 apt-get update && \
 apt-get install -y --no-install-recommends \
	curl \
	cron \
	libc6 \
	libcap2-bin \
	libcurl3-gnutls \
	libcurl4 \
	libpython3.7 \
	libudev-dev \
	libusb-0.1-4 \
	mosquitto-clients \
	python3-pip \
	python3-requests \
    python3-setuptools \
    python3-dev \
	unzip \
	wget \
	ca-certificates \
	zlib1g && \
 echo "**** Set timezone ****" && \
 ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime && \
 apt-get install -y tzdata && \
 echo "Europe/Rome" | tee /etc/timezone && \
 dpkg-reconfigure --frontend noninteractive tzdata

RUN \
 apt-get install -y --no-install-recommends \
    make \
    gcc \
    g++ \
    libssl-dev \
    git \
    libcurl4-gnutls-dev \
    libusb-dev \
    zlib1g-dev \
    libcereal-dev \
    liblua5.3-dev \
    libffi-dev \
    uthash-dev \
    build-essential \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libsqlite3-dev \
    libreadline-dev \
    libbz2-dev

RUN \
 git clone https://github.com/mrin/domoticz-mirobot-plugin.git xiaomi-mirobot && \
 cd xiaomi-mirobot && \
 pip3 install gevent python-miio msgpack && \
 chmod +x miio_server.py

