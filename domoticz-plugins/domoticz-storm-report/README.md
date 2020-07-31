# domoticz-storm-report
A Python plugin for Domoticz to access burze.dzis.net API for weather/storm data

## Dependencies
Plugin is using suds SOAP Python library. suds library are already embeded as git submodule

## Installation
* Make sure your Domoticz instance supports Domoticz Plugin System - see more https://www.domoticz.com/wiki/Using_Python_plugins
* Register at https://burze.dzis.net/ and ask author for API key https://burze.dzis.net/?page=kontakt
* Get plugin data into DOMOTICZ/plugins directory (remember to fetch it recursivelly to get all the dependencies)
```
cd YOUR_DOMOTICZ_PATH/plugins
git clone --recursive https://github.com/lrybak/domoticz-storm-report
```
* Restart Domoticz
* Go to Setup > Hardware and create new Hardware with type: domoticz-storm-report
	* Enter name (it's up to you), API key and city you would like to monitor. You can check city availability at https://burze.dzis.net/?page=wyszukiwarka
	* Check every x minutes - how often plugin will check for new data. Data available through API are updated every 15 minutes so it's no need to query API more frequently
	* Monitoring radius (km) - range of query lookup

Plugin comunicates via Domoticz logs. Check logs for feedback about city availability, corectness of api key and so on. After first API lookup plugin will create all the devices
You can add more city to lookup - create another plugin (hardware) instance

## Update
```
cd YOUR_DOMOTICZ_PATH/plugins/domoticz-storm-report
git pull
```
* Restart Domoticz

## Troubleshooting
In case of issues, mostly plugin not visible on plugin list, check logs if plugin system is working correctly.
See Domoticz wiki for resolution of most typical installation issues http://www.domoticz.com/wiki/Linux#Problems_locating_Python

## Contribute
Feel free to test and report issues or other improvements.
If you want to add another language, contact me or prepare pull request with the required change.