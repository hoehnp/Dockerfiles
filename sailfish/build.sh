#!/usr/bin/env bash
set -euo pipefail

SDK_VERSION="latest"
TARGET_VERSION="5.0.0.29"
SDK_NAME="Jolla-$SDK_VERSION-SailfishOS_Platform_SDK_Chroot-i486.tar.bz2"
SDK_URL="http://releases.sailfishos.org/sdk/installers/$SDK_VERSION/$SDK_NAME"


# correct chroot file rights
#wget $SDK_URL
rm -rf SDK_VERSION-SailfishOS_Platform_SDK_Chroot-i486.tar
cp ../$SDK_NAME . 
bunzip2 -f $SDK_NAME
tar xvf Jolla-$SDK_VERSION-SailfishOS_Platform_SDK_Chroot-i486.tar ./home/appsupport-root/.bash_logout ./home/appsupport-root/.bashrc ./home/appsupport-root/.bash_profile ./var/spool/mail/appsupport-root ./etc/group ./etc/passwd

tar --delete --file=Jolla-$SDK_VERSION-SailfishOS_Platform_SDK_Chroot-i486.tar ./home/appsupport-root/.bash_logout ./home/appsupport-root/.bashrc ./home/appsupport-root/.bash_profile ./var/spool/mail/appsupport-root ./etc/group ./etc/passwd ./home/appsupport-root

sed -i 's/100000/1000/g' ./etc/passwd
sed -i 's/100000/1000/g' ./etc/group

tar --append --file=Jolla-$SDK_VERSION-SailfishOS_Platform_SDK_Chroot-i486.tar ./etc/group ./etc/passwd

rm -rf ./home ./var ./etc 

# correct i486 file rights
#wget https://releases.sailfishos.org/sdk/targets-$SDK_VERSION/Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.bz2
cp ../Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.bz2 .
bunzip2 -f Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.bz2
echo "before extracting second time"
tar xvf Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar ./home/appsupport-root/.bash_logout ./home/appsupport-root/.bashrc ./home/appsupport-root/.bash_profile ./var/spool/mail/appsupport-root ./etc/group ./etc/passwd
tar --delete --file=Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar ./home/appsupport-root/.bash_logout ./home/appsupport-root/.bashrc ./home/appsupport-root/.bash_profile ./var/spool/mail/appsupport-root ./etc/group ./etc/passwd ./home/appsupport-root
echo "after extracting second time"
sed -i 's/100000/1000/g' ./etc/passwd
sed -i 's/100000/1000/g' ./etc/group

chown -h 1000 ./home/appsupport-root/ ./home/appsupport-root/.bash_logout ./home/appsupport-root/.bashrc ./home/appsupport-root/.bash_profile ./var/spool/mail/appsupport-root
chgrp -h 1000 ./home/appsupport-root/ ./home/appsupport-root/.bash_logout ./home/appsupport-root/.bashrc ./home/appsupport-root/.bash_profile

tar --append --file=Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar ./home/appsupport-root ./var/spool/mail/appsupport-root ./etc/group ./etc/passwd
bzip2 Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar
md5sum Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.bz2 > Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.bz2.md5sum
rm -rf ./home ./var ./etc

echo "Building image"
docker build \
    --build-arg "SDK_VERSION=$SDK_VERSION" \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    -t "hoehnp/sailfishos-platform-sdk:$TARGET_VERSION" .
echo "Building image: DONE"

# Clean up after yourself
rm Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.bz2 Sailfish_OS-$TARGET_VERSION-Platform_SDK_Chroot-i486.tar

