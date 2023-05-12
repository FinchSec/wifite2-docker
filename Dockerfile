FROM finchsec/kali:base
LABEL org.opencontainers.image.authors="thomas@finchsec.com"
# hadolint ignore=DL3005,DL3008
RUN apt-get update && \
    apt-get dist-upgrade -y && \
        apt-get install debconf-utils adduser -y --no-install-recommends && \
		echo "wireshark-common	wireshark-common/install-setuid	boolean boolean false" | debconf-set-selections && \
		DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tshark && \
        apt-get install -y --no-install-recommends \
            git python3 python3-pip aircrack-ng iw iproute2 net-tools libpcap0.8 kmod macchanger \
            reaver bully john cowpatty hcxdumptool hcxtools pixiewps rfkill pciutils usbutils \
            $([ "$(uname -m)" != "armv7l" ] && echo hashcat-utils hashcat pocl-opencl-icd) \
			$([ "$(uname -m)" = "x86_64" ] && echo intel-opencl-icd) && \
        git clone https://github.com/kimocoder/wifite2 /wifite2 && \
        git clone https://github.com/vanhoefm/ath_masker /root/ath_masker && \
        cd /wifite2 && \
        grep -v setuptools requirements.txt > reqs.txt && mv reqs.txt requirements.txt && \
        pip3 install --no-cache-dir -r requirements.txt  && \
        python3 setup.py install && \
        apt-get purge python3-pip git debconf-utils adduser -y && \
        apt-get autoclean && \
		rm -rf /var/lib/dpkg/status-old /etc/dpkg/dpkg.cfg.d/force-unsafe-io /var/lib/apt/lists/*
CMD [ "/usr/sbin/wifite" ]