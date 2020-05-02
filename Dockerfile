FROM    ubuntu:18.04 as build

RUN     sed -i -e 's:# deb-src :deb-src :' /etc/apt/sources.list && \
        apt-get update && \
        export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
        apt-get -y install debconf-utils wget && \
        echo "libvpb1 libvpb1/countrycode string 49" | debconf-set-selections && \
        echo "tzdata tzdata/Areas select Etc"        | debconf-set-selections && \
        echo "tzdata tzdata/Zones/Etc select UTC"    | debconf-set-selections && \
        echo "Etc/UTC" > /etc/timezone && \
        apt-get -y build-dep asterisk

ARG     asterisk_version
RUN     wget -O asterisk.tar.gz http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-${asterisk_version}.tar.gz && \
        tar xzf asterisk.tar.gz && \
        cd asterisk-${asterisk_version} && \
        ./configure --without-dahdi \
        && make ASTDBDIR=/var/lib/asterisk/db -j$(grep -c ^processor /proc/cpuinfo) && make install


FROM    ubuntu:18.04
RUN     apt-get update && \
        apt-get -y install debconf-utils && \
        echo "libvpb1 libvpb1/countrycode string 49" | debconf-set-selections && \
        echo "tzdata tzdata/Areas select Etc"        | debconf-set-selections && \
        echo "tzdata tzdata/Zones/Etc select UTC"    | debconf-set-selections && \
        echo "Etc/UTC" > /etc/timezone && \
        export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
        apt-get -y install libcap2 libedit2 libjansson4 libpopt0 libsqlite3-0 libssl1.1 libsystemd0 liburiparser1 libuuid1 libxml2 libxslt1.1 \
            libjack0 libresample1 libodbc1 libpq5 libsdl1.2debian libcurl4 libgsm1 liblua5.1-0 libgmime-3.0-0 libical3 libiksemel3 libneon27-gnutls \
            libportaudio2 libpri1.4 libradcli4 libspandsp2 libspeex1 libspeexdsp1 libsqlite0 libsrtp2-1 libss7-2.0 libsybdb5 libtonezone2.0 libvorbisfile3 && \
        apt-get clean
COPY --from=build   /var/spool/asterisk /var/spool/asterisk
COPY --from=build   /var/lib/asterisk   /var/lib/asterisk
COPY --from=build   /usr/lib/asterisk   /usr/lib/asterisk
COPY --from=build   /usr/lib/libasteriskpj.so \
                    /usr/lib/libasteriskssl.so \
                    /usr/lib/
COPY --from=build   /usr/sbin/astcanary \
                    /usr/sbin/astdb2bdb \
                    /usr/sbin/astdb2sqlite3 \
                    /usr/sbin/asterisk \
                    /usr/sbin/astgenkey \
                    /usr/sbin/astversion \
                    /usr/sbin/autosupport \
                    /usr/sbin/rasterisk \
                    /usr/sbin/safe_asterisk \
                    /usr/sbin/
VOLUME  [ "/var/lib/asterisk/db" ]
RUN     groupadd -g 999 asterisk && useradd -s /bin/false -d /var/lib/asterisk -g asterisk -u 999 asterisk && \
        mkdir -p /var/run/asterisk /var/log/asterisk && \
        chown -R asterisk:asterisk /var/lib/asterisk && \
        chown -R asterisk:asterisk /var/spool/asterisk && \
        chown -R asterisk:asterisk /var/log/asterisk && \
        chown asterisk:asterisk /var/run/asterisk && \
        ldconfig

ADD    docker-entrypoint.sh /docker-entrypoint.sh

USER 999:999
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD ["asterisk", "-mqf"]
