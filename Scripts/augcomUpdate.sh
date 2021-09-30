NEW_VERSION_LINK=$(curl -s https://api.github.com/repos/AFSR/AugCom-AFSR/releases/latest | grep "browser_download_url.*AugCom*" | cut -d: -f2,3 | tr -d \")

NEW_VERSION=$( echo ${NEW_VERSION_LINK} | cut -d/ -f9)

NEW_VERSION_NO_EXT=$( echo ${NEW_VERSION} | cut -d. -f1)

cd ../dist

echo "\n téléchargement de la version ${NEW_VERSION_NO_EXT} en utilisant le lien ${NEW_VERSION_LINK} \n"

wget $NEW_VERSION_LINK

echo "\n extraction de l'archive ${NEW_VERSION} \n"

tar -zxvf ${NEW_VERSION}

echo "\n supression de l'ancienne version \n"

ls | grep "AugCom.*" | egrep -v "^(${NEW_VERSION_NO_EXT}$)" | xargs rm -r