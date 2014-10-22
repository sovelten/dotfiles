#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

systemd --user &

setxkbmap -option "" -layout "br,us" -option grp:shift_caps_toggle -option caps:swapescape
 
xsetroot -cursor_name left_ptr
wallpaperd
dropboxd &
compton &
exec xmonad
