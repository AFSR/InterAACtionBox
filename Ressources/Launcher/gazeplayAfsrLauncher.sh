#!/bin/sh

version=$(head -n 1 /etc/skel/InterAACtionBox_Interface-linux/bin/configuration.conf | cut -d/ -f3)
File=~/"$version"/run.txt
valueFile=""

if [ -f "$File" ]; then	

	while IFS= read -r line
	do
		valueFile="$line"
	done < "$File"
	
	if [ "$valueFile" = "true" ]; then
	
		exit 0
	
	else
		echo "true" > $File
	
		gsettings set org.gnome.desktop.wm.preferences auto-raise 'true'

		"$HOME/$version/lib/jre/bin/java" -cp "$HOME/$version/lib/*" -Djdk.gtk.version=2 net.gazeplay.GazePlayLauncher --afsrgazeplay --user "$HOME"
		
		echo "false" > $File
	
	fi

else
	echo "true" > $File
	
	gsettings set org.gnome.desktop.wm.preferences auto-raise 'true'

	"$HOME/$version/lib/jre/bin/java" -cp "$HOME/$version/lib/*" -Djdk.gtk.version=2 net.gazeplay.GazePlayLauncher --afsrgazeplay --user "$HOME"
	
	echo "false" > $File
	
fi

exit 0
