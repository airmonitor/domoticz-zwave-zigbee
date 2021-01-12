FROM ubuntu:20.04

# set version label
ARG BUILD_DATE
ARG VERSION
ARG DOMOTICZ_COMMIT_ID="f9b16e91a0c870064f23aa9002f2c86022749f76"
ARG CMAKE_VERSION="3.17.0"
ARG BOOST_VERSION="1.74.0"
ARG ZIGBEE2MQTT_PLUGIN_VERSION="v.0.2.1"
ARG BOOST_VERSION_UNDERSCORE="1_74_0"

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
    python3-setuptools \
    python3-dev \
	unzip \
	wget \
	ca-certificates \
	rsync \
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
 rm -Rf cmake-${CMAKE_VERSION} &&\
 cmake --version

RUN \
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
 wget https://dl.bintray.com/boostorg/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_UNDERSCORE}.tar.gz && \
 tar xfz boost_${BOOST_VERSION_UNDERSCORE}.tar.gz && \
 cd boost_${BOOST_VERSION_UNDERSCORE}/ && \
 ./bootstrap.sh && \
 ./b2 stage threading=multi link=static --with-thread --with-system && \
 ./b2 install threading=multi link=static --with-thread --with-system && \
 cd ../../ && \
 rm -Rf boost/

RUN \
 echo "**** Build OpenZwave 1.6+ ****" && \
 git clone https://github.com/OpenZWave/open-zwave open-zwave-read-only && \
 cd open-zwave-read-only && \
 git pull && \
 make && \
 make install && \
 rm libopenzwave.a && \
 make && \
 make install && \
 cd ..

RUN \
 echo "**** install domoticz ****" && \
 git clone https://github.com/domoticz/domoticz.git dev-domoticz && \
 cd dev-domoticz && \
 git checkout ${DOMOTICZ_COMMIT_ID} && \
 cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt && \
 make -j 10 && \
 cd / && \
 source=/dev-domoticz  && \
 target=/domoticz && \

 mkdir -p ${target}/backups && \
 mkdir -p ${target}/plugins && \

# copy your domoticz binary to the target location (binary can also be in bin directory)
 rsync -I ${source}/domoticz ${target}/domoticz && \

 rsync -rI ${source}/www/ ${target}/www && \
 rsync -rI ${source}/dzVents/ ${target}/dzVents && \
 rsync -rI ${source}/Config/ ${target}/Config && \
 rsync -rI ${source}/scripts/ ${target}/scripts && \

 rsync -I ${source}/History.txt ${target} && \
 rsync -I ${source}/License.txt ${target} && \
 rsync -I ${source}/server_cert.pem ${target} && \
 rm -fr ${source} && \

 echo "**** Installing domoticz plugins ****" && \
 git clone https://github.com/stas-demydiuk/domoticz-zigbee2mqtt-plugin.git -b ${ZIGBEE2MQTT_PLUGIN_VERSION} /domoticz/plugins/zigbee2mqtt && \
 echo "**** Cleaning files ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

CMD /domoticz/domoticz -www 8080 -sslwww 443 -noupdates -dbase /domoticz_db/domoticz.db
