## Build status
![Docker Image CI](https://github.com/airmonitor/domoticz-zwave-zigbee/workflows/Docker%20Image%20CI/badge.svg)

## Supported Architectures
* amd64

## Quick reference
Git repository URI: https://github.com/airmonitor/domoticz-zwave-zigbee

Docker image is being build using development domoticz branch with speciffied commmit id in the Dockerfile

## Start
* Update volumes in a docker-compose.yml file for mosquitto, zigbee2mqtt and domoticz
* Update path to the Z-Wave device in domoticz -> devices section
* Update path to the zigbee device in zigbee2mqtt -> devices section

## Note
Please bear in mind that dockerized services will not be as fast as those installed on a bare-metal device.

From my experience I noticed that the speed of turning on lights based on movement sensor decreased by 30%.

As I wanted to have lightning fast experience I'm using bare-metal approach, and dockerized for fast recovery and testing purposes.

