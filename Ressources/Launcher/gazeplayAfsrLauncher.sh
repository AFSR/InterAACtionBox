#!/bin/sh

gsettings set org.gnome.desktop.wm.preferences auto-raise 'true'

version=$(head -n 1 /etc/skel/InterAACtionBox_Interface-linux/bin/configuration.conf | cut -d/ -f3)

"$HOME/$version/lib/jre/bin/java" -cp "$HOME/$version/lib/*" -Djdk.gtk.version=2 net.gazeplay.GazePlayLauncher --afsrgazeplay --user "$HOME"

exit