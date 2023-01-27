neutre='\e[0;m'
vert='\e[0;32m'

LATEST_RELEASE_INFO=$(curl -s https://api.github.com/repos/InteraactionGroup/InteraactionGaze/releases/latest)

NEW_VERSION_LINK=$(echo "$LATEST_RELEASE_INFO" | grep "browser_download_url.*interAACtionGaze-linux*" | cut -d: -f2,3 | tr -d \")

NEW_VERSION=$( echo "${NEW_VERSION_LINK}" | cut -d/ -f9)

NEW_VERSION_NO_EXT=$( echo ${NEW_VERSION} | cut -d. -f1)

NEW_VERSION_NAME="InterAACtionGaze"

cd /etc/skel || exit

echo "Download of ${NEW_VERSION_NAME}"

wget $NEW_VERSION_LINK

tar -zxvf "${NEW_VERSION}" >>/etc/skel/log/tarInterAACtionGaze.log

rm *.tar.gz

mv "${NEW_VERSION_NO_EXT}" "${NEW_VERSION_NAME}"

cd "/etc/skel/${NEW_VERSION_NAME}"
dos2unix bin/* 2>>/etc/skel/log/dos2unix.log
chmod +x lib/jre/bin/java

echo "${vert}Download of InterAACtionGaze ... Done${neutre}"
