#!/bin/bash
sudo apt-get update
sudo apt-get install default-jdk
sudo useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat
wget http://www-eu.apache.org/dist/tomcat/tomcat-9/v9.0.41/bin/apache-tomcat-9.0.41.tar.gz -P /tmp
sudo tar xf /tmp/apache-tomcat-9*.tar.gz -C /opt/tomcat
sudo ln -s /opt/tomcat/apache-tomcat-9.0.41 /opt/tomcat/latest
sudo chown -RH tomcat: /opt/tomcat/latest
sudo sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 export CATALINA_HOME=/opt/tomcat/latest

sudo $CATALINA_HOME/bin/startup.sh
keytool -genkey -alias tomcat -keyalg RSA
cd
cd ..
cd ..
cd opt/tomcat/
sudo chmod +777 latest
cd latest
sudo chmod +777 conf
cd conf
echo enter keystore pass
read pass
pass="\"${pass}\"";
sudo sed -i '71a<Connector SSLEnabled="true" acceptCount="100" clientAuth="false"' server.xml
sudo sed -i '72adisableUploadTimeout="true" enableLookups="false" maxThreads="25"' server.xml
sudo sed -i "73aport="8443" keystoreFile="$HOME/.keystore" keystorePass="$pass"" server.xml
sudo sed -i '74aprotocol="org.apache.coyote.http11.Http11NioProtocol" scheme="https"' server.xml
sudo sed -i '75asecure="true" sslProtocol="TLS" />' server.xml 
sudo $CATALINA_HOME/bin/startup.sh
openssl s_client -connect localhost:8443
