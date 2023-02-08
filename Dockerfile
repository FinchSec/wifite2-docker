FROM finchsec/kali:base as builder
# hadolint ignore=DL3005,DL3008
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install wget unzip libpcap-dev build-essential -y && \
    wget https://github.com/kimocoder/reaver-wps-fork-t6x/archive/refs/heads/wifite.zip && \
    unzip wifite.zip
WORKDIR /reaver-wps-fork-t6x-wifite/src
RUN ./configure && \
    make && \
    make install


FROM finchsec/kali:base
# hadolint ignore=DL3005,DL3008
RUN apt-get update && \
    apt-get dist-upgrade -y && \
        apt-get install debconf-utils adduser -y && \
		echo "wireshark-common	wireshark-common/install-setuid	boolean boolean false" | debconf-set-selections && \
		DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tshark && \
        apt-get install -y --no-install-recommends \
            git python3 python3-pip aircrack-ng iw iproute2 net-tools libpcap0.8 kmod macchanger \
            reaver bully john cowpatty hcxdumptool hcxtools pixiewps rfkill pciutils usbutils \
            $([ "$(uname -m)" != "armv7l" ] && echo hashcat-utils hashcat pocl-opencl-icd) \
			$([ "$(uname -m)" = "x86_64" ] && echo intel-opencl-icd) && \
        git clone https://github.com/kimocoder/wifite2 /wifite2 && \
        cd /wifite2 && \
        python3 setup.py install && \
        cd .. && \
        rm -rf wifite2 && \
        git clone https://github.com/vanhoefm/ath_masker /root/ath_masker && \
        apt purge python3-pip git debconf-utils adduser -y
COPY --from=builder /reaver-wps-fork-t6x-wifite/src/reaver /usr/local/sbin/reaver
# Wash is just a symlink to reaver
RUN ln -s /usr/local/sbin/reaver /usr/local/sbin/wash
CMD [ "/usr/sbin/wifite" ]