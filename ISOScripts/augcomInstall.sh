neutre='\e[0;m'
vert='\e[0;32m'

LATEST_RELEASE_INFO=$(curl -s https://api.github.com/repos/AFSR/AugCom-AFSR/releases/latest)

NEW_VERSION_LINK=$(echo "$LATEST_RELEASE_INFO" | grep "browser_download_url.*AugCom.tar.gz*" | cut -d: -f2,3 | tr -d \")

NEW_VERSION=$( echo "${NEW_VERSION_LINK}" | cut -d/ -f9)

NEW_VERSION_NO_EXT=$( echo ${NEW_VERSION} | cut -d. -f1)

NEW_VERSION_NAME=$(echo "$LATEST_RELEASE_INFO" | grep "name.*AugCom*" | cut -d: -f2,3 | tr -d \" | head -n 1 | tr -d \,)

cd /etc/skel/dist || exit

echo "Download of ${NEW_VERSION_NAME}"

wget $NEW_VERSION_LINK

tar -zxvf "${NEW_VERSION}" >>/etc/skel/log/tarAugCom.log

mv "${NEW_VERSION_NO_EXT}" "${NEW_VERSION_NAME}"

rm *.tar.gz

echo"${vert}Download of AugCom ... Done${neutre}"
