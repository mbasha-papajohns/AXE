#!/bin/bash

echo "Downloading and installing Maven."
wget -q -O /tmp/apache-maven-3.2.2.tar.gz http://archive.apache.org/dist/maven/maven-3/3.2.2/binaries/apache-maven-3.2.2-bin.tar.gz &&
# verify checksum
echo "87e5cc81bc4ab9b83986b3e77e6b3095 /tmp/apache-maven-3.2.2.tar.gz" | md5sum -c

# install maven
tar xzf /tmp/apache-maven-3.2.2.tar.gz -C /opt/ && \
ln -s /opt/apache-maven-3.2.2 /opt/maven && \
ln -s /opt/maven/bin/mvn /usr/local/bin
#rm -f /tmp/apache-maven-3.2.2.tar.gz


echo "Installing google-chrome..."
apt-get update > /dev/null 2>&1
apt-get install -y google-chrome-stable  > /dev/null 2>&1

echo "Installing Java 8 ..."
# auto validate license
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

# update repos
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 > /dev/null 2>&1
apt-get update > /dev/null 2>&1

# install java
apt-get install oracle-java8-installer -y > /dev/null 2>&1

echo "Dowloading Chrome Web driver and moving to /root/RPMS/chromdriver_linux64 directory"
# Install Chrome WebDriver
CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
# mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
unzip -qq /tmp/chromedriver_linux64.zip -d /root/RPMS/chromedriver_linux64 && \
#rm /tmp/chromedriver_linux64.zip && \
chmod +x /root/RPMS/chromedriver_linux64/chromedriver && \
ln -fs /root/RPMS/chromedriver_linux64/chromedriver /usr/local/bin/chromedriver

echo "Cleaning the tmp directory."

apt-get clean > /dev/null 2>&1
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

echo "Starting Xvfb Process."
`Xvfb :0 -screen 0 1024x768x16 &`

echo "*********************** MAVEN TEST STARTED ****************************"
echo "Wait for few minutes for the process to complete ..."
mvn  test > /dev/null 2>&1
echo "************************ MAVEN TEST END *******************************"
