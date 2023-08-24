FROM ubuntu:latest AS builder

RUN apt update && apt install -y wget p7zip-full squashfs-tools

RUN wget -qO latest_build.txt https://raw.githubusercontent.com/vyos/vyos-rolling-nightly-builds/main/latest_build.txt && \
wget -qO out.iso https://github.com/vyos/vyos-rolling-nightly-builds/releases/download/1.4-rolling-$(cat latest_build.txt)/vyos-1.4-rolling-$(cat latest_build.txt)-amd64.iso

RUN mkdir rootfs && 7z e out.iso filesystem.squashfs -r && \
	unsquashfs -f -d rootfs/ filesystem.squashfs

RUN cd rootfs && \
	sed -i 's/^LANG=.*$/LANG=C.UTF-8/' etc/default/locale && \
	rm -rf boot/* lib/firmware lib/modules/* && \
	ln -s /opt/vyatta/etc/config config && \
	ln -s /dev/null etc/systemd/system/atopacct.service && \
	ln -s /dev/null etc/systemd/system/hv-kvp-daemon.service

FROM scratch
COPY --from=builder rootfs ./
COPY hacks/hostnamectl /usr/local/bin
CMD ["/sbin/init"]
