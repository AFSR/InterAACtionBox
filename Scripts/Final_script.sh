
# /********************************************************************************************************/
# /* Part1: Internet Connection and deb Libs installation */

# /**
# ** Copy the libs folder to cubic
# **/


# /* IF INTERNET DOESNT WORK
#rm -r /etc/resolv.conf
#touch /etc/resolv.conf
#echo "nameserver 8.8.8.8" > /etc/resolv.conf

cd Libs/

# apt install ./dos2unix_7.4.0-2_amd64.deb ./gconf2_3.2.6-6ubuntu1_amd64.deb ./gconf2-common_3.2.6-6ubuntu1_all.deb ./gconf-service_3.2.6-6ubuntu1_amd64.deb ./gconf-service-backend_3.2.6-6ubuntu1_amd64.deb ./libappindicator1_12.10.1+18.04.20180322.1-0ubuntu1_amd64.deb ./libdbusmenu-gtk4_16.04.1+18.04.20171206-0ubuntu1_amd64.deb ./libgconf-2-4_3.2.6-6ubuntu1_amd64.deb ./libindicator7_12.10.2+16.04.20151208-0ubuntu1_amd64.deb ./TobiiProEyeTrackerManager-2.1.2.deb ./multiarch-support_2.27-3ubuntu1_amd64.deb ./google-chrome-stable_current_amd64.deb ./xdotool_3.20160805.1-4_amd64.deb

echo "deb http://fr.archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu/ focal-security main restricted
deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted
" > /etc/apt/sources.list
apt-get update
apt-get install build-essential
apt-get install ./*.deb
apt-get install google-chrome-stable


# /********************************************************************************************************/
# /* Part2 : Set-Up GazePlay, InteraactionScene and Tobii */

cp -r ~/gazeplay-linux-x64-1.8.1-AFSR /etc/skel/
cd /etc/skel/gazeplay-linux-x64-1.8.1-AFSR/tobiiDrivers/drivers/deps/
apt-get install ./libsqlcipher0_3.4.1-1build1_amd64.deb ./libuv0.10_0.10.22-2_amd64.deb

cd ../
apt install ./tobii_engine_linux-0.1.6.193_rc-Linux.deb ./tobiiusbservice_l64U14_2.1.5-28fd4a.deb

cd ../../lib/jre/bin/
chmod +x java

cd ../../../bin
dos2unix gazeplay-linux.sh


cp -r ~/interaactionBox_Interface-linux /etc/skel/
cd /etc/skel/interaactionBox_Interface-linux/lib/jre/bin/
chmod +x java
cp ~/Ressources/configuration.conf /etc/skel/interaactionBox_Interface-linux/bin/

cd ../../../bin
dos2unix interaactionBoxOS-linux.sh
cd ./scripts/
dos2unix ./*

cp -r ~/dist /etc/skel

# /********************************************************************************************************/
# /* Part3 : Create Desktop Shortcut */

cd /etc/skel
mkdir Desktop
cd Desktop/

cp ~/Ressources/interaactionBoxLauncher /etc/skel/
cd /etc/skel/
chmod +x interaactionBoxLauncher

cd /etc/skel/
mkdir .config
cd .config
mkdir autostart

cp ~/Ressources/interaactionBoxLauncher.desktop /etc/skel/.config/autostart
/etc/skel/
chmod +x interaactionBoxLauncher.desktop

cp interaactionBoxLauncher.desktop /etc/skel/Desktop


# /********************************************************************************************************/
# /* Part4 : Choose the default wallpaper */

cd /usr/share/backgrounds/
cp ~/Ressources/wallpaper_interaactionBox.png /usr/share/backgrounds/

sed -i 's/\<filename\>.*\<\/filename\>/\<filename\>\/usr\/share\/backgrounds\/wallpaper_interaactionBox.png\<\/filename\>/' /usr/share/gnome-background-properties/ubuntu-wallpapers.xml

sed -i 's/<\/wallpapers>/ \<wallpaper\>\n     \<name\>InteraactionBox wallpaper\<\/name\>\n     \<filename\>\/usr\/share\/backgrounds\/wallpaper_interaactionBox.png\<\/filename\>\n     \<options\>zoom\<\/options\>\n     \<pcolor\>#000000\<\/pcolor\>\n     \<scolor\>#000000\<\/scolor\>\n     \<shade_type\>solid\<\/shade_type\>\n \<\/wallpaper\>\n\<\/wallpapers\>/' /usr/share/gnome-background-properties/focal-wallpapers.xml

sed -i "s@picture-uri.*\'@picture-uri = \'file:///usr/share/backgrounds/wallpaper_interaactionBox.png\'@g" /usr/share/glib-2.0/schemas/10_ubuntu-settings.gschema.override

glib-compile-schemas /usr/share/glib-2.0/schemas/


# /********************************************************************************************************/
# /* Part6 : account creation */
echo "yes" > /etc/skel/.config/gnome-initial-setup-done
#adduser localadmin --group sudo

# /********************************************************************************************************/
# /usr/share/gnome-shell/modes$ cat ubuntu.json
# {
#     "parentMode": "user",
#     "stylesheetName": "Yaru/gnome-shell.css",
#     "themeResourceName": "theme/Yaru/gnome-shell-theme.gresource",
#     "debugFlags": ["backtrace-crashes-all"],
#     "enabledExtensions": ["ubuntu-dock@ubuntu.com", "ubuntu-appindicators@ubuntu.com", "desktop-icons@csoriano"]
# }
# /org/gnome/shell/enabled-extensions
#   ['desktop-icons@csoriano']

# /org/gnome/shell/extensions/desktop-icons/icon-size
#   'large'

# /org/gnome/shell/extensions/desktop-icons/show-home
#   false

# /org/gnome/shell/extensions/desktop-icons/show-trash
#   false

# /org/gnome/desktop/interface/show-battery-percentage
#   true

# /org/gnome/shell/extensions/dash-to-dock/dock-fixed
#   false

# /org/gnome/shell/extensions/dash-to-dock/show-running
#   false

# /org/gnome/shell/extensions/dash-to-dock/show-apps-at-top
#   false

# /org/gnome/shell/extensions/dash-to-dock/show-show-apps-button
#   false

# /org/gnome/shell/extensions/dash-to-dock/show-favorites
#   false

# /org/gnome/shell/extensions/dash-to-dock/show-mounts
#   false

# /org/gnome/desktop/wm/preferences/button-layout
#   ':close'

# /org/gnome/desktop/wm/preferences/action-double-click-titlebar
#   'none'

# /org/gnome/desktop/wm/preferences/action-right-click-titlebar
#   'none'

# /org/gnome/desktop/wm/preferences/action-middle-click-titlebar
#   'none'

#Do it also for dock and for show-trash false and show-home false

# cd /usr/share/polkit-1/actions/
# gedit org.freedesktop.NetworkManager.policy
# System policy prevents modification of netwrk settings for all users
# and change to <allow_active>yes</allow_active>


# /********************************************************************************/
# /* ICONS
cd /usr/share/icons/
mkdir interaaction
cp ~/Ressources/icons/* /usr/share/icons/interaaction
