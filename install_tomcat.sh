#!/bin/bash
sudo apt-get update
sudo apt-get install default-jdk
wget http://www-eu.apache.org/dist/tomcat/tomcat-9/v9.0.41/bin/apache-tomcat-9.0.41.tar.gz -P /tmp
sudo tar xf /tmp/apache-tomcat-9*.tar.gz -C /opt/tomcat
sudo ln -s /opt/tomcat/apache-tomcat-9.0.41 /opt/tomcat/latest
sudo chmod +x /opt/tomcat/latest/bin/*.sh
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 export CATALINA_HOME=/opt/tomcat/latest

sudo $CATALINA_HOME/bin/startup.sh
pass="\"$1\""
keytool -genkey -dname "CN=Mark Smith, OU=Java, O=Oracle, L=Cupertino,S=California, C=US" -keypass $pass -storepass $pass  -alias tomcat -keyalg RSA
cd
cd ..
cd ..
cd opt/tomcat/
sudo chmod +777 latest
cd latest
sudo chmod +777 conf
cd conf
echo enter keystore pass
#sudo sed -i '71a<Connector SSLEnabled="true" acceptCount="100" clientAuth="false"' server.xml
#sudo sed -i '72adisableUploadTimeout="true" enableLookups="false" maxThreads="25"' server.xml
#sudo sed -i "73aport="\"8443\"" keystoreFile="\"$HOME/.keystore\"" keystorePass="$pass"" server.xml
#sudo sed -i '74aprotocol="org.apache.coyote.http11.Http11NioProtocol" scheme="https"' server.xml
#sudo sed -i '75asecure="true" sslProtocol="TLS" />' server.xml 


sudo sed -i '71a<Connector port="8443" protocol="HTTP/1.1" connectionTimeout="20000" redirectPort="8443"' server.xml
sudo sed -i '72aSSLEnabled="true" scheme="https" secure="true" sslProtocol="TLS"' server.xml
sudo sed -i "73a keystoreFile="\"$HOME/keystore\"" keystorePass="$pass" />" server.xml


sudo $CATALINA_HOME/bin/startup.sh
openssl s_client -connect localhost:8443
