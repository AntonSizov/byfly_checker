#!/bin/sh
# notify.sh
# (c) init_6 <sudormrfhalt@gmail.com>

user=`ps -C gnome-session -o user=` #find UID user who start gnome-session
pids=`pgrep -u $user gnome-session` #find PID
title=$1
text=$2
timeout=$3

if [ -z "$title" ]; then
echo You need to give me a title >&2
exit 1
fi
if [ -z "$text" ]; then
text=$title
fi
if [ -z "$timeout" ]; then
timeout=60000
fi

for pid in $pids; do
# find DBUS session bus for this session
DBUS_SESSION_BUS_ADDRESS=`grep -z DBUS_SESSION_BUS_ADDRESS \
/proc/$pid/environ | sed -e 's/DBUS_SESSION_BUS_ADDRESS=//'`
# use it
DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
su $user -c "notify-send -u low -t $timeout '$title' '$text' "
done