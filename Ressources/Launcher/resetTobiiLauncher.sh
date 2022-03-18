#!/bin/sh

actualLanguage=$LANG

title="Reset calibration"
text="Do you want to reset the current calibration ?"
text2="Old calibration erased !"
nextButton="Next"

if [ "$actualLanguage" = "fr_FR.UTF-8" ]; then
	title="Réinitialiser calibration"
	text="Voulez-vous réinitialiser la calibration actuelle ?"
	text2="Ancienne calibration effacé !"
	nextButton="Suivant"
fi

zenity --question \
        --title="$title" \
	      --text="$text" \
	      --width=300 \
        --height=100

	      if [ $? -eq 0 ]; then

	          echo "true" > ~/calibration.txt

	          zenity --info \
	                  --title="$title" \
	                  --text="$text2" \
	                  --width=300 \
                    --height=100 \
                    --ok-label "$nextButton"

            if [ $? -eq 0 ]; then

                sh ~/Launcher/tobiiConfigLauncher.sh &
                tobii_config

                sh ~/InterAACtionBox_Interface-linux/bin/scripts/transition.sh ~/InterAACtionBox_Interface-linux/bin/images/transition.gif
                sh ~/InterAACtionGaze/bin/interAACtionGaze-linux-calibration.sh

            else
                exit 0
            fi

	      else
	          exit 0
	      fi
exit 0