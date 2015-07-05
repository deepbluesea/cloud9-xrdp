#!/bin/bash

set -e

sudo apt-get update

# xrdp
sudo apt-get install -y xrdp
sudo apt-get install -y xfce4
echo xfce4-session >~/.xsession

# required dependencies
sudo apt-get install -y libossp-uuid-dev libpng12-dev libcairo2-dev
# optional dependencies
sudo apt-get install -y libfreerdp-dev libpango1.0-dev libssh2-1-dev libtelnet-dev libvncserver-dev libpulse-dev libssl-dev libvorbis-dev

rm -rf guacamole-server
git clone git://github.com/glyptodon/guacamole-server.git
cd guacamole-server/
autoreconf -fi || autoreconf -fi
./configure --with-init-dir=/etc/init.d
make
sudo make install

cd ..
sudo ldconfig
#/usr/local/sbin/guacd -b 127.0.0.1 -f

# install tomcat
rm -rf apache-tomcat-8.0.23*
wget http://apache.xl-mirror.nl/tomcat/tomcat-8/v8.0.23/bin/apache-tomcat-8.0.23.tar.gz
tar xvfz apache-tomcat-8.0.23.tar.gz
rm apache-tomcat-8.0.23.tar.gz
cd apache-tomcat-8.0.23/webapps
wget http://downloads.sourceforge.net/project/guacamole/current/binary/guacamole-0.9.7.war
mv guacamole-0.9.7.war guacamole.war

mkdir -p ~/.guacamole
cd ~/.guacamole
ln -s ../workspace/guacamole.properties .
ln -s ../workspace/user-mapping.xml .

/home/ubuntu/workspace/apache-tomcat-8.0.23/bin/catalina.sh run