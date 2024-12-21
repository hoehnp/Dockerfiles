FROM scratch
MAINTAINER Patrick Hoehn <hoehnp@gmx.de>

ARG SDK_VERSION
ARG TARGET_VERSION
ADD Jolla-$SDK_VERSION-SailfishOS_Platform_SDK_Chroot-i486.tar / 

COPY mer-tooling-chroot /home/appsupport-root/mer-tooling-chroot
COPY Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.bz2 /home/appsupport-root/Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.bz2
COPY Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.bz2.md5sum /home/appsupport-root/Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.bz2.md5sum

# change uid and guid to run image on circleci 

RUN set -ex; \
 usermod -u 1000 appsupport-root ;\
 groupmod -g 1000 appsupport-root ;\
 usermod -g 1000 appsupport-root ;\
 chown -R appsupport-root:appsupport-root  /home/appsupport-root

# Add nemo in sudoers without password
RUN set -ex; \
  chmod +w /etc/sudoers ; \
  echo "appsupport-root ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers ; \
  chmod -w /etc/sudoers 



USER appsupport-root

RUN set -ex ;\
 sudo zypper ref ;\
 sudo zypper -qn in tar ;\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION \
    /home/appsupport-root/Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.bz2 ;\
 sudo mv -f /home/appsupport-root/mer-tooling-chroot /srv/mer/toolings/SailfishOS-$TARGET_VERSION/mer-tooling-chroot ;\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION-aarch64 \
    https://releases.sailfishos.org/sdk/targets/Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Target-aarch64.tar.7z ;\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION-armv7hl \
    https://releases.sailfishos.org/sdk/targets/Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Target-armv7hl.tar.7z ;\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION-i486 \
    https://releases.sailfishos.org/sdk/targets/Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Target-i486.tar.7z ;\
 sudo rm -rf /var/cache/zypp/* ;\
 sudo rm -rf /srv/mer/targets/SailfishOS-$TARGET_VERSION-armv7hl/var/cache/zypp/* ;\
 sudo rm -rf /srv/mer/targets/SailfishOS-$TARGET_VERSION-i486/var/cache/zypp/*
