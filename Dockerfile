FROM debian:jessie

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d && \
  touch /etc/init.d/systemd-logind


RUN mkdir /root/accessibility/
RUN mkdir -p /root/RPMS/chromedriver_linux64/

WORKDIR /root/accessibility/

COPY ./ /root/accessibility/

RUN cp /root/accessibility/chromedriver /root/RPMS/chromedriver_linux64/

RUN \
apt-get update && \
apt-get install -y wget sudo --no-install-recommends && \
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub |apt-key add /root/accessibility/linux_signing_key.pub && \
 echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
apt-get update && \
apt-get install -y \
android-tools-adb \
ca-certificates \
x11vnc \
libgl1-mesa-dri \
xfonts-100dpi \
xfonts-75dpi \
xfonts-scalable \
xfonts-cyrillic \
dbus-x11 \
fonts-ipafont-gothic \
fonts-ipafont-mincho \
ttf-wqy-microhei \
fonts-wqy-microhei \
fonts-tlwg-loma \
fonts-gargi \
xvfb --no-install-recommends && \
apt-get install -y google-chrome-stable && \
apt-get clean autoclean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80

#RUN ./start.sh
CMD ["/root/accessibility/start.sh"]
