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

#RUN cp /root/accessibility/chromedriver /root/RPMS/chromedriver_linux64/

RUN \
apt-get update && \
apt-get install -y wget sudo --no-install-recommends && \
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub |apt-key add /root/accessibility/linux_signing_key.pub && \
 echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
wget -q -O /tmp/apache-maven-3.2.2.tar.gz http://archive.apache.org/dist/maven/maven-3/3.2.2/binaries/apache-maven-3.2.2-bin.tar.gz && \
apt-get update && \
apt-get install -y \
#android-tools-adb \
#ca-certificates \
x11vnc \
libgl1-mesa-dri \
xfonts-100dpi \
xfonts-75dpi \
xfonts-scalable \
xfonts-cyrillic \
#dbus-x11 \
fonts-ipafont-gothic \
fonts-ipafont-mincho \
ttf-wqy-microhei \
fonts-wqy-microhei \
fonts-tlwg-loma \
fonts-gargi \
curl \
unzip \
xvfb --no-install-recommends && \
apt-get install -y google-chrome-stable && \
apt-get clean autoclean

# verify checksum
RUN echo "87e5cc81bc4ab9b83986b3e77e6b3095 /tmp/apache-maven-3.2.2.tar.gz" | md5sum -c

# install maven
RUN tar xzf /tmp/apache-maven-3.2.2.tar.gz -C /opt/
RUN ln -s /opt/apache-maven-3.2.2 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.2.2.tar.gz
ENV MAVEN_HOME /opt/maven
ENV M2_HOME /opt/maven
ENV PATH $PATH:$MAVEN_HOME/bin

# auto validate license
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

# update repos
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get update

# install java
RUN apt-get install oracle-java8-installer -y

RUN apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Chrome WebDriver
RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
   # mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /root/RPMS/chromedriver_linux64 && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /root/RPMS/chromedriver_linux64/chromedriver && \
    ln -fs /root/RPMS/chromedriver_linux64/chromedriver /usr/local/bin/chromedriver

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $PATH:$JAVA_HOME/bin
ENV DISPLAY :0

CMD ["/root/accessibility/start.sh"]

