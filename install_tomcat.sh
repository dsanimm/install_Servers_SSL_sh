#$1 = passkey
#First install dependency default-jdk
#Installs tomcat
#generate key and SSL certificate
#uses sed to insert the SSL config in server.xml

#!/bin/bash
if  [[ ${#1}  < 6 ]] 
        then
	    echo 'Invalid password'
	 exit
fi

sudo apt-get install default-jdk
if [ ! -e /tmp/http://www-eu.apache.org/dist/tomcat/tomcat-9/v9.0.41/bin/apache-tomcat-9.0.41.tar.gz]
	then
		wget http://www-eu.apache.org/dist/tomcat/tomcat-9/v9.0.41/bin/apache-tomcat-9.0.41.tar.gz -P /tmp
fi
sudo tar xf /tmp/apache-tomcat-9*.tar.gz -C /opt/tomcat
sudo ln -s /opt/tomcat/apache-tomcat-9.0.41 /opt/tomcat/latest
sudo chmod +x /opt/tomcat/latest/bin/*.sh

export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 export CATALINA_HOME=/opt/tomcat/latest

sudo $CATALINA_HOME/bin/startup.sh
sudo $CATALINA_HOME/bin/shutdown.sh
 
keytool -genkey -dname "CN=Mark Smith, OU=Java, O=Oracle, L=Cupertino,S=California, C=US" -keypass $1 -storepass $1  -alias tomcat -keyalg RSA

cd /opt/tomcat/
sudo chmod 777 latest
cd latest
sudo chmod 777 conf
cd conf
pass="\"$1\""

sudo sed -i '71a<Connector port="8443" protocol="HTTP/1.1" connectionTimeout="20000" redirectPort="8443"' server.xml
sudo sed -i '72aSSLEnabled="true" scheme="https" secure="true" sslProtocol="TLS"' server.xml
sudo sed -i "73a keystoreFile="\"$HOME/.keystore\"" keystorePass="$pass" />" server.xml


sudo $CATALINA_HOME/bin/startup.sh
openssl s_client -connect localhost:8443
