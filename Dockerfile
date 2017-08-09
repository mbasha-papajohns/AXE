FROM debian:jessie

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update && \
apt-get install -y --no-install-recommends apt-utils && \
echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d && \
touch /etc/init.d/systemd-logind && \
mkdir /root/accessibility/ && \
mkdir -p /root/RPMS/chromedriver_linux64/

WORKDIR /root/accessibility/

COPY ./ /root/accessibility/

RUN \
apt-get update && \
apt-get install -y wget sudo --no-install-recommends && \
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub |apt-key add /root/accessibility/linux_signing_key.pub && \
 echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
apt-get update && \
apt-get install -y \
x11vnc \
libgl1-mesa-dri \
xfonts-100dpi \
xfonts-75dpi \
xfonts-scalable \
xfonts-cyrillic \
fonts-ipafont-gothic \
fonts-ipafont-mincho \
ttf-wqy-microhei \
fonts-wqy-microhei \
fonts-tlwg-loma \
fonts-gargi \
curl \
unzip \
xvfb --no-install-recommends && \
apt-get clean autoclean

ENV MAVEN_HOME /opt/maven
ENV M2_HOME /opt/maven
ENV PATH $PATH:$MAVEN_HOME/bin

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $PATH:$JAVA_HOME/bin
ENV DISPLAY :0

CMD ["/root/accessibility/start.sh"]
