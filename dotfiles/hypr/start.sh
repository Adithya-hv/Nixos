#!/usr/bin/env bash


nm-applet --indicator &

wl-clipboard-history -t &

wl-paste --type text --watch cliphist store &

wl-paste --type image --watch cliphist store &

rm "~/.cache/cliphist/db" &
lxqt-policykit-agent &

waybar &

blueman-manager &

dunst &

swww init &

swww img /etc/nixos/wallpapers/MagiNixosWallpaper.png

