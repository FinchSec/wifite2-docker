FROM finchsec/kali:base
LABEL org.opencontainers.image.authors="thomas@finchsec.com"
# hadolint ignore=DL3005,DL3008,DL4006,SC2046
RUN apt-get update && \
    apt-get dist-upgrade -y && \
        apt-get install debconf-utils adduser -y --no-install-recommends && \
		echo "wireshark-common	wireshark-common/install-setuid	boolean boolean false" | debconf-set-selections && \
		DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tshark && \
        apt-get install -y --no-install-recommends \
            ca-certificates unzip wget aircrack-ng iw iproute2 libpcap0.8 kmod macchanger \
            reaver bully john cowpatty hcxdumptool hcxtools pixiewps rfkill pciutils usbutils \
            $([ "$(uname -m)" != "armv7l" ] && echo hashcat-utils hashcat pocl-opencl-icd) \
			$([ "$(uname -m)" = "x86_64" ] && echo intel-opencl-icd) && \
        wget -nv "https://github.com/kimocoder/wifite2/archive/refs/heads/master.zip" -O /wifite2.zip && \
        wget -nv "https://github.com/vanhoefm/ath_masker/archive/refs/heads/master.zip" -O /root/ath_masker.zip && \
        unzip -d / /wifite2.zip && rm /wifite2.zip && mv /wifite2-master /wifite2 && \
        unzip -d /root/ /root/ath_masker.zip && rm /root/ath_masker.zip && mv /root/ath_masker-master /root/ath_masker && \
        grep -v setuptools /wifite2/requirements.txt > reqs.txt && mv reqs.txt /wifite2/requirements.txt && \
        apt-get purge unzip debconf-utils -y && \
        apt-get autoclean && \
        apt-get autoremove -y && \
		rm -rf /var/lib/dpkg/status-old /var/lib/apt/lists/*
WORKDIR /wifite2
# hadolint ignore=DL3008
RUN apt-get update && \
        apt-get install python3-pip python3-setuptools ca-certificates -y --no-install-recommends && \
        pip3 install --no-cache-dir -r /wifite2/requirements.txt  && \
        python3 /wifite2/setup.py install && \
        apt-get purge python3-pip ca-certificates -y && \
        apt-get install python3-pkg-resources -y --no-install-recommends && \
        apt-get autoclean && \
        apt-get autoremove -y && \
		rm -rf /var/lib/dpkg/status-old /var/lib/apt/lists/*
CMD [ "/usr/sbin/wifite" ]