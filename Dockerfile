FROM debian:stable

# set version label
ARG BUILD_DATE
ARG VERSION
ARG DOMOTICZ_RELEASE=2020.2
ARG CMAKE_VERSION="3.17.0"
ARG BOOST_VERSION="1.72.0"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/config"

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
	unzip \
	wget \
	zlib1g && \
 echo "**** Set timezone ****" && \
 ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime && \
 apt-get install -y tzdata && \
 echo "Europe/Rome" | tee /etc/timezone && \
 dpkg-reconfigure --frontend noninteractive tzdata && \
 apt-get install -y --no-install-recommends \
    make \
    gcc \
    g++ \
    libssl-dev \
    git \
    libcurl4-gnutls-dev \
    libusb-dev \
    python3-dev \
    zlib1g-dev \
    libcereal-dev \
    liblua5.3-dev \
    uthash-dev && \
 echo "**** Compile cmake ****" && \
 apt remove -y --purge --auto-remove cmake && \
 wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz && \
 tar -xzvf cmake-${CMAKE_VERSION}.tar.gz && \
 rm cmake-${CMAKE_VERSION}.tar.gz && \
 cd cmake-${CMAKE_VERSION} && \
 ./bootstrap && \
 make && \
 make install && \
 cd .. && \
 rm -Rf cmake-${CMAKE_VERSION} && \
 echo "**** Build & Install Boost Libraries ****" && \
 apt remove --purge --auto-remove \
    libboost-dev \
    libboost-thread-dev \
    libboost-system-dev \
    libboost-atomic-dev \
    libboost-regex-dev \
    libboost-chrono-dev && \
 mkdir boost && \
 cd boost && \
 wget https://dl.bintray.com/boostorg/release/${BOOST_VERSION}/source/boost_1_72_0.tar.gz && \
 tar xfz boost_1_72_0.tar.gz && \
 cd boost_1_72_0/ && \
 ./bootstrap.sh && \
 ./b2 stage threading=multi link=static --with-thread --with-system && \
 ./b2 install threading=multi link=static --with-thread --with-system && \
 cd ../../ && \
 rm -Rf boost/ && \
 echo "**** Build OpenZwave 1.6+ ****" && \
 git clone https://github.com/OpenZWave/open-zwave open-zwave-read-only && \
 cd open-zwave-read-only && \
 git pull && \
 make -j 3 && \
 make install && \
 cd .. && \
 echo "**** install domoticz ****" && \
 git clone https://github.com/domoticz/domoticz.git -b ${DOMOTICZ_RELEASE} domoticz && \
 cd domoticz && \
 cmake -DBOOST_LIBRARYDIR=/usr/lib/x86_64-linux-gnu -DCMAKE_BUILD_TYPE=Release -DBoost_USE_MULTITHREADED=ON && \
 cmake -USE_STATIC_OPENZWAVE -DCMAKE_BUILD_TYPE=Release CMakeLists.txt && \
 make -j 3 && \
 cp domoticz.sh /etc/init.d && \
 chmod +x /etc/init.d/domoticz.sh && \
 update-rc.d domoticz.sh defaults && \
 sed -i 's/USERNAME=pi/USERNAME=ubuntu/g' /etc/init.d/domoticz.sh && \
 sed -i 's/DAEMON_ARGS="-daemon"/DAEMON_ARGS=" "/g' /etc/init.d/domoticz.sh && \
 echo "**** Removing not necessary apt packages ****" && \
 apt-get remove -y \
 make \
 gcc \
 g++ \
 libssl-dev \
 git \
 libcurl4-gnutls-dev \
 libusb-dev \
 python3-dev \
 zlib1g-dev \
 libcereal-dev \
 liblua5.3-dev \
 uthash-dev && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*
