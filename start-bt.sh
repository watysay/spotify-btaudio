#!/bin/bash

# start.sh
# starts the execution of the container
# - starts bluetooth daemon
# - create asound.conf for sending sound to bt speaker as default
# - start bluealsa, linking alsa backend to bluetooth
# - connect to bt speaker
# - launch librespot for Spotify Connect

# variables
script_name=${0%.sh}
# set bt speaker mac adress
bt_speaker_mac="${SPEAKER_MAC}"

{
# Start card
hciconfig hci0 up

# start bt daemon 
if ! /usr/sbin/service bluetooth status ; then
  /usr/sbin/bluetoothd &
fi

# making up default asound.conf
cat <<EOF > /etc/asound.conf
pcm.!default "bluealsa"
ctl.!default "bluealsa"
defaults.bluealsa.interface "hci0"
defaults.bluealsa.device "${bt_speaker_mac}"
defaults.bluealsa.profile "a2dp"
EOF

# start bluealsa
bluealsa &

# try to connect to bt audio
#/usr/bin/expect bt-script "${bt_speaker_mac}"
echo -e "connect ${bt_speaker_mac}\nquit\n" | bluetoothctl

} > "${script_name}.log" 2>&1 

# run librespot bg w/ redirection to log file
/root/librespot-dev/target/release/librespot --name "docker-spotify" --backend alsa > /var/spool/librespot.log 2>&1 & 
# let librespot start before looking into file
sleep 2

# stay running
exec "$@"

