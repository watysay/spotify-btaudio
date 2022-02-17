# docker + spotify + btaudio
---





## What is needed on the host
---
Using Docker, the container will access the bluetooth module of the host.
Therefore, a few items are needed:
- unblock the bluetooth (rfkill unblock) and stop/disable bluetooth service on host
- add bluealsa component for the dbus
  > create file /etc/dbus-1/system.d/bluealsa.conf, using the one existing
    in container when bluealsa is installed
- share (or copy) bluetooth configuration for the speaker you use. 
  Once the config with bluetoothctl is done (scan > trust > pair > connect),
  config for the service stay stored in /var/lib/bluetooth. This config 
  enable auto-reconnect, for example when speaker is started after the container.
  If this config does not exists, a script shall run for reconnecting to the 
  speaker at all times (using expect/python for example). You can also
  store this data in a docker volume.
  The best way to create the data is to start the container in interactive mode
  + sharing container /var/lib/bluetooth with volume or host /var/lib/bluetooth.
  Then launch bluetoothctl and register your speaker.   


## TODO
---
- remove stuff from the container
  > see https://cloud.google.com/solutions/best-practices-for-building-containers#build-the-smallest-image-possible for example
- separate librespot container from btaudio container.
  one for each is better + way to use docker-compose


## Credit
---
I was inspired for this experiment and/or found ressources there :
- librespot https://github.com/librespot-org/librespot (obviously)
- pi-btaudio https://github.com/bablokb/pi-btaudio. I used its asound.conf example for building mine.
- Bluealsa dev (https://github.com/Arkq/bluez-alsa) 
  and install instructions from https://www.sigmdel.ca/michel/ha/opi/opipc2_bluetooth_en.html#complie-blueALSA,
  permits the installation where no package is available (i.e. not Raspbian)
- https://github.com/kevineye/docker-librespot https://github.com/balenalabs/balena-sound
